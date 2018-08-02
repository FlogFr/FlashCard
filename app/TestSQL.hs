module Main (main) where

import Database.HDBC
import Database.HDBC.PostgreSQL

main :: IO ()
main = do
  let connStr = "service=words"
  conn <- connectPostgreSQL connStr
  begin conn
  select <- prepare conn "SELECT * FROM words WHERE id = 400;"
  exeReturn <- execute select []
  result <- fetchAllRows select
  putStrLn $ show result
