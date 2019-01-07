module Data.Message where

import Protolude

data Message = Message {
    description :: Text
  } deriving (Eq, Show)
