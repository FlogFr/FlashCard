module Data.FlashCard where

import Protolude

import Data.Aeson


data FlashCard = FlashCard
  { flashCardId          :: Integer
  , flashCardRecto       :: Text
  , flashCardTags        :: [Text]
  , flashCardVerso       :: Text
  , flashCardBucket      :: Int
  , flashCardSide        :: Text
  } deriving (Eq, Generic, Show)


instance ToJSON FlashCard
instance FromJSON FlashCard
