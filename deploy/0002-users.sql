-- Deploy users:0002-users to pg

BEGIN;

  -- Create Schema Users
  CREATE SEQUENCE users_id_seq;
  
  CREATE TABLE IF NOT EXISTS users (
           "id" BIGINT NOT NULL PRIMARY KEY DEFAULT nextval('users_id_seq'),
     "username" TEXT NOT NULL,
     "passpass" TEXT NOT NULL
  );
  
  ALTER SEQUENCE users_id_seq OWNED BY users.id;

  ALTER TABLE words ADD COLUMN userid BIGINT NOT NULL;

  ALTER TABLE words ADD CONSTRAINT userid_fk FOREIGN KEY (userid) REFERENCES users ON DELETE CASCADE;

	CREATE OR REPLACE FUNCTION user_hash_password ()
	RETURNS trigger
	AS $$
	BEGIN
		NEW.passpass := crypt(NEW.passpass, gen_salt('bf', 8));
		RETURN NEW;
	END
	$$ LANGUAGE plpgsql;

	CREATE TRIGGER tr_user_hash_password BEFORE INSERT OR UPDATE ON users
	FOR EACH ROW
	EXECUTE PROCEDURE user_hash_password();

COMMIT;
