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
ORDER BY
  inserted_at DESC
LIMIT 50
;
