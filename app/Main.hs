module Main where

import Lib

main :: IO ()
main = do
  let connStr = "service=words"
  pool <- initConnectionPool connStr
  runApp pool
