-- Update FlashCard
WITH flashcard_updated AS (
  UPDATE
    flashcard
  SET
      recto = CAST($3 AS TEXT)
    , tags = CAST($4 AS TEXT[])
    , verso = CAST($5 AS TEXT)
  WHERE
        id = CAST($2 AS BIGINT)
    AND userid = CAST($1 AS BIGINT)
  RETURNING
    *
)
SELECT
  count(*)
FROM
  flashcard_updated
;
