-- Get a FlashCard for the quizz
-- The rule to get a FlashCard is this one:
-- - Bucket 0: Pick the flash card every day
-- - Bucket 1: Pick the flash card every 2 days
-- - Bucket 2: Pick the flash card every week
-- - Bucket 3: Pick the flash card every month
-- - Bucket 4: Pick the flash card every 3 months
-- - Bucket 5: Pick the flash card every 6 months
-- - Bucket 6: Pick the flash card every year
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
  AND date_part('day', updated_at) != date_part('day', now()) -- we remove all the cards already asked today
  AND (    bucket = 0
        OR bucket = 1 AND EXTRACT(DAY FROM (now() - updated_at)) > 2
        OR bucket = 2 AND EXTRACT(DAY FROM (now() - updated_at)) > 7
        OR bucket = 3 AND EXTRACT(DAY FROM (now() - updated_at)) > 30
        OR bucket = 4 AND EXTRACT(DAY FROM (now() - updated_at)) > 90
        OR bucket = 5 AND EXTRACT(DAY FROM (now() - updated_at)) > 180
        OR bucket = 6 AND EXTRACT(DAY FROM (now() - updated_at)) > 365
      )
ORDER BY
  bucket DESC
LIMIT
  1
;
