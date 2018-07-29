{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE TypeOperators              #-}
{-# LANGUAGE TemplateHaskell            #-}

module User
  ( User(..)
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

instance ToSchema User
instance ToJSON User
instance FromJSON User
instance ElmType User
