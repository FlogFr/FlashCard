-- Register new user
WITH user_inserted AS (
  INSERT INTO
    user_account
    (email, passpass)
  SELECT
    CAST($1 AS email_d), CAST($2 AS TEXT)
  RETURNING
    *
)
SELECT
  id, username, email, languages
FROM
  user_inserted
;
