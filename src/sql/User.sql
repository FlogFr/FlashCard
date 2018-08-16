-- name:getNewToken :: (String)
INSERT INTO
  token
  (token)
VALUES
  (uuid_generate_v4())
RETURNING
  token
;;;
-- name:verifyToken :: (Bool)
-- :uuid :: String
SELECT
  created_at > (now() - INTERVAL '5 minutes')
FROM
  token
WHERE
  token = :uuid
;;;
-- name:getSessionJWT :: (String)
-- :username :: String
-- :pass :: String
SELECT auth_login(:username, :pass)
;;;
-- name:verifyJWT :: User
-- :jwt :: String
WITH user_id AS (
  SELECT auth_jwt_decode(:jwt) AS user_id
)
SELECT 
    id
  , username
  , email
  , lang
FROM
  users
  JOIN user_id
  ON users.id = user_id.user_id
;;;
-- name:updatePassword :: User
-- :user      :: User
-- :password  :: String
UPDATE
  users
SET
    passpass = :password
WHERE
    users.id = :user.userid
RETURNING
    id
  , username
  , email
  , lang
;;;
-- name:getUser :: (Int, String)
-- :userName :: String
-- :userPassword :: String
SELECT
  id, username
FROM
  users
WHERE
      username = :userName
  AND passpass = crypt(:userPassword, passpass)
;;;
-- name:getUserById :: (Int, String)
-- :userName :: String
SELECT
  id, username
FROM
  users
WHERE
  username = :userName
;;;
