{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE TypeOperators              #-}
{-# LANGUAGE TemplateHaskell            #-}

module JWTToken
  ( JWTToken(..),
  )
  where

import Data.Swagger
import Data.Aeson
import GHC.Generics
import Servant.Elm (ElmType)

data JWTToken = JWTToken
  { token :: String
  } deriving (Eq, Generic, Show)

instance ToSchema JWTToken
instance ToJSON JWTToken
instance FromJSON JWTToken
instance ElmType JWTToken
