{-# LANGUAGE QuasiQuotes, DataKinds, DeriveGeneric, DeriveDataTypeable, FlexibleInstances, TypeOperators, TemplateHaskell, MultiParamTypeClasses #-}

module NewUser
  ( NewUser(..)
  , newuserUsername
  , newuserPassword
  , newuserEmail
  , newuserLang
  )
  where

import Data.Swagger (ToSchema)
import Data.Aeson
import Data.Typeable
import Data.Convertible
import Database.HDBC
import Database.YeshQL.HDBC.SqlRow.Class
import Database.YeshQL.HDBC.SqlRow.TH
import GHC.Generics
import Servant.Elm (ElmType)


type MaybeString = Maybe String

data NewUser = NewUser
  { username :: String
  , password :: String
  , email    :: MaybeString
  , lang     :: String
  } deriving (Eq, Generic, Show)


newuserUsername :: NewUser -> String
newuserUsername = username

newuserPassword :: NewUser -> String
newuserPassword = password

newuserEmail :: NewUser -> MaybeString
newuserEmail = email

newuserLang :: NewUser -> String
newuserLang = lang

instance ToSchema NewUser
instance ToJSON NewUser
instance FromJSON NewUser
instance ElmType NewUser
