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
-- name:verifyJWT :: (Int, String)
-- :jwt :: String
WITH user_id AS (
  SELECT auth_jwt_decode(:jwt) AS user_id
)
SELECT 
    id
  , username
FROM
  users
  JOIN user_id
  ON users.id = user_id.user_id
;;;
-- name:insertUser :: (String, String)
-- :user :: NewUser
INSERT INTO
  users
  (username, passpass, email)
VALUES
  (:user.newUsername, :user.newPassword, :user.newEmail)
RETURNING
    id
  , username
;;;
-- name:updateUser :: (Int, String)
-- :user :: User
-- :password :: String
UPDATE
  users
  (password)
VALUES
  (:password)
WHERE
  users.id = :user.userid
RETURNING
    id
  , username
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
-- name:getAllWords :: [(Int, String, String, String, StringArray, MaybeInt)]
-- :user :: User
SELECT
  id, COALESCE(language, 'EN'), word, COALESCE(definition, 'def'), keywords, difficulty
FROM
  words
WHERE
  userid = :user.userid
;;;
-- name:getLastWords :: [(Int, String, String, String, StringArray, MaybeInt)]
-- :user :: User
SELECT
  id, COALESCE(language, 'EN'), word, COALESCE(definition, 'def'), keywords, difficulty
FROM
  words
WHERE
  userid = :user.userid
ORDER BY
  inserted_at DESC
LIMIT 20
;;;
-- name:getWordsByKeyword :: [(Int, String, String, String, StringArray, MaybeInt)]
-- :user :: User
-- :keyword :: String
SELECT
  id, COALESCE(language, 'EN'), word, COALESCE(definition, 'def'), keywords, difficulty
FROM
  words
WHERE
  userid = :user.userid AND
  :keyword = ANY ( keywords )
LIMIT 20
;;;
-- name:getAllKeywords :: [(String)]
-- :user :: User
SELECT
  DISTINCT ( UNNEST ( keywords ) )
FROM
  words
WHERE
  userid = :user.userid
;;;
-- name:getSearchWords :: [(Int, String, String, String, StringArray, MaybeInt)]
-- :user :: User
-- :searchWord :: String
SELECT
  id, COALESCE(language, 'EN'), word, COALESCE(definition, 'def'), keywords, difficulty
FROM
  words
WHERE
  userid = :user.userid AND
  word LIKE '%' || :searchWord || '%'
LIMIT
  20
;;;
-- name:getWordById :: [(Int, String, String, String, StringArray, MaybeInt)]
-- :user :: User
-- :wordId :: WordId
SELECT
  id, COALESCE(language, 'EN'), word, COALESCE(definition, 'def'), keywords, difficulty
FROM
  words
WHERE
          id = :wordId
  AND userid = :user.userid
;;;
-- name:updateWordById :: (Integer)
-- :user :: User
-- :wordId :: WordId
-- :word :: Word
UPDATE
  words
SET
      language    = :word.wordLanguage
    , word        = :word.wordWord
    , keywords    = :word.wordKeywords
    , definition  = :word.wordDefinition
    , difficulty  = :word.wordDifficulty
WHERE
          id = :wordId
  AND userid = :user.userid
;;;
-- name:insertWord :: (Integer)
-- :user :: User
-- :wordLanguage :: String
-- :wordWord :: String
-- :wordDefinition :: String
INSERT INTO
  words
  (userid, language, word, definition)
VALUES
  (:user.userid, :wordLanguage, :wordWord, :wordDefinition)
;;;
-- name:deleteWordById :: (Integer)
-- :user :: User
-- :wordId :: Int
DELETE
FROM
  words
WHERE
          id = :wordId
  AND userid = :user.userid
