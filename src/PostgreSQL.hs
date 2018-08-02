{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TemplateHaskell            #-}

module PostgreSQL
  ( initConnectionPool
  , getUser
  , getAllWords
  , getLastWords
  , getWordById
  , updateWordById
  , insertWord
  )
  where

import Prelude hiding (Word)
import Data.Pool (Pool, createPool)
import Database.HDBC (disconnect)
import Database.HDBC.PostgreSQL (Connection, connectPostgreSQL)
import User (User(..))
import Word (Word(..))
import Database.YeshQL.HDBC (yeshFile)

type WordId = Int
type MaybeInt = Maybe Int
type MaybeString = Maybe [String]
type MaybeStringArr = Maybe [String]

type DBConnectionString = String

[yeshFile|src/Queries.sql|]

initConnectionPool :: DBConnectionString -> IO (Pool Connection)
initConnectionPool connStr =
  createPool (connectPostgreSQL connStr)
             disconnect
             2 -- stripes
             60 -- unused connection are kept open for a minute
             10 -- max. 10 connections open per stripe
