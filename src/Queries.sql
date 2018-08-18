-- name:updateFullUser :: User
-- :user      :: User
-- :fullUser  :: FullUser
UPDATE
  users
SET
    email    = :fullUser.fullUserEmail
  , lang     = :fullUser.fullUserLang
WHERE
    users.id = :user.userId
RETURNING
    id
  , username
  , email
  , lang
;;;
-- name:insertUser :: (String, String)
-- :user :: NewUser
INSERT INTO
  users
  (username, passpass, email, lang)
VALUES
  (:user.newuserUsername, :user.newuserPassword, :user.newuserEmail, :user.newuserLang)
RETURNING
    id
  , username
;;;
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
    users.id = :user.userId
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
-- name:getAllWords :: [Word]
-- :user :: User
SELECT
  id, COALESCE(language, 'EN'), word, COALESCE(definition, 'def'), keywords, difficulty
FROM
  words
WHERE
  userid = :user.userId
;;;
-- name:getQuizzWordsKeyword :: [Word]
-- :user :: User
-- :keyword :: String
SELECT
  id, COALESCE(language, 'EN'), word, COALESCE(definition, 'def'), keywords, difficulty
FROM
  words
WHERE
  userid = :user.userId AND
  :keyword = ANY (keywords)
ORDER BY
  RANDOM ()
LIMIT
  5
;;;
-- name:getLastWords :: [Word]
-- :user :: User
SELECT
  id, COALESCE(language, 'EN'), word, COALESCE(definition, 'def'), keywords, difficulty
FROM
  words
WHERE
  userid = :user.userId
ORDER BY
  inserted_at DESC
LIMIT 20
;;;
-- name:getWordsByKeyword :: [Word]
-- :user :: User
-- :keyword :: String
SELECT
  id, COALESCE(language, 'EN'), word, COALESCE(definition, 'def'), keywords, difficulty
FROM
  words
WHERE
  userid = :user.userId AND
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
  userid = :user.userId
;;;
-- name:getSearchWords :: [Word]
-- :user :: User
-- :searchWord :: String
SELECT
  id, COALESCE(language, 'EN'), word, COALESCE(definition, 'def'), keywords, difficulty
FROM
  words
WHERE
  userid = :user.userId AND
  word LIKE '%' || :searchWord || '%'
LIMIT
  20
;;;
-- name:getSearchWordsUser :: [Word]
-- :user :: User
SELECT
  id, COALESCE(language, 'EN'), word, COALESCE(definition, 'def'), keywords, difficulty
FROM
  words
WHERE
  userid = :user.userId
ORDER BY
  id DESC
LIMIT
  20
;;;
-- name:getSearchKeyword :: [Word]
-- :user :: User
-- :keyword :: String
SELECT
  id, COALESCE(language, 'EN'), word, COALESCE(definition, 'def'), keywords, difficulty
FROM
  words
WHERE
  userid = :user.userId AND
  :keyword = ANY (keywords)
LIMIT
  20
;;;
-- name:getSearchWordsKeyword :: [Word]
-- :user :: User
-- :searchWord :: String
-- :keyword :: String
SELECT
  id, COALESCE(language, 'EN'), word, COALESCE(definition, 'def'), keywords, difficulty
FROM
  words
WHERE
  userid = :user.userId AND
  word LIKE '%' || :searchWord || '%' AND
  :keyword = ANY (keywords)
LIMIT
  20
;;;
-- name:getWordById :: Word
-- :user :: User
-- :wordId :: WordId
SELECT
  id, COALESCE(language, 'EN'), word, COALESCE(definition, 'def'), keywords, difficulty
FROM
  words
WHERE
          id = :wordId
  AND userid = :user.userId
;;;
-- name:updateWordById :: Word
-- :user :: User
-- :wordId :: WordId
-- :newWord :: Word
UPDATE
  words
SET
    "language"   = :newWord.language
  , "word"       = :newWord.word
  , "definition" = :newWord.definition
  , "keywords"   = :newWord.keywords
  , "difficulty" = :newWord.difficulty
WHERE
      "id"     = :wordId
  AND "userid" = :user.userId
RETURNING
    "id"
  , "language"
  , "word"
  , "definition"
  , "keywords"
  , "difficulty"
;;;
-- name:insertWord :: (Integer)
-- :user :: User
-- :newWord :: Word
INSERT INTO
  words
  (userid, language, word, keywords, definition)
VALUES
  (:user.userId, :newWord.language, :newWord.word, :newWord.keywords, :newWord.definition)
;;;
-- name:deleteWordById :: (Integer)
-- :user :: User
-- :wordId :: Int
DELETE
FROM
  words
WHERE
          id = :wordId
  AND userid = :user.userId
;;;;
