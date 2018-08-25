{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Config
  ( Config(..)
  )
  where

import SQL
import Data.Yaml
import Data.Eq
import Text.Show
import GHC.Generics


newtype Config = Config
  { pgservice :: DBConnectionString
  } deriving (Eq, Generic, Show)

instance ToJSON Config
instance FromJSON Config
