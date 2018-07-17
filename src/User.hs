{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE TypeOperators              #-}
{-# LANGUAGE TemplateHaskell            #-}

module User
  ( User(..)
  , userFlog
  )
  where

import Data.Swagger
import Data.Aeson
import GHC.Generics
import Servant.Elm (ElmType)

data User = User
  { userid :: Int
  , username :: String
  , userpassword :: String
  } deriving (Eq, Generic, Show)

instance ToSchema User
instance ToJSON User
instance FromJSON User
instance ElmType User

userFlog :: User
userFlog = User 1 "flog" "flog"
