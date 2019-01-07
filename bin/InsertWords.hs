{-# LANGUAGE QuasiQuotes #-}

import System.IO
import Database.HDBC.PostgreSQL (withPostgreSQL)
import Database.HDBC
import Database.YeshQL
import Options.Applicative
import Data.Semigroup ((<>))

data WordAdded = WordAdded
    { language :: String
    , word :: String
    , definition :: String }

wordAdded :: Parser WordAdded
wordAdded = WordAdded
    <$> strOption
        ( long "language"
       <> short 'l'
       <> help "Language of this word" )
    <*> strOption
        ( long "word"
       <> short 'w'
       <> help "Word to be added" )
    <*> strOption
        ( long "definition"
       <> short 'd'
       <> help "Definition of the word" )

[yesh|
    -- name:insertWord
    -- :wordLanguage :: String
    -- :wordWord :: String
    -- :wordDefinition :: String
    INSERT INTO
      words (language, word, definition)
    VALUES
      (:wordLanguage, :wordWord, :wordDefinition)
|]

addWord :: WordAdded -> IO ()
addWord (WordAdded language word definition) = withPostgreSQL "service = words" $ \conn -> do
    putStrLn "It works! I have a connection add a word"
    wordId <- insertWord language word definition conn
    commit conn
    disconnect conn
    putStrLn "and we're good!"
    return ()
addWord _ = return ()

main :: IO ()
main = addWord =<< execParser opts
    where
        opts = info (wordAdded <**> helper)
          ( fullDesc
         <> progDesc "Add a new word into the database"
         <> header "insert-words - add a new word into your custom database" )
