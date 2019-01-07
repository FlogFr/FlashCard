-- Password checked
WITH user_checked AS (
  SELECT 
    id
  FROM
    user_account
  WHERE
        email = CAST($1 AS CITEXT)
    AND CRYPT($2, passpass) = passpass
)
SELECT 
  count(*)
FROM
  user_checked
;
