{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE TypeOperators              #-}
{-# LANGUAGE TemplateHaskell            #-}

module Token
  ( Token(..),
  )
  where

import Data.Swagger
import Data.Aeson
import GHC.Generics
import Servant.Elm (ElmType)

data Token = Token
  { token :: String
  } deriving (Eq, Generic, Show)

instance ToSchema Token
instance ToJSON Token
instance FromJSON Token
instance ElmType Token
