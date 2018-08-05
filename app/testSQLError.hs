{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE TypeSynonymInstances       #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE MultiParamTypeClasses      #-}

module Main (main) where

import Database.HDBC
import Database.HDBC.PostgreSQL
import PostgreSQL
import User


main :: IO ()
main =
  do
    let connStr = "service=words"
    conn <- connectPostgreSQL connStr
    begin conn
    _ <- insertUser (NewUser "test" "pouet" (Just "test@email.fr")) conn
    commit conn
