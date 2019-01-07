-- Delete FlashCard
WITH flashcard_deleted AS (
  DELETE
  FROM
    flashcard
  WHERE
        userid = CAST($1 AS BIGINT)
    AND id = CAST($2 AS BIGINT)
  RETURNING
    *
)
SELECT
  COUNT(*)
FROM
  flashcard_deleted
;
