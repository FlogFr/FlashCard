-- Deploy users:0002-users to pg

BEGIN;

  -- Create Schema Users
  CREATE SEQUENCE users_id_seq;
  
  CREATE TABLE IF NOT EXISTS users (
           "id" BIGINT NOT NULL PRIMARY KEY DEFAULT nextval('users_id_seq'),
     "username" TEXT NOT NULL,
     "password" TEXT NOT NULL
  );
  
  ALTER SEQUENCE users_id_seq OWNED BY users.id;

  ALTER TABLE words ADD COLUMN userid BIGINT NOT NULL;

  ALTER TABLE words ADD CONSTRAINT userid_fk FOREIGN KEY (userid) REFERENCES users ON DELETE CASCADE;

COMMIT;
