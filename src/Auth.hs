{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TypeOperators              #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE ScopedTypeVariables        #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE UndecidableInstances       #-}

module Auth where

import Data.ByteString                  (ByteString)
import Control.Monad.IO.Class (liftIO)
import Servant        (throwError)
import Servant.Server (Context((:.),
                               EmptyContext)
                       , BasicAuthCheck(..)
                       , Context
                       , err401, err403, errBody
                       , Handler
                       , BasicAuthResult(Authorized, Unauthorized)
                       )
import Servant.API.Experimental.Auth    (AuthProtect)
import Servant.Server.Experimental.Auth (AuthHandler, AuthServerData,
                                         mkAuthHandler)
import Servant.Server.Experimental.Auth()
import Network.Wai                      (Request, requestHeaders)

import Database.HDBC.PostgreSQL (withPostgreSQL, begin)
import Database.HDBC (commit, SqlError, handleSql)
import Database.YeshQL.HDBC (yeshFile)
import Data.ByteString.UTF8 (toString)
import User (User(..))
import Word (Word)
import PostgreSQL

-- | We need to specify the data returned after authentication
type instance AuthServerData (AuthProtect "jwt-auth") = User

-- | The context that will be made available to request handlers. We supply the
-- "cookie-auth"-tagged request handler defined above, so that the 'HasServer' instance
-- of 'AuthProtect' can extract the handler and run it on the request.
genAuthServerContext :: Context (AuthHandler Request User ': '[])
genAuthServerContext = authHandler :. EmptyContext

authHandler :: AuthHandler Request User
authHandler = mkAuthHandler handler
  where
    maybeToEither e = maybe (Left e) Right
    throw401 msg = throwError $ err401 { errBody = msg }
    handler req = either throw401 handlerLookupUserFromJWT $ do
      maybeToEither "Missing authentication header" $ lookup "authorization" $ requestHeaders req

handlerLookupUserFromJWT :: ByteString -> Handler User
handlerLookupUserFromJWT jwtHeaderByteString = do
  eitherSqlErrorOrUser <- lookupUserFromJWTE jwtHeaderByteString
  either handlerSqlError returnUser $ eitherSqlErrorOrUser
  where
    throw401 msg = throwError $ err401 { errBody = msg }
    handlerSqlError sqlErrorValue = 
      throw401 "Error of authentication"
    returnUser user = do
      return user

lookupUserFromJWT :: ByteString -> Handler User
lookupUserFromJWT jwtHeaderString = do
  liftIO $
    withPostgreSQL "service=words" $ \conn -> do
      begin conn
      (maybeUser) <- verifyJWT (toString jwtHeaderString) conn
      commit conn
      case maybeUser of
        Just (userId, userName) -> return $ User userId userName
        Nothing -> fail "impossible to find the user"

handleSqlError :: SqlError -> IO (Either SqlError User)
handleSqlError sqlError = do
  return $ Left sqlError

lookupUserFromJWTE :: ByteString -> Handler (Either SqlError User)
lookupUserFromJWTE jwtHeaderString = do
  liftIO $ handleSql handleSqlError pgExec
  where
    pgExec = withPostgreSQL "service=words" $ \conn -> do
      begin conn
      (maybeUser) <- verifyJWT (toString jwtHeaderString) conn
      commit conn
      case maybeUser of
        Just (userId, userName) -> return $ Right ( User userId userName )
        Nothing -> fail "impossible to find the user"
