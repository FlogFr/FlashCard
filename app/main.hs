module Main (main) where

import Data.Pool (Pool, createPool)
import API
import Database.HDBC.PostgreSQL (Connection, connectPostgreSQL)
import Database.HDBC (disconnect)

type DBConnectionString = String

initConnectionPool :: DBConnectionString -> IO (Pool Connection)
initConnectionPool connStr =
  createPool (connectPostgreSQL connStr)
             disconnect
             2 -- stripes
             60 -- unused connection are kept open for a minute
             10 -- max. 10 connections open per stripe

main :: IO ()
main = do
  let connStr = "service=words"
  pool <- initConnectionPool connStr
  runApp pool
