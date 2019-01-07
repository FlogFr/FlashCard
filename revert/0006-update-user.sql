-- Revert words:0006-update-user from pg

BEGIN;

  -- Session
  -- Remove the unique constraint on the userid
  ALTER TABLE session ADD CONSTRAINT sessions_userid_key UNIQUE (userid);
  -- 
  ALTER TABLE session DROP COLUMN created_at;
  ALTER TABLE session RENAME TO sessions;

  -- Change the field email type back to text
  ALTER TABLE user_account ALTER COLUMN email TYPE TEXT ;

  -- Move the table back
  ALTER TABLE user_account RENAME TO users;

  -- Drop Domain
  DROP DOMAIN IF EXISTS email_d;

  -- Drop extension
  DROP EXTENSION IF EXISTS CITEXT;

COMMIT;
