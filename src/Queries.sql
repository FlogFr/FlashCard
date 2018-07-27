-- name:getUser :: (Int, String, String)
-- :userName :: String
-- :userPassword :: String
SELECT
  id, username, password
FROM
  users
WHERE
      username = :userName
  AND password = :userPassword
;;;
-- name:getAllWords :: [(Int, String, String, String, MaybeInt)]
-- :user :: User
SELECT
  id, COALESCE(language, 'EN'), word, COALESCE(definition, 'def'), difficulty
FROM
  words
WHERE
  userid = :user.userid
;;;
-- name:getLastWords :: [(Int, String, String, String, MaybeInt)]
-- :user :: User
SELECT
  id, COALESCE(language, 'EN'), word, COALESCE(definition, 'def'), difficulty
FROM
  words
WHERE
  userid = :user.userid
ORDER BY
  id DESC
LIMIT
  5
;;;
-- name:insertWord :: (Integer)
-- :wordLanguage :: String
-- :wordWord :: String
-- :wordDefinition :: String
INSERT INTO
  words
  (language, word, definition)
VALUES
  (:wordLanguage, :wordWord, :wordDefinition)
