-- name:getAllWords :: [Word]
-- :user :: User
SELECT
  id, COALESCE(language, 'EN'), word, COALESCE(definition, 'def'), keywords, difficulty
FROM
  words
WHERE
  userid = :user.userid
;;;
-- name:getQuizzWordsKeyword :: [Word]
-- :user :: User
-- :keyword :: String
SELECT
  id, COALESCE(language, 'EN'), word, COALESCE(definition, 'def'), keywords, difficulty
FROM
  words
WHERE
  userid = :user.userid AND
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
  userid = :user.userid
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
-- name:getSearchWords :: [Word]
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
-- name:getSearchWordsUser :: [Word]
-- :user :: User
SELECT
  id, COALESCE(language, 'EN'), word, COALESCE(definition, 'def'), keywords, difficulty
FROM
  words
WHERE
  userid = :user.userid
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
  userid = :user.userid AND
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
  userid = :user.userid AND
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
  AND userid = :user.userid
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
  AND "userid" = :user.userid
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
  (:user.userid, :newWord.language, :newWord.word, :newWord.keywords, :newWord.definition)
;;;
-- name:deleteWordById :: (Integer)
-- :user :: User
-- :wordId :: Int
DELETE
FROM
  words
WHERE
          id = :wordId
  AND userid = :user.(Word.userid)
;;;;
