module Data.NewUser
  ( NewUser(..)
  , newuserUsername
  , newuserPassword
  , newuserEmail
  , newuserLanguages
  )
  where

import Protolude

import Data.Aeson


data NewUser = NewUser
  { username :: String
  , password :: String
  , email    :: MaybeString
  , languages :: StringArray
  } deriving (Eq, Generic, Show)


newuserUsername :: NewUser -> String
newuserUsername = username

newuserPassword :: NewUser -> String
newuserPassword = password

newuserEmail :: NewUser -> MaybeString
newuserEmail = email

newuserLanguages :: NewUser -> StringArray
newuserLanguages = languages

instance ToSchema NewUser
instance ToJSON NewUser
instance FromJSON NewUser
instance ElmType NewUser
