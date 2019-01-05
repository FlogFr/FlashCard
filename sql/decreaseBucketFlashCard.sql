-- Decrease bucket flashcard .
-- Not less than 0
WITH flashcard_updated AS (
  UPDATE
    flashcard
  SET
      side = CASE WHEN side = 'recto' THEN 'verso'
                  ELSE 'recto' END
    , bucket = CASE WHEN bucket = 6 THEN 5
                    WHEN bucket = 5 THEN 4
                    WHEN bucket = 4 THEN 3
                    WHEN bucket = 3 THEN 2
                    WHEN bucket = 2 THEN 1
                    ELSE 0 END
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
