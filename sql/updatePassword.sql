-- Update User Password
WITH password_updated AS (
  UPDATE 
    user_account
  SET
    passpass = CAST($2 AS TEXT)
  WHERE
    email = CAST($1 AS email_d)
  RETURNING
    *
)
SELECT 
  count(*)
FROM
  password_updated
;
