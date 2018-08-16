{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE TypeSynonymInstances       #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Main (main) where

import Database.HDBC
import Database.HDBC.PostgreSQL
import Data.Convertible.Base
import Data.ByteString.UTF8 as BUTF8 (toString, fromString)
import Data.ByteString
import Data.List
import User

main :: IO ()
main =
  do
    let connStr = "service=words"
    conn <- connectPostgreSQL connStr
    begin conn
    select <- prepare conn "SELECT id, username, lang FROM users WHERE id = 2;"
    _ <- execute select []
    rows <- fetchAllRows select
    Prelude.putStrLn (show rows)
    disconnect conn
