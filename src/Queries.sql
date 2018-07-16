-- name:getWords :: [(Int, String, String, String, MaybeInt)]
SELECT
  id, COALESCE(language, 'EN'), word, COALESCE(definition, 'def'), difficulty
FROM
  words
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
