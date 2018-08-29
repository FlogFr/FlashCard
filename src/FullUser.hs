{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NoImplicitPrelude #-}

module FullUser
  ( FullUser(..)
  , fullUserId
  , fullUserEmail
  , fullUserLanguages
  )
  where

import Data.Swagger (ToSchema)
import Data.Aeson
import Data.Int
import Data.Eq
import Data.String
import Text.Show
import Database.HDBC
import Database.YeshQL.HDBC.SqlRow.TH
import GHC.Generics
import Servant.Elm (ElmType)
import StringArray
import MaybeString

data FullUser = FullUser
  { id        :: Int
  , username  :: String
  , passpass  :: String
  , email     :: MaybeString
  , languages :: StringArray
  } deriving (Eq, Generic, Show)
makeSqlRow ''FullUser

fullUserId :: FullUser -> Int
fullUserId = id

fullUserEmail :: FullUser -> MaybeString
fullUserEmail = email

fullUserLanguages :: FullUser -> StringArray
fullUserLanguages = languages

instance ToSchema FullUser
instance ToJSON FullUser
instance FromJSON FullUser
instance ElmType FullUser
