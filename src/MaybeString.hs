{-# LANGUAGE QuasiQuotes, DataKinds, DeriveGeneric, DeriveDataTypeable, FlexibleInstances, TypeOperators, TemplateHaskell, MultiParamTypeClasses #-}


module MaybeString
  where

import Data.String
import Data.Maybe

type MaybeString = Maybe String
