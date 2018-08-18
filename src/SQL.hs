{-# LANGUAGE QuasiQuotes, DataKinds, DeriveGeneric, DeriveDataTypeable, FlexibleInstances, TypeOperators, TemplateHaskell, MultiParamTypeClasses, NoImplicitPrelude #-}

module SQL
  where

import Data.Int
import Data.String
import Database.HDBC
import Database.YeshQL.HDBC (yeshFile)
import Database.YeshQL.HDBC.SqlRow.Class
import Database.YeshQL.HDBC.SqlRow.TH
import GHC.Generics
import Prelude (Integer, Bool)

import User
import FullUser
import GrantUser
import NewUser
import Word
import Token

[yeshFile|src/Queries.sql|]
