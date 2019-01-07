module Database 
  ( DBConnectionString
  , initConnectionPool
  ) where

import Protolude

import Database.PostgreSQL.LibPQ (Connection, connectdb, finish)
import           Data.Pool                      ( Pool
                                                , createPool
                                                )

type DBConnectionString = Text

initConnectionPool :: DBConnectionString -> IO (Pool Connection)
initConnectionPool connTxt =
  createPool (connectdb . encodeUtf8 $ (connTxt))
             finish
             2 -- stripes
             60 -- unused connection are kept open for a minute
             10 -- max. 10 connections open per stripe
