{-# LANGUAGE QuasiQuotes #-}

import System.IO
import Database.HDBC.PostgreSQL (withPostgreSQL)
import Database.HDBC
import Database.YeshQL
import Options.Applicative
import Data.Semigroup ((<>))


[yesh|
    -- name:getWords :: (Int, String, String, String, String, Int)
    SELECT
      *
    FROM
      words
    ORDER BY
      random()
    LIMIT 5
|]

printWords :: IO ()
printWords = withPostgreSQL "service = words" $ \conn -> do
    putStrLn "It works! I have a connection to get the words"
    maybeWord <- getWords conn
    commit conn
    disconnect conn
    -- apply a the printStrLn to each row of maybeWord that are encapsulated into maybes
    putStrLn $ "these are my 5 words: " ++ show maybeWord
    return ()

main :: IO ()
main = printWords
