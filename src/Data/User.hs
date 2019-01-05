module Data.User where

import Protolude
import           Data.Aeson


data User = User
  { userId        :: Integer
  , userUsername  :: Maybe Text
  , userEmail     :: Text
  } deriving (Eq, Generic, Show)


instance ToJSON User where
  toJSON (User id' username' email') = 
    object [
        "id" .= id'
      , "username" .= username'
      , "email" .= email'
      ]
instance FromJSON User
