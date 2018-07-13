module Main where

import Lib
import PostgreSQL

main :: IO ()
main = do
  let connStr = "service=words"
  pool <- initConnectionPool connStr
  runApp pool
