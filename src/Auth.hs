{-# LANGUAGE TypeFamilies #-}

module Auth where

import           Protolude
import           Data.List
import           Data.String
import           Data.Pool
import           Data.Exception
import           Control.Lens            hiding ( Context )
import           Crypto.Hash             hiding ( Context )
import           Data.Byteable
import           Data.Aeson.Lens
import           Database.Queries
import           Database.PostgreSQL.LibPQ
import           Servant
import           Servant.Server                 ( Context((:.), EmptyContext)
                                                , Handler
                                                )
import           Servant.API.Experimental.Auth  ( AuthProtect )
import           Servant.Server.Experimental.Auth
                                                ( AuthHandler
                                                , AuthServerData
                                                , mkAuthHandler
                                                )
import           Network.Wai                    ( Request
                                                , requestHeaders
                                                )
import qualified Data.ByteString               as BS
import qualified Data.ByteString.Base64        as BS64
import           Web.Cookie                     ( parseCookies )

import           Data.User
import Data.Session

-- | We need to specify the data returned after authentication
type instance AuthServerData (AuthProtect "custom-auth") = Session


-- | A method that, when given a JWT ByteString, will return a User
-- This is our bespoke (and bad) authentication logic.
sessionFromJWT :: Pool Connection -> ByteString -> Handler Session
sessionFromJWT dbPool jwtPartsBS = do
  let jwtParts = BS.split 46 jwtPartsBS
  if length jwtParts /= 3
    then throwError $ err302 {
             errHeaders = [
                 ("Location", "/")
               , ("Set-Cookie", "jwt=deleted; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT")
             ]
           }
    else do
      let jwtHeader = jwtParts!!0
      let jwtPayload = jwtParts!!1
      let jwtSignature = jwtParts!!2
      
      let eJwtPayloadBS = BS64.decode jwtPayload
      case eJwtPayloadBS of
        Right jwtPayloadBS -> do
          let mUserEmail = jwtPayloadBS ^? key "email"
                                        . _String
          case mUserEmail of
            Just userEmail' -> do
              eitherSecrets <- withResource dbPool $ \conn -> liftIO $ (try $ do
                secrets' <- queryFromText conn "SELECT s.secret FROM user_account uc JOIN session s ON s.userid = uc.id WHERE s.created_at > now() - INTERVAL '14 days' AND uc.email = CAST($1 AS CITEXT) ;"
                          [ Just (Oid 25, encodeUtf8 userEmail', Binary) ] :: IO [Text]
                return $ secrets') :: Handler (Either ExceptionPostgreSQL [Text])
              case eitherSecrets of
                Right secretList -> do
                  let signatureList = (\s -> BS64.encode $ toBytes $ hmacAlg SHA256 (encodeUtf8 $ s) (jwtHeader <> "." <> jwtPayload)) <$> secretList

                  let signatureVerified = filter (\s -> s == jwtSignature) signatureList
                  if length signatureVerified > 0
                    then do
                      -- the JWT has been verified at least against one
                      -- secret. All good, we can retrieve and return the
                      -- user
                      eitherUserList <- withResource dbPool $ \conn -> liftIO $ (try $ do
                        eitherUser' <- queryFromText conn ("SELECT uc.id , uc.username , uc.email , uc.languages "
                                                          <> "FROM user_account uc "
                                                          <> "WHERE uc.email = CAST($1 AS email_d) ;")
                                  [ Just (Oid 25, encodeUtf8 userEmail', Binary) ] :: IO [User]
                        return $ eitherUser') :: Handler (Either ExceptionPostgreSQL [User])
                      case eitherUserList of
                        Right userList -> do
                          if length userList > 0
                            then return $ Session (userList!!0)
                            else return AnonymousSession
                        Left _ -> return AnonymousSession
                    else return AnonymousSession
                Left _ -> return AnonymousSession
            Nothing -> return AnonymousSession
        Left _ -> return AnonymousSession

--- | The auth handler wraps a function from Request -> Handler Session.
--- We look for a token in the request headers that we expect to be in the cookie.
authHandler :: Pool Connection -> AuthHandler Request Session
authHandler dbPool = mkAuthHandler handler
  where handler :: Request -> Handler Session
        handler req = either returnAnonymousSession (sessionFromJWT dbPool) $ do
          cookie <- maybeToEither "Missing cookie header" $ lookup "cookie" $ requestHeaders req
          maybeToEither "Missing JWT cookie" $ lookup "jwt" $ parseCookies cookie

        returnAnonymousSession :: String -> Handler Session
        returnAnonymousSession _ = return AnonymousSession

contextProxy :: Proxy '[(Servant.Server.Experimental.Auth.AuthHandler Request Session)]
contextProxy = Proxy

-- | The context that will be made available to request handlers. We supply the
-- "cookie-auth"-tagged request handler defined above, so that the 'HasServer' instance
-- of 'AuthProtect' can extract the handler and run it on the request.
authServerContext :: Pool Connection -> Context (AuthHandler Request Session ': '[])
authServerContext pool = (authHandler pool) :. EmptyContext
