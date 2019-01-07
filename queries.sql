-- name: get-random-word
-- Get random word from table
WITH params AS (
  SELECT count(*) AS nb_rows
    FROM words
)
 SELECT language, word, definition
   FROM words, params
 OFFSET floor(random() * (SELECT nb_rows FROM params))
  LIMIT 1;

-- name: get-n-random-words
-- Get N random word from table
  SELECT language, word, definition
    FROM words
ORDER BY random()
   LIMIT %(n)s;

-- name: get-similarity-word
-- Check similarity word
  SELECT similarity(%(word_try)s, %(word)s);

-- name: get-similarity-definition
-- Check similarity word
  SELECT similarity(%(word_try)s, definition)
    FROM words
   WHERE word = %(word)s;
