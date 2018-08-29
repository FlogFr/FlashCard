-- Deploy words:0003-tokens to pg

BEGIN;

  -- Create token table
  CREATE SEQUENCE IF NOT EXISTS token_id_seq;
  
  CREATE TABLE IF NOT EXISTS token (
           "id" BIGINT NOT NULL PRIMARY KEY DEFAULT nextval('users_id_seq'),
        "token" UUID NOT NULL,
   "created_at" TIMESTAMPTZ NOT NULL DEFAULT now()
  );
  
  ALTER SEQUENCE token_id_seq OWNED BY token.id;

COMMIT;
