-- Deploy words:0005-scoring to pg

BEGIN;

  -- Create the word scoring system
  CREATE OR REPLACE FUNCTION get_word_score (last_query_at TIMESTAMPTZ, difficulty INT)
  RETURNS INT
  AS $$
  BEGIN
    RETURN difficulty;
  END
  $$ LANGUAGE plpgsql;


  CREATE OR REPLACE FUNCTION verify_word_full(wordId INT, testDefinition TEXT)
  RETURNS BOOL
  AS $$
  DECLARE
    verified BOOL;
    diff INT;
  BEGIN
    -- arbitrary 0.4 found by example
    SELECT verify_word(wordId, testDefinition, 0.4) INTO verified;
    SELECT difficulty INTO diff FROM words WHERE id = wordId;
    IF verified = 't' AND diff > 0 THEN
      diff := diff - 1;
    ELSE
      IF verified = 'f' THEN
        diff := diff + 1;
      END IF;
    END IF;
    UPDATE words SET last_query_at = now(), difficulty = diff WHERE id = wordId;
    return verified;
  END
  $$ LANGUAGE plpgsql;

  CREATE OR REPLACE FUNCTION verify_word(wordId INT, testDefinition TEXT, threshold REAL)
  RETURNS BOOL
  AS $$
  DECLARE
    definition TEXT;
    def_curr TEXT;
    simi REAL;
    simi_max REAL;
    ind INT;
    nb_def INT;
  BEGIN
    SELECT w.definition INTO definition FROM words w WHERE id = wordId;
    RAISE NOTICE 'Definition to verify: %', testDefinition;
    RAISE NOTICE 'Against: %', definition;

    SELECT array_length(regexp_split_to_array(definition, ','), 1) INTO nb_def;
  
    ind := 1;
    simi_max := 0;
    LOOP
      SELECT split_part(definition, ',', ind) INTO def_curr;
      ind := ind + 1;
  
      SELECT similarity(unaccent(def_curr), unaccent(testDefinition)) INTO simi;
      IF simi > simi_max THEN
        simi_max := simi;
      END IF;
      EXIT WHEN ind > nb_def;
    END LOOP;
  
    RAISE NOTICE 'max similarity found to: %', simi_max;
    IF simi_max > threshold THEN
      return 't';
    ELSE
      return 'f';
    END IF;
  END
  $$ LANGUAGE plpgsql;


COMMIT;
