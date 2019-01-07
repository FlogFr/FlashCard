module Data.GrantUser where

import Protolude

import Data.Aeson

data GrantUser = GrantUser
  { grantUsername :: Text
  , grantPassword :: Text
  } deriving (Eq, Generic, Show)

instance ToJSON GrantUser
instance FromJSON GrantUser
