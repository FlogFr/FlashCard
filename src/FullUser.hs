{-# LANGUAGE QuasiQuotes, DataKinds, DeriveGeneric, DeriveDataTypeable, FlexibleInstances, TypeOperators, TemplateHaskell, MultiParamTypeClasses #-}

module FullUser
  ( FullUser(..)
  , updateFullUser
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
import User

data FullUser = FullUser
  { userid    :: Int
  , username  :: String
  , passpass  :: String
  , email     :: String
  , lang      :: String
  } deriving (Eq, Generic, Show)
makeSqlRow ''FullUser

instance ToSchema FullUser
instance ToJSON FullUser
instance FromJSON FullUser
instance ElmType FullUser

[yeshFile|src/sql/FullUser.sql|]
