{-# LANGUAGE QuasiQuotes, DataKinds, DeriveGeneric, DeriveDataTypeable, FlexibleInstances, TypeOperators, TemplateHaskell, MultiParamTypeClasses, NoImplicitPrelude #-}

module StringArray
  where


import Database.HDBC
import Data.ByteString.UTF8 as BUTF8 (toString, fromString)
import Data.ByteString
import Data.Convertible.Base
import Data.Char
import Data.String
import Data.List
import Data.Function
import Data.Either
import Data.Eq
import Data.Aeson
import Data.ByteString
import GHC.Generics
import Prelude (Integer, Bool)

type StringArray = [String]

-- Convert From SQL / To SQL
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
