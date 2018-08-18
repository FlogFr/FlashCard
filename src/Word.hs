{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE TypeOperators              #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE TypeSynonymInstances       #-}

module Word
  ( Word(..)
  , WordId
  )
  where

import Prelude hiding (Word, id)
import Database.HDBC
import Database.YeshQL.HDBC.SqlRow.TH
import Data.ByteString.UTF8 as BUTF8 (toString, fromString)
import Data.ByteString
import Data.Convertible.Base
import Data.Aeson
import Data.Swagger
import Data.List
import User (User(..))
import GHC.Generics
import Prelude (Integer, Bool)
import Servant.Elm (ElmType)


type WordId = Int
type MaybeInt = Maybe Int
type StringArray = [String]

data Word = Word
  { id          :: WordId
  , language    :: String
  , word        :: String
  , definition  :: String
  , keywords    :: StringArray
  , difficulty  :: MaybeInt
  } deriving (Eq, Generic, Show)
makeSqlRow ''Word


instance ToSchema Word
instance ToJSON Word
instance FromJSON Word
instance ElmType Word

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
