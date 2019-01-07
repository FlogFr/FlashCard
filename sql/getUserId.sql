SELECT
  id
FROM
  user_account
WHERE
  email = CAST($1 as email_d)
;
