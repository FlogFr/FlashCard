-- name:insertUser :: (String, String)
-- :user :: NewUser
INSERT INTO
  users
  (username, passpass, email)
VALUES
  (:user.username, :user.password, :user.email)
RETURNING
    id
  , username
;;;
