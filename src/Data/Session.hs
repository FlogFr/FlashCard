module Data.Session where

import Protolude
import Data.Aeson
import Data.User

data Session = Session
  { sessionUser :: User
  } | AnonymousSession
  deriving (Generic, Show)


instance ToJSON Session where
    toJSON (Session u) = object ["user" .= u]
    toJSON AnonymousSession = object []

    toEncoding (Session u) = pairs ("user" .= u)
    toEncoding AnonymousSession = genericToEncoding defaultOptions AnonymousSession


data SessionSecret = SessionSecret
  { sessionSecret :: ByteString
  } deriving (Generic, Show)
