{-# LANGUAGE QuasiQuotes, DataKinds, DeriveGeneric, DeriveDataTypeable, FlexibleInstances, TypeOperators, TemplateHaskell, MultiParamTypeClasses, NoImplicitPrelude #-}

module FullUser
  ( FullUser(..)
  , fullUserId
  , fullUserEmail
  , fullUserLang
  )
  where

import Data.Swagger (ToSchema)
import Data.Aeson
import Data.Typeable
import Data.Convertible
import Data.Int
import Data.Eq
import Data.String
import Text.Show
import Database.HDBC
import Database.YeshQL.HDBC.SqlRow.Class
import Database.YeshQL.HDBC.SqlRow.TH
import GHC.Generics
import Prelude (Integer, Bool)
import Servant.Elm (ElmType)

data FullUser = FullUser
  { id        :: Int
  , username  :: String
  , passpass  :: String
  , email     :: String
  , lang      :: String
  } deriving (Eq, Generic, Show)
makeSqlRow ''FullUser

fullUserId :: FullUser -> Int
fullUserId = id

fullUserEmail :: FullUser -> String
fullUserEmail = email

fullUserLang :: FullUser -> String
fullUserLang = lang

instance ToSchema FullUser
instance ToJSON FullUser
instance FromJSON FullUser
instance ElmType FullUser
