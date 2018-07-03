{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}

module Queries 
     ( getWords
     , insertWord
     ) where


import Database.YeshQL


[yesh|
  -- name:getWords :: [(Int, String, String, String, Int)]
  SELECT
    id, COALESCE(language, 'EN'), word, COALESCE(definition, 'def'), COALESCE(difficulty, 0)
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
|] 

