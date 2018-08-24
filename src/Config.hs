{-# LANGUAGE QuasiQuotes, DataKinds, DeriveGeneric, DeriveDataTypeable, FlexibleInstances, TypeOperators, TemplateHaskell, MultiParamTypeClasses, NoImplicitPrelude #-}

module Config
  ( Config(..)
  )
  where

import Data.Swagger (ToSchema)
import SQL
import Data.Yaml
import Data.Typeable
import Data.Convertible
import Data.Int
import Data.Eq
import Data.String
import Text.Show
import Data.ByteString.UTF8 as BUTF8 (toString, fromString)
import Data.ByteString
import Database.HDBC
import Database.YeshQL.HDBC.SqlRow.Class
import Database.YeshQL.HDBC.SqlRow.TH
import GHC.Generics
import Prelude (Integer, Bool)
import Servant.Elm (ElmType)
import StringArray
import MaybeString


data Config = Config
  { pgservice :: DBConnectionString
  } deriving (Eq, Generic, Show)

instance ToJSON Config
instance FromJSON Config
