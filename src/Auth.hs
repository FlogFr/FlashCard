{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE TypeOperators              #-}

module Auth
  ( basicAuthServerContext
  )
  where

import Servant.API.BasicAuth (BasicAuthData(..))
import Servant.Server (Context((:.), EmptyContext), BasicAuthCheck(..), Context, BasicAuthResult(Authorized, Unauthorized))
import User (User(..), userFlog)

-- | 'BasicAuthCheck' holds the handler we'll use to verify a username and password.
authCheck :: BasicAuthCheck User
authCheck =
  let check (BasicAuthData username password) =
        if username == "flog" && password == "flog"
        then return (Authorized (userFlog))
        else return Unauthorized
  in BasicAuthCheck check

-- | We need to supply our handlers with the right Context. In this case,
-- Basic Authentication requires a Context Entry with the 'BasicAuthCheck' value
-- tagged with "foo-tag" This context is then supplied to 'server' and threaded
-- to the BasicAuth HasServer handlers.
basicAuthServerContext :: Context (BasicAuthCheck User ': '[])
basicAuthServerContext = authCheck :. EmptyContext
