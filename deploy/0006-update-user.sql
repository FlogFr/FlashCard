-- Deploy words:0006-update-user to pg

BEGIN;

  -- Create extensions
  CREATE EXTENSION IF NOT EXISTS CITEXT;

  -- Create 
  ALTER TABLE users RENAME TO user_account;

  -- Create Domain
  CREATE DOMAIN email_d AS CITEXT
  CHECK(
      value ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$'
  );

  DELETE FROM
    user_account
  WHERE
    email !~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$';
  ALTER TABLE user_account ALTER COLUMN email TYPE email_d ;
  DELETE FROM
    user_account
  WHERE
    email is NULL;

  ALTER TABLE user_account ALTER COLUMN email SET NOT NULL;
  ALTER TABLE user_account DROP CONSTRAINT users_username_check;
  ALTER TABLE user_account ALTER COLUMN username DROP NOT NULL;
  ALTER TABLE user_account ADD COLUMN first_name TEXT NULL;
  ALTER TABLE user_account ADD COLUMN last_name TEXT NULL;
  ALTER TABLE user_account ADD COLUMN email_verified BOOL DEFAULT 'f' NOT NULL;
  ALTER TABLE user_account ADD CONSTRAINT unique_user_account_email UNIQUE (email);

  -- Now for the session
  ALTER TABLE sessions RENAME TO session;

  ALTER TABLE session ADD COLUMN created_at TIMESTAMPTZ NOT NULL default now();

  -- Remove the unique constraint on the userid
  ALTER TABLE session DROP CONSTRAINT sessions_userid_key;

  -- Alter table words now
  DROP VIEW words_score;

  -- Alter table words to flashcard
  ALTER TABLE words RENAME TO flashcard;

  ALTER TABLE flashcard ALTER COLUMN word TYPE TEXT;
  ALTER TABLE flashcard RENAME word TO recto;
  ALTER TABLE flashcard RENAME definition TO verso;
  ALTER TABLE flashcard RENAME keywords TO tags;
  ALTER TABLE flashcard RENAME difficulty TO bucket;
  ALTER TABLE flashcard ALTER COLUMN bucket SET DEFAULT 0;
  ALTER TABLE flashcard DROP COLUMN language;
  ALTER TABLE flashcard ADD COLUMN side TEXT DEFAULT 'recto';
  ALTER TABLE flashcard ADD COLUMN updated_at TIMESTAMPTZ NOT NULL DEFAULT now();

  CREATE OR REPLACE FUNCTION update_flashcard_updated_at()
  RETURNS TRIGGER AS $$
  BEGIN
    NEW.updated_at = now();
    RETURN NEW;
  END;
  $$ language 'plpgsql';

  CREATE TRIGGER flashcard_updated_at
    BEFORE UPDATE ON flashcard
    FOR EACH ROW
    EXECUTE PROCEDURE update_flashcard_updated_at();

COMMIT;
