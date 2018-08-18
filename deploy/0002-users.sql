-- Deploy users:0002-users to pg

BEGIN;

  -- Create Users
  CREATE SEQUENCE users_id_seq;
  
  CREATE TABLE IF NOT EXISTS users (
           "id" BIGINT NOT NULL PRIMARY KEY DEFAULT nextval('users_id_seq'),
     "username" TEXT NOT NULL,
        "email" TEXT NULL,
         "lang" CHAR(2) NOT NULL,
     "passpass" TEXT NOT NULL
  );
  
  ALTER SEQUENCE users_id_seq OWNED BY users.id;

  CREATE UNIQUE INDEX users_username_index on users (lower(username));

  ALTER TABLE users ADD CONSTRAINT users_username_check CHECK (username <> ''::text);

  ALTER TABLE words ADD COLUMN userid BIGINT NOT NULL;

  ALTER TABLE words ADD CONSTRAINT userid_fk FOREIGN KEY (userid) REFERENCES users ON DELETE CASCADE;

	CREATE OR REPLACE FUNCTION user_hash_password ()
	RETURNS trigger
	AS $$
	BEGIN
    IF TG_OP = 'INSERT' OR (OLD.passpass != NEW.passpass) THEN
      -- Insert new user or Update password of the user, please encrypt it
      NEW.passpass := crypt(NEW.passpass, gen_salt('bf', 8));
    END IF;

		RETURN NEW;
	END
	$$ LANGUAGE plpgsql;

	CREATE TRIGGER tr_user_hash_password BEFORE INSERT OR UPDATE ON users
	FOR EACH ROW
	EXECUTE PROCEDURE user_hash_password();

COMMIT;
