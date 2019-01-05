-- Search my FlashCards
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
  AND to_tsvector('english', COALESCE(recto, '') || ' ' || COALESCE(verso, '')) @@ plainto_tsquery('english', CAST($2 AS TEXT))
ORDER BY
  inserted_at DESC
LIMIT 50
;
