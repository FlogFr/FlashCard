module PostgreSQL
  ( initConnectionPool
  )
  where

import Data.Pool (Pool, createPool)
import Database.HDBC (disconnect)
import Database.HDBC.PostgreSQL (Connection, connectPostgreSQL)

type DBConnectionString = String

initConnectionPool :: DBConnectionString -> IO (Pool Connection)
initConnectionPool connStr =
  createPool (connectPostgreSQL connStr)
             disconnect
             2 -- stripes
             60 -- unused connection are kept open for a minute
             10 -- max. 10 connections open per stripe
