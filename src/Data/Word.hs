module Data.Word where

import Protolude hiding (Word)

import Data.Aeson


data Word = Word
  { wordId          :: Int
  , wordRecto       :: Text
  , wordTags        :: [Text]
  , wordVerso       :: Text
  , wordBucket      :: Integer
  } deriving (Eq, Generic, Show)

instance ToJSON Word
instance FromJSON Word
