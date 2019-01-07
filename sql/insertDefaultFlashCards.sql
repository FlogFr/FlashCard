-- Insert 10 Default FlashCards
WITH flashcard_inserted AS (
  INSERT INTO
    flashcard
    (recto, tags, verso, userid, updated_at)
  VALUES
    ('Gravity Apple', CAST('{general culture}' AS TEXT[]), 'Object inspired Isaac Newton s theory', CAST($1 AS BIGINT), now() - INTERVAL '1 day'),
    ('NYC Yellow', CAST('{general culture}' AS TEXT[]), 'Color of NYC Taxi', CAST($1 AS BIGINT), now() - INTERVAL '1 day'),
    ('J. K. Rowling', CAST('{general culture}' AS TEXT[]), 'Author of Harry Potter', CAST($1 AS BIGINT), now() - INTERVAL '1 day'),
    ('Percy Spencer', CAST('{general culture}' AS TEXT[]), 'Inventor of the microwave', CAST($1 AS BIGINT), now() - INTERVAL '1 day'),
    ('Congress 100', CAST('{general culture}' AS TEXT[]), 'Number of seats in the United States Congress', CAST($1 AS BIGINT), now() - INTERVAL '1 day'),
    ('28 countries', CAST('{general culture}' AS TEXT[]), 'Number of Union European countries', CAST($1 AS BIGINT), now() - INTERVAL '1 day'),
    ('geography 7', CAST('{general culture}' AS TEXT[]), 'Number of continents', CAST($1 AS BIGINT), now() - INTERVAL '1 day')
  RETURNING
    *
)
SELECT
  COUNT(*)
FROM
  flashcard_inserted
;
