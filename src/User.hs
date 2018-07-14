{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveGeneric              #-}

module User
  ( User
  , UserAPI
  , userServer
  , userFlog
  )
  where

import Data.Swagger
import Data.Aeson
import GHC.Generics
import Servant.Elm (ElmType)
import Servant.API (Get, JSON)
import Servant.Server (Server)

data User = User
  { userId :: Int
  , userName :: String
  } deriving (Eq, Show, Generic)

instance ToSchema User
instance ToJSON User
instance ElmType User

userFlog :: User
userFlog = (User 1 "flog")

userServer :: Server UserAPI
userServer = return userFlog

-- | API for the users
type UserAPI = Get '[JSON] User
