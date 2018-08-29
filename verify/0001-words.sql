-- Verify words:0001-words on pg

BEGIN;

  SELECT "id", "language", "words", "keywords", "definition", "difficulty"
    FROM words
   WHERE false;

ROLLBACK;
