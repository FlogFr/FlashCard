WITH user_inserted AS (
  INSERT INTO
    user_account
    (username, email, passpass)
  SELECT
    CAST($1 AS TEXT) || CAST($2 AS TEXT), CAST($3 AS TEXT), CAST($4 AS TEXT)
  RETURNING
    *
)
SELECT
  count(*)
FROM
  user_inserted
;
