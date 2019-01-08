-- Facebook insert user
-- the email is verified.
WITH user_inserted AS (
  INSERT INTO
    user_account
    (username, email, passpass, email_verified)
  SELECT
    CAST($1 AS TEXT) || CAST($2 AS TEXT), CAST($3 AS TEXT), CAST($4 AS TEXT), 't'
  RETURNING
    *
)
SELECT
  id, username, email, languages
FROM
  user_inserted
;
