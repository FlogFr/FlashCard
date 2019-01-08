-- Insert 10 Default FlashCards
WITH flashcard_inserted AS (
  INSERT INTO
    flashcard
    (recto, tags, verso, userid, updated_at)
  VALUES
    ('Gravity Apple', CAST('{general knowledge}' AS TEXT[]), 'Object inspired Isaac Newton s theory', CAST($1 AS BIGINT), now() - INTERVAL '1 day'),
    ('NYC Yellow', CAST('{general knowledge}' AS TEXT[]), 'Color of NYC Taxi', CAST($1 AS BIGINT), now() - INTERVAL '1 day'),
    ('J. K. Rowling', CAST('{general knowledge}' AS TEXT[]), 'Author of the books Harry Potter', CAST($1 AS BIGINT), now() - INTERVAL '1 day'),
    ('Percy Spencer', CAST('{general knowledge}' AS TEXT[]), 'Inventor of the microwave', CAST($1 AS BIGINT), now() - INTERVAL '1 day'),
    ('Merci', CAST('{general knowledge}' AS TEXT[]), 'Thank you', CAST($1 AS BIGINT), now() - INTERVAL '1 day'),
    ('Yawn and stretch at the same time', CAST('{general knowledge}' AS TEXT[]), 'Pandiculating', CAST($1 AS BIGINT), now() - INTERVAL '1 day'),
    ('Pteronophobia', CAST('{general knowledge}' AS TEXT[]), 'Fear of being tickled by a feather', CAST($1 AS BIGINT), now() - INTERVAL '1 day'),
    ('Country with 50 percent of the total round about in the world', CAST('{general knowledge}' AS TEXT[]), 'France has 50 percent of the total number of…', CAST($1 AS BIGINT), now() - INTERVAL '1 day'),
    ('Pluto is smaller than which country?', CAST('{general knowledge}' AS TEXT[]), 'Russia is bigger than which planet', CAST($1 AS BIGINT), now() - INTERVAL '1 day'),
    ('Animal sleeping up to three years', CAST('{general knowledge}' AS TEXT[]), 'Action a snail can do during three years', CAST($1 AS BIGINT), now() - INTERVAL '1 day'),
    ('Animal without a brain', CAST('{general knowledge}' AS TEXT[]), 'Body part missing for starfish', CAST($1 AS BIGINT), now() - INTERVAL '1 day'),
    ('Year of creation of the video game character Mario', CAST('{general knowledge}' AS TEXT[]), '1981 Video Game', CAST($1 AS BIGINT), now() - INTERVAL '1 day')
  RETURNING
    *
)
SELECT
  COUNT(*)
FROM
  flashcard_inserted
;
