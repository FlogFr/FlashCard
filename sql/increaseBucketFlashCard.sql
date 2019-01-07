-- Increase bucket flashcard .
-- Not more than 5
WITH flashcard_updated AS (
  UPDATE
    flashcard
  SET
      side = CASE WHEN side = 'recto' THEN 'verso'
                  ELSE 'recto' END
    , bucket = CASE WHEN bucket = 0 THEN 1
                    WHEN bucket = 1 THEN 2
                    WHEN bucket = 2 THEN 3
                    WHEN bucket = 3 THEN 4
                    WHEN bucket = 4 THEN 5
                    ELSE 6 END
  WHERE
        userid = CAST($1 AS BIGINT)
    AND id = CAST($2 AS BIGINT)
  RETURNING
    *
)
SELECT
  COUNT(*)
FROM
  flashcard_updated
;
