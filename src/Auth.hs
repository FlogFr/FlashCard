{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE TypeOperators              #-}
{-# LANGUAGE TemplateHaskell            #-}

module Auth
  ( basicAuthServerContext
  )
  where

import Servant.API.BasicAuth (BasicAuthData(..))
import Servant.Server (Context((:.), EmptyContext), BasicAuthCheck(..), Context, BasicAuthResult(Authorized, Unauthorized))
import Database.HDBC.PostgreSQL (withPostgreSQL, begin)
import Database.HDBC (commit)
import Database.YeshQL.HDBC (yeshFile)
import Data.ByteString.UTF8 (toString)
import User (User(..))
import Word (Word)
import PostgreSQL

-- | 'BasicAuthCheck' holds the handler we'll use to verify a username and password.
authCheck :: BasicAuthCheck User
authCheck =
  let check (BasicAuthData username password) =
        withPostgreSQL "service=words" $ \conn -> do
          begin conn
          (maybeUser) <- getUser (toString username) (toString password) conn
          commit conn
          case maybeUser of
            Just (userId, userName, userPassword) -> return (Authorized (User userId userName userPassword))
            Nothing -> return Unauthorized
  in  BasicAuthCheck check

-- | We need to supply our handlers with the right Context. In this case,
-- Basic Authentication requires a Context Entry with the 'BasicAuthCheck' value
-- tagged with "foo-tag" This context is then supplied to 'server' and threaded
-- to the BasicAuth HasServer handlers.
basicAuthServerContext :: Context (BasicAuthCheck User ': '[])
basicAuthServerContext = authCheck :. EmptyContext
