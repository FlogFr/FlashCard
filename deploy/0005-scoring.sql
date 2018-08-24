-- Deploy words:0005-scoring to pg

BEGIN;

  -- Create the word scoring system
  CREATE OR REPLACE FUNCTION get_score_word (last_query_at TIMESTAMPTZ, difficulty INT)
  RETURNS INT
  AS $$
  BEGIN
    RETURN (difficulty * 100) + date_part('day', (now() - last_query_at));
  END
  $$ LANGUAGE plpgsql;

  CREATE OR REPLACE FUNCTION verify_word(wordId INT, testDefinition TEXT)
  RETURNS BOOL
  AS $$
  DECLARE
    definition TEXT;
    simi REAL;
  BEGIN
    SELECT w.definition INTO definition FROM words w WHERE id = wordId;
    RAISE NOTICE 'Definition to verify: %', testDefinition;
    RAISE NOTICE 'Against: %', definition;
    SELECT similarity(definition, testDefinition) INTO simi;
    return 't';
  END
  $$ LANGUAGE plpgsql;


COMMIT;
