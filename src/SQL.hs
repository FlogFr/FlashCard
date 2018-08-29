{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NoImplicitPrelude #-}

module SQL
  where

import           Data.Int
import           Data.String
import           Data.Pool                      ( Pool
                                                , createPool
                                                )
import           System.IO
import           Database.HDBC
import           Database.HDBC.PostgreSQL       ( Connection
                                                , connectPostgreSQL
                                                )
import           Database.YeshQL.HDBC           ( yeshFile )
import           Prelude                        ( Integer
                                                , Bool
                                                )
import           User                           ( User
                                                , userId
                                                )
import           FullUser                       ( FullUser
                                                , fullUserEmail
                                                , fullUserLanguages
                                                )
import           NewUser                        ( NewUser
                                                , newuserUsername
                                                , newuserPassword
                                                , newuserEmail
                                                , newuserLanguages
                                                )
import           Word                           ( Word
                                                , WordId
                                                , language
                                                , word
                                                , definition
                                                , keywords
                                                , difficulty
                                                )


type DBConnectionString = String

initConnectionPool :: DBConnectionString -> IO (Pool Connection)
initConnectionPool connStr =
  createPool (connectPostgreSQL connStr)
             disconnect
             2 -- stripes
             60 -- unused connection are kept open for a minute
             10 -- max. 10 connections open per stripe


[yeshFile|src/Queries.sql|]
