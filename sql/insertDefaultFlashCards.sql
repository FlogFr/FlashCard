-- Insert 10 Default FlashCards
WITH flashcard_inserted AS (
  INSERT INTO
    flashcard
    (recto, tags, verso, userid)
  VALUES
    ('Gravity Apple', CAST('{general culture}' AS TEXT[]), 'Object inspired Isaac Newton s theory', CAST($1 AS BIGINT)),
    ('NYC Yellow', CAST('{general culture}' AS TEXT[]), 'Color of NYC Taxi', CAST($1 AS BIGINT)),
    ('J. K. Rowling', CAST('{general culture}' AS TEXT[]), 'Author of Harry Potter', CAST($1 AS BIGINT)),
    ('Percy Spencer', CAST('{general culture}' AS TEXT[]), 'Inventor of the microwave', CAST($1 AS BIGINT)),
    ('Congress 100', CAST('{general culture}' AS TEXT[]), 'Number of seats in the United States Congress', CAST($1 AS BIGINT)),
    ('28 countries', CAST('{general culture}' AS TEXT[]), 'Number of Union European countries', CAST($1 AS BIGINT)),
    ('geography 7', CAST('{general culture}' AS TEXT[]), 'Number of continents', CAST($1 AS BIGINT))
  RETURNING
    *
)
SELECT
  COUNT(*)
FROM
  flashcard_inserted
;
