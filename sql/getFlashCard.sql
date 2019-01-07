-- Get my FlashCards
SELECT
  id,
  recto,
  tags,
  verso,
  bucket,
  side
FROM
  flashcard
WHERE
      userid = CAST($1 AS BIGINT)
  AND id = CAST($2 AS BIGINT)
;
