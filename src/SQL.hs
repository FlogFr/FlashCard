{-# LANGUAGE QuasiQuotes, DataKinds, DeriveGeneric, DeriveDataTypeable, FlexibleInstances, TypeOperators, TemplateHaskell, MultiParamTypeClasses, NoImplicitPrelude #-}

module SQL
  where

import Data.Int
import Data.String
import Data.Pool (Pool, createPool)
import System.IO
import Database.HDBC
import Database.HDBC.PostgreSQL (Connection, connectPostgreSQL)
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


type DBConnectionString = String

initConnectionPool :: DBConnectionString -> IO (Pool Connection)
initConnectionPool connStr =
  createPool (connectPostgreSQL connStr)
             disconnect
             2 -- stripes
             60 -- unused connection are kept open for a minute
             10 -- max. 10 connections open per stripe


[yeshFile|src/Queries.sql|]
