{-# LANGUAGE QuasiQuotes, DataKinds, DeriveGeneric, DeriveDataTypeable, FlexibleInstances, TypeOperators, TemplateHaskell, MultiParamTypeClasses #-}

module GrantUser
  ( GrantUser(..)
  )
  where

import Data.Swagger
import Data.Aeson
import Data.Typeable
import Data.Convertible
import Database.HDBC
import Database.YeshQL.HDBC.SqlRow.Class
import Database.YeshQL.HDBC.SqlRow.TH
import GHC.Generics
import Servant.Elm (ElmType)

data GrantUser = GrantUser
  { username :: String
  , password :: String
  } deriving (Eq, Generic, Show)

instance ToSchema GrantUser
instance ToJSON GrantUser
instance FromJSON GrantUser
instance ElmType GrantUser
