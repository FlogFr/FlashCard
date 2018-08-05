{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE ScopedTypeVariables        #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE TypeOperators              #-}
{-# LANGUAGE UndecidableInstances       #-}
{-# LANGUAGE DeriveDataTypeable         #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module API
  ( runApp
  , CombinedAPI
  , userServer
  , UserAPI
  , WordAPI
  , wordServer
  )
  where

import Prelude hiding (Word, words)
import Data.Pool
import Data.Aeson
import Data.Swagger
import GHC.Generics
import Control.Lens
import Control.Monad.IO.Class (liftIO)
import Servant.API ((:<|>) ((:<|>)), (:>), BasicAuth, Get, Post, ReqBody, JSON, NoContent(..))
import Servant.API.BasicAuth (BasicAuthData (BasicAuthData))
import qualified Data.ByteString.Lazy.UTF8 as BU
import Database.HDBC (commit, catchSql)
import Database.HDBC.PostgreSQL (Connection, begin)
import Network.Wai
import Network.Wai.Handler.Warp
import Network.Wai.Middleware.Cors
import Network.Wai.Middleware.RequestLogger (logStdoutDev)
import Servant
import Servant.Server
import Servant.Swagger
import Servant.Swagger.UI
import PostgreSQL
import Word (Word(..), WordId, wordConstructor)
import User (User(..), NewUser(..))
import Token (Token(..))
import Auth


mkError :: ServantErr -> String -> ServantErr
mkError errorType message = errorType
  { errBody = BU.fromString message
  }


error400 :: String -> ServantErr
error400 = mkError err400


pgNewToken :: Connection -> IO Token
pgNewToken conn = do
  maybeToken <- getNewToken conn
  case maybeToken of
    Just token ->
      return $ Token token
    Nothing ->
      return $ Token ""

pgCreateUser :: String -> NewUser -> Connection -> IO NoContent
pgCreateUser uuid newUser conn = do
  maybeTokenIsValid <- verifyToken uuid conn
  case maybeTokenIsValid of
    Just tokenIsValid ->
      if tokenIsValid
        then do
          _ <- insertUser newUser conn
          return NoContent
        else return NoContent
    Nothing ->
      return NoContent

-- | API for the users
type AuthAPI = "token" :> Get '[JSON] Token
          :<|> "create" :> Capture "uuid" String :> ReqBody '[JSON] NewUser :> Post '[JSON] NoContent

authServer :: Pool Connection -> Server AuthAPI
authServer conns = newToken
              :<|> createUser

  where newToken :: Handler Token
        newToken = do
          liftIO $ 
            withResource conns $ \conn -> do
              begin conn
              token <- pgNewToken conn
              commit conn
              return token

        createUser :: String -> NewUser -> Handler NoContent
        createUser uuid newUser = do
          liftIO pgExec
          return NoContent
          where
            pgExec = withResource conns $ \conn -> do
              begin conn
              token <- pgCreateUser uuid newUser conn
              commit conn
              return ()

-- | API for the users
type UserAPI = Get '[JSON] User

userServer :: User -> Server UserAPI
userServer user = return user

-- Helpers for the word API
pgRetrieveAllWords :: User -> Connection -> IO [Word]
pgRetrieveAllWords user conn = do
  listWords <- getAllWords user conn
  return $ map wordConstructor listWords

pgRetrieveLastWords :: User -> Connection -> IO [Word]
pgRetrieveLastWords user conn = do
  listWords <- getLastWords user conn
  return $ map wordConstructor listWords

pgRetrieveSearchWords :: User -> String -> Connection -> IO [Word]
pgRetrieveSearchWords user searchWord conn = do
  listWords <- getSearchWords user searchWord conn
  return $ map wordConstructor listWords

pgRetrieveWordById :: User -> WordId -> Connection -> IO Word
pgRetrieveWordById user wordId conn = do
  listWords <- getWordById user wordId conn
  return $ (map wordConstructor listWords)!!0

pgUpdateWordById :: User -> WordId -> Word -> Connection -> IO (Maybe Integer)
pgUpdateWordById user wordId word conn = updateWordById user wordId word conn

-- | API for the words
type WordAPI = "all" :> Get '[JSON] [Word]
          :<|> "last" :> Get '[JSON] [Word]
          :<|> "search" :> Capture "searchWord" String :> Get '[JSON] [Word]
          :<|> "id" :> Capture "wordId" WordId :> Get '[JSON] Word
          :<|> "id" :> Capture "wordId" WordId :> Delete '[JSON] NoContent
          :<|> ReqBody '[JSON] Word :> "id" :> Capture "wordId" WordId :> Put '[JSON] Word
          :<|> ReqBody '[JSON] Word :> Post '[JSON] NoContent

wordServer :: User -> Pool Connection -> Server WordAPI
wordServer user conns = retrieveAllWords
                   :<|> retrieveLastWords
                   :<|> retrieveSearchWords
                   :<|> retrieveWordById
                   :<|> deleteWordByIdHandler
                   :<|> putWordById
                   :<|> postWord

  where retrieveAllWords :: Handler [Word]
        retrieveAllWords = do
          liftIO $ 
            withResource conns $ \conn -> do
              begin conn
              words <- pgRetrieveAllWords user conn
              commit conn
              return words

        retrieveLastWords :: Handler [Word]
        retrieveLastWords = do
          liftIO $ 
            withResource conns $ \conn -> do
              begin conn
              words <- pgRetrieveLastWords user conn
              commit conn
              return words

        retrieveSearchWords :: String -> Handler [Word]
        retrieveSearchWords searchWord = do
          liftIO $ 
            withResource conns $ \conn -> do
              begin conn
              words <- pgRetrieveSearchWords user searchWord conn
              commit conn
              return words

        retrieveWordById :: WordId -> Handler Word
        retrieveWordById wordId = do
          liftIO $ 
            withResource conns $ \conn -> do
              begin conn
              words <- pgRetrieveWordById user wordId conn
              commit conn
              return words

        deleteWordByIdHandler :: WordId -> Handler NoContent
        deleteWordByIdHandler wordId = do
          liftIO $ 
            withResource conns $ \conn -> do
              begin conn
              words <- deleteWordById user wordId conn
              commit conn
              return ()
          return NoContent

        putWordById :: Word -> WordId -> Handler Word
        putWordById word wordId = do
          liftIO $ 
            withResource conns $ \conn -> do
              begin conn
              words <- pgUpdateWordById user wordId word conn
              commit conn
              return word

        postWord :: Word -> Handler NoContent
        postWord word = do
          liftIO $
            withResource conns $ \conn -> do
              begin conn
              insertWord user (wordLanguage word) (wordWord word) (wordDefinition word) conn
              commit conn
              return ()
          return NoContent


-- | API for serving @swagger.json@.
type SwaggerAPI = "swagger.json" :> Get '[JSON] Swagger

-- | API for all objects
type CombinedAPI = "user" :> UserAPI
              :<|> "words" :> WordAPI

-- | Combined API of a Todo service with Swagger documentation.
type API = BasicAuth "words-realm" User :> CombinedAPI
      :<|> "auth" :> AuthAPI
      :<|> SwaggerSchemaUI "swagger-ui" "swagger.json"

combinedServer :: User -> Pool Connection -> Server CombinedAPI
combinedServer user conns = ( (userServer user) :<|> (wordServer user conns) )

apiServer :: Pool Connection -> Server API
apiServer conns =
  let authCombinedServer (user :: User) = (combinedServer user conns)
  in  (authCombinedServer :<|> (authServer conns) :<|> swaggerSchemaUIServer apiSwagger)

api :: Proxy API
api = Proxy

-- | Swagger spec for Todo API.
apiSwagger :: Swagger
apiSwagger = toSwagger (Proxy :: Proxy CombinedAPI)
  & info.title        .~ "OuiCook API"
  & info.version      .~ "1.0"
  & info.description  ?~ "OuiCook is 100% API driven"
  & info.license      ?~ "MIT"

app :: Pool Connection -> Application
app conns = serveWithContext api basicAuthServerContext (apiServer conns)

corsPolicy :: CorsResourcePolicy
corsPolicy = CorsResourcePolicy {
    corsOrigins = Nothing
  , corsMethods = ["GET", "HEAD", "PUT", "POST", "DELETE"]
  , corsRequestHeaders =["Authorization", "Content-Type"]
  , corsExposedHeaders = corsExposedHeaders simpleCorsResourcePolicy
  , corsMaxAge = corsMaxAge simpleCorsResourcePolicy
  , corsVaryOrigin = corsVaryOrigin simpleCorsResourcePolicy
  , corsRequireOrigin = False
  , corsIgnoreFailures = corsIgnoreFailures simpleCorsResourcePolicy
}

runApp :: Pool Connection -> IO ()
runApp conns = do
  Network.Wai.Handler.Warp.run 8080 (logStdoutDev . (cors $ const $ Just corsPolicy) $ (app conns))
