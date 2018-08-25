{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NoImplicitPrelude #-}

module User
  ( User(..)
  , userId
  , userUsername
  )
  where

import           Data.Swagger                   ( ToSchema )
import           Data.Aeson
import           Data.Int
import           Data.Eq
import           Data.String
import           Text.Show
import           Database.HDBC
import           Database.YeshQL.HDBC.SqlRow.TH
import           GHC.Generics
import           Servant.Elm                    ( ElmType )
import           StringArray
import           MaybeString


data User = User
  { id        :: Int
  , username  :: String
  , email     :: MaybeString
  , languages :: StringArray
  } deriving (Eq, Generic, Show)
makeSqlRow ''User


userId :: User -> Int
userId = id

userUsername :: User -> String
userUsername = username

instance ToSchema User
instance ToJSON User
instance FromJSON User
instance ElmType User
