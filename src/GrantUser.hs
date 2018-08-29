{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module GrantUser
  ( GrantUser(..)
  )
  where

import Data.Swagger
import Data.Aeson
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
