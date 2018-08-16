{-# LANGUAGE QuasiQuotes, DataKinds, DeriveGeneric, DeriveDataTypeable, FlexibleInstances, TypeOperators, TemplateHaskell, MultiParamTypeClasses #-}

module NewUser
  ( NewUser(..)
  , insertUser
  )
  where

import Data.Swagger (ToSchema)
import Data.Aeson
import Data.Typeable
import Data.Convertible
import Database.HDBC
import Database.YeshQL.HDBC (yeshFile)
import Database.YeshQL.HDBC.SqlRow.Class
import Database.YeshQL.HDBC.SqlRow.TH
import GHC.Generics
import Servant.Elm (ElmType)


type MaybeString = Maybe String

data NewUser = NewUser
  { username :: String
  , password :: String
  , email :: MaybeString
  } deriving (Eq, Generic, Show)

instance ToSchema NewUser
instance ToJSON NewUser
instance FromJSON NewUser
instance ElmType NewUser

[yeshFile|src/sql/NewUser.sql|]
