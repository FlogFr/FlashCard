-- Get new random session for user email
WITH user_id AS (
  SELECT 
    id
  FROM
    user_account
  WHERE
        email = CAST($1 AS CITEXT)
    AND CRYPT($2, passpass) = passpass
)
INSERT INTO
  session
  (userid, secret)
SELECT
  uid.id, md5(random()::TEXT)
FROM
  user_id uid
RETURNING
  secret
;
