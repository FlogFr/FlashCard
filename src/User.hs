{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE TypeOperators              #-}
{-# LANGUAGE TemplateHaskell            #-}

module User
  ( User(..)
  , GrantUser(..)
  , NewUser(..)
  , userConstructor
  )
  where

import Data.Swagger
import Data.Aeson
import GHC.Generics
import Servant.Elm (ElmType)

data User = User
  { userid :: Int
  , username :: String
  } deriving (Eq, Generic, Show)

userConstructor :: (Int, String) -> User
userConstructor (userId, userName) =
  User userId userName

instance ToSchema User
instance ToJSON User
instance FromJSON User
instance ElmType User

data GrantUser = GrantUser
  { grantUsername :: String
  , grantPassword :: String
  } deriving (Eq, Generic, Show)

instance ToSchema GrantUser
instance ToJSON GrantUser
instance FromJSON GrantUser
instance ElmType GrantUser

type MaybeString = Maybe String

data NewUser = NewUser
  { newUsername :: String
  , newPassword :: String
  , newEmail :: MaybeString
  } deriving (Eq, Generic, Show)

instance ToSchema NewUser
instance ToJSON NewUser
instance FromJSON NewUser
instance ElmType NewUser
