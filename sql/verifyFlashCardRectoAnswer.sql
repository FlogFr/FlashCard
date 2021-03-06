-- Verify Recto FlashCard answer
SELECT
  to_tsvector('english', recto) @@ plainto_tsquery('english', CAST($3 AS TEXT)) AS verified
FROM
  flashcard
WHERE
      userid = CAST($1 AS BIGINT)
  AND id = CAST($2 AS BIGINT)
;
