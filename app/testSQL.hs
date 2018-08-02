{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE TypeSynonymInstances       #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE MultiParamTypeClasses      #-}

module Main (main) where

import Database.HDBC
import Database.HDBC.PostgreSQL
import Data.Convertible.Base
import Data.ByteString.UTF8 as BUTF8 (toString, fromString)
import Data.ByteString
import Data.List

type StringArray = [String]

wordsWhen     :: (Char -> Bool) -> String -> [String]
wordsWhen p s =  case Data.List.dropWhile p s of
                      "" -> []
                      s' -> w : wordsWhen p s''
                            where (w, s'') = Data.List.break p s'

myUnwords                 :: [String] -> String
myUnwords []              =  ""
myUnwords (w:ws)          = w ++ go ws
  where
    go []     = ""
    go (v:vs) = ',' : (v ++ go vs)

innerArrayString :: String -> String
innerArrayString fullArrayString =
  Data.List.takeWhile (\x -> x /= '}' ) $ Data.List.drop 1 fullArrayString

byteStringToStringArray :: ByteString -> StringArray
byteStringToStringArray byteString =
  wordsWhen (==',') $ innerArrayString $ BUTF8.toString byteString

stringArrayToByteString :: StringArray -> ByteString
stringArrayToByteString stringArray =
  BUTF8.fromString $ "{" ++ myUnwords stringArray ++ "}"

instance Convertible SqlValue StringArray where
  safeConvert = Right . byteStringToStringArray . fromSql 
instance Convertible StringArray SqlValue where
  safeConvert = Right . toSql . stringArrayToByteString

main :: IO ()
main =
  do
    let connStr = "service=words"
    conn <- connectPostgreSQL connStr
    begin conn
    select <- prepare conn "SELECT id, word, keywords FROM words WHERE id = 400;"
    _ <- execute select []
    rows <- fetchAllRows select
    Prelude.putStrLn (show rows)
    let stringRows = Data.List.map convRow rows
    mapM_ Prelude.putStrLn stringRows
    update <- prepare conn "UPDATE words SET keywords = ? WHERE id = 400;"
    _ <- execute update [(toSql (["cuisine", "label"]::StringArray))]
    _ <- commit conn
    disconnect conn

  where
    convRow :: [SqlValue] -> String
    convRow [wordId, wordWord, wordKeywords] = 
        show wordIdInt ++ ": " ++ wordWordString ++ ", keywords: " ++ (Data.List.intercalate " " wordKeywordsArrayString)
        where wordIdInt = (fromSql wordId)::Integer
              wordWordString = (fromSql wordWord)::String
              wordKeywordsArrayString = (fromSql wordKeywords)::StringArray
    convRow x = fail $ "Unexpected result: " ++ show x
