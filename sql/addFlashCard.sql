-- Add FlashCard
WITH flashcard_inserted AS (
  INSERT INTO
    flashcard
    (userid, recto, tags, verso)
  VALUES
    (CAST($1 AS BIGINT), CAST($2 AS TEXT), CAST($3 AS TEXT[]), CAST($4 AS TEXT))
  RETURNING
    *
)
SELECT
  COUNT(*)
FROM
  flashcard_inserted
;
