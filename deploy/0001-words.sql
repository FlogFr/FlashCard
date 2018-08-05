-- Deploy words:0001-words to pg
BEGIN;

  -- Create Schema Words
  CREATE SEQUENCE words_id_seq;
  
  CREATE TABLE IF NOT EXISTS words (
            id BIGINT NOT NULL PRIMARY KEY DEFAULT nextval('words_id_seq'),
   inserted_at TIMESTAMPTZ NOT NULL default(now()),
      language CHARACTER(2) NOT NULL,
          word VARCHAR(128) NOT NULL,
      keywords TEXT[] NOT NULL DEFAULT '{}',
    definition TEXT NOT NULL,
    difficulty INTEGER
  );
  
  ALTER SEQUENCE words_id_seq OWNED BY words.id;

  CREATE INDEX words_trgm ON words USING GIN(word gin_trgm_ops);

COMMIT;
