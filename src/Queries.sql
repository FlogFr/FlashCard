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
-- :user :: User
-- :wordLanguage :: String
-- :wordWord :: String
-- :wordDefinition :: String
INSERT INTO
  words
  (userid, language, word, definition)
VALUES
  (:user.userid, :wordLanguage, :wordWord, :wordDefinition)
