{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module NewUser
  ( NewUser(..)
  , newuserUsername
  , newuserPassword
  , newuserEmail
  , newuserLanguages
  )
  where

import Data.Swagger (ToSchema)
import Data.Aeson
import GHC.Generics
import Servant.Elm (ElmType)
import StringArray
import MaybeString


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
