-- Deploy words:0004-session to pg

BEGIN;

  -- Create Users
  CREATE SEQUENCE IF NOT EXISTS sessions_id_seq;
  
  CREATE UNLOGGED TABLE IF NOT EXISTS sessions (
           "id" BIGINT NOT NULL PRIMARY KEY DEFAULT nextval('sessions_id_seq'),
       "userid" BIGINT NOT NULL UNIQUE REFERENCES users (id) ON DELETE CASCADE,
       "secret" TEXT   NOT NULL
  );

  
  ALTER SEQUENCE sessions_id_seq OWNED BY sessions.id;

	CREATE OR REPLACE FUNCTION auth_check_password (username TEXT, pass TEXT)
	RETURNS BOOLEAN AS $$
	DECLARE passed BOOLEAN;
	BEGIN
		SELECT (crypt($2, u.passpass) = u.passpass) INTO passed
		FROM users u
		WHERE u.username = $1;

		RETURN passed;
	END
	$$ LANGUAGE plpgsql
	SECURITY DEFINER;

	CREATE OR REPLACE FUNCTION auth_jwt_header ()
	RETURNS JSON AS $$
	BEGIN
		RETURN '{"alg": "HS256", "typ": "JWT"}'::json;
	END
	$$ LANGUAGE plpgsql;

	CREATE OR REPLACE FUNCTION auth_jwt_payload (user_id BIGINT)
	RETURNS JSON AS $$
		SELECT json_build_object(
			'username', u.username,
			'email', u.email
		)
		FROM users u
		WHERE u.id = $1
		LIMIT 1;
	$$ LANGUAGE sql;

	CREATE OR REPLACE FUNCTION auth_jwt_signature (header JSON, payload JSON, secret TEXT)
	RETURNS bytea AS $$
		SELECT hmac(
			ENCODE(CONVERT_TO(header::text, 'UTF-8'), 'base64') || '.' ||
			ENCODE(CONVERT_TO(payload::text, 'UTF-8'), 'base64'),
			secret,
			'sha256');
	$$ LANGUAGE sql;

	CREATE OR REPLACE FUNCTION auth_jwt_new (user_id BIGINT)
	RETURNS TEXT AS $$
	DECLARE
		jwt_header JSON;
		jwt_payload JSON;
		jwt_secret TEXT;
	BEGIN
		jwt_header := auth_jwt_header();
    RAISE NOTICE 'JWT new header: %', jwt_header;
		jwt_payload := auth_jwt_payload($1);
    RAISE NOTICE 'JWT new payload: %', jwt_payload;

		-- Creating a new secret
		WITH user_secret_information (secret) AS (
      INSERT INTO
        sessions (userid, secret)
      VALUES
        (user_id, md5(random()::text))
      ON CONFLICT (userid) DO UPDATE
        SET secret = md5(random()::text)
      RETURNING
        secret
		)
    SELECT
      secret INTO jwt_secret
    FROM
      user_secret_information;

		-- Header (based 64 URL, and concat with the point)
		-- type of encryption ({"alg": "HS256", "typ": "JWT"})
		RETURN regexp_replace( ENCODE(CONVERT_TO(jwt_header::text, 'UTF-8'), 'base64') || '.' ||
		-- Payload (based 64 URL, and concat with the point)
		ENCODE(CONVERT_TO(jwt_payload::text, 'UTF-8'), 'base64') || '.' ||
		-- Signature (already in base64 URL)
    ENCODE(CONVERT_TO(auth_jwt_signature(jwt_header, jwt_payload, jwt_secret)::text, 'UTF-8'), 'base64'),
    -- Remove the newline and tabulation characters,
    -- this comes from an old base64 RFC that lines should be no more than 76 chars
    E'[\\n\\r]', '', 'g');
	END
	$$ LANGUAGE plpgsql;

  -- auth_jwt_decode
  -- decode a JWT token, and check the signature.
  -- If it match, then return the userid of the jwt
  CREATE OR REPLACE FUNCTION auth_jwt_decode (jwt TEXT)
  RETURNS BIGINT AS $$
  DECLARE
    jwt_parts TEXT[];
    jwt_header JSON;
    jwt_payload JSON;
    jwt_signature TEXT;
    jwt_username TEXT;
    jwt_user_id BIGINT;
    jwt_user_secret TEXT;
    jwt_signature_truth BYTEA;
    jwt_signature_to_be_verified BYTEA;
  BEGIN
    jwt_parts := regexp_split_to_array( jwt, '\.' );
    IF array_length(jwt_parts, 1) != 3 THEN
      -- The JWT is wrong
      RAISE EXCEPTION 'JWT Malformed' USING ERRCODE = 'P1002';
    ELSE
      jwt_header := CONVERT_FROM( DECODE( (jwt_parts)[1], 'base64') , 'UTF-8' )::JSON;
      jwt_payload := CONVERT_FROM( DECODE( (jwt_parts)[2], 'base64') , 'UTF-8' )::JSON;
      jwt_signature := (jwt_parts)[3];
  
      jwt_username := jwt_payload->>'username';
      SELECT u.id INTO jwt_user_id FROM users u WHERE u.username = jwt_username;

      SELECT secret INTO jwt_user_secret FROM users u join sessions s on u.id = s.userid WHERE u.username = jwt_username;

      SELECT DECODE(jwt_signature, 'base64') INTO jwt_signature_truth;
      SELECT auth_jwt_signature(jwt_header, jwt_payload, jwt_user_secret) INTO jwt_signature_to_be_verified;
      IF CONVERT_TO(jwt_signature_to_be_verified::text, 'UTF-8') = jwt_signature_truth THEN
        RAISE NOTICE 'JWT Signature recomputed and verified';
        -- TODO: if we want to retrieve the jwt payload…
        -- jwt_payload := ('{"user_id": "' || jwt_user_id || '"}')::jsonb || jwt_payload::jsonb;
        RETURN jwt_user_id;
      ELSE
        -- The JWT is wrong
        RAISE EXCEPTION 'JWT Incorrect' USING ERRCODE = 'P1003';
        RETURN 'f';
      END IF;
    END IF;
  END
  $$ LANGUAGE plpgsql;

	CREATE OR REPLACE FUNCTION auth_login (username TEXT, pass TEXT)
	RETURNS TEXT AS $$
	DECLARE
		auth_jwt TEXT;
	BEGIN
		IF auth_check_password(username, pass) THEN
			-- the credentials are correct, we can create JWT
			WITH user_info (id) AS (
				SELECT id
				FROM users u
				WHERE u.username = $1
				LIMIT 1
			)
			SELECT auth_jwt_new(user_info.id) INTO auth_jwt
			FROM user_info;

			RETURN auth_jwt;
		ELSE
			-- wrong credentials
			RAISE EXCEPTION 'Wrong credentials' USING ERRCODE = 'P1001';
		END IF;
	END
	$$ LANGUAGE plpgsql;

COMMIT;
