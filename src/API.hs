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
import Servant.API ((:<|>) ((:<|>)), (:>), Get, Post, ReqBody, JSON, NoContent(..))
import qualified Data.ByteString.Lazy.UTF8 as BU
import Database.HDBC (commit, withTransaction, catchSql)
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
import User (User(..), GrantUser(..), NewUser(..), userConstructor)
import Token (Token(..))
import JWTToken (JWTToken(..))
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

pgGrantUserJWTToken :: GrantUser -> Connection -> IO JWTToken
pgGrantUserJWTToken grantUser conn = do
  maybeJWTToken <- getSessionJWT (grantUsername grantUser) (grantPassword grantUser) conn
  case maybeJWTToken of
    Just jwtToken ->
      return $ JWTToken jwtToken
    Nothing ->
      return $ JWTToken ""


-- | API for the users
type AuthAPI = "token" :> Get '[JSON] Token
          :<|> "create" :> Capture "uuid" String :> ReqBody '[JSON] NewUser :> Post '[JSON] NoContent
          :<|> "grant" :> ReqBody '[JSON] GrantUser :> Post '[JSON] JWTToken

authServer :: Pool Connection -> Server AuthAPI
authServer conns = newToken
              :<|> createUser
              :<|> grantHandler

  where newToken :: Handler Token
        newToken = do
          liftIO $ 
            withResource conns $ \conn -> do
              withTransaction conn $ \conn -> do
                token <- pgNewToken conn
                return token

        createUser :: String -> NewUser -> Handler NoContent
        createUser uuid newUser = do
          liftIO pgExec
          return NoContent
          where
            pgExec = withResource conns $ \conn -> do
              withTransaction conn $ \conn -> do
                token <- pgCreateUser uuid newUser conn
                return ()

        grantHandler :: GrantUser -> Handler JWTToken
        grantHandler grantUser = do
          liftIO $ 
            withResource conns $ \conn -> do
              withTransaction conn $ \conn -> do
                jwtToken <- pgGrantUserJWTToken grantUser conn
                return jwtToken

-- | API for the users
type UserAPI = Get '[JSON] User
          :<|> ReqBody '[JSON] GrantUser :> Put '[JSON] User

userServer :: User -> Pool Connection -> Server UserAPI
userServer user conns = retrieveUser
                   :<|> putUser

  where retrieveUser :: Handler User
        retrieveUser = return user

        putUser :: GrantUser -> Handler User
        putUser grantUser = do
          liftIO $ 
            withResource conns $ \conn -> do
              withTransaction conn $ \conn -> do
                listNewUserRows <- updateUser user (grantPassword grantUser) conn
                return $ (map userConstructor listNewUserRows)!!0

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
          :<|> "quizz" :> "keyword" :> Capture "searchKeyword" String :> Get '[JSON] [Word]
          :<|> "search" :> Capture "searchWord" String :> Get '[JSON] [Word]
          :<|> "id" :> Capture "wordId" WordId :> Get '[JSON] Word
          :<|> "id" :> Capture "wordId" WordId :> Delete '[JSON] NoContent
          :<|> ReqBody '[JSON] Word :> "id" :> Capture "wordId" WordId :> Put '[JSON] Word
          :<|> ReqBody '[JSON] Word :> Post '[JSON] NoContent
          :<|> "keywords" :> Get '[JSON] [String]

wordServer :: User -> Pool Connection -> Server WordAPI
wordServer user conns = retrieveAllWords
                   :<|> retrieveLastWords
                   :<|> quizzWordsByKeyword
                   :<|> retrieveSearchWords
                   :<|> retrieveWordById
                   :<|> deleteWordByIdHandler
                   :<|> putWordById
                   :<|> postWord
                   :<|> retrieveKeywords

  where retrieveAllWords :: Handler [Word]
        retrieveAllWords = do
          liftIO $ 
            withResource conns $ \conn -> do
              withTransaction conn $ \conn -> do
                words <- pgRetrieveAllWords user conn
                return words

        retrieveLastWords :: Handler [Word]
        retrieveLastWords = do
          liftIO $ 
            withResource conns $ \conn -> do
              withTransaction conn $ \conn -> do
                words <- pgRetrieveLastWords user conn
                return words

        quizzWordsByKeyword :: String -> Handler [Word]
        quizzWordsByKeyword keyword = do
          liftIO $ 
            withResource conns $ \conn -> do
              withTransaction conn $ \conn -> do
                listWords <- getQuizzWordsKeyword user keyword conn
                return $ map wordConstructor listWords

        retrieveSearchWords :: String -> Handler [Word]
        retrieveSearchWords searchWord = do
          liftIO $ 
            withResource conns $ \conn -> do
              withTransaction conn $ \conn -> do
                words <- pgRetrieveSearchWords user searchWord conn
                return words

        retrieveWordById :: WordId -> Handler Word
        retrieveWordById wordId = do
          liftIO $ 
            withResource conns $ \conn -> do
              withTransaction conn $ \conn -> do
                words <- pgRetrieveWordById user wordId conn
                return words

        deleteWordByIdHandler :: WordId -> Handler NoContent
        deleteWordByIdHandler wordId = do
          liftIO $ 
            withResource conns $ \conn -> do
              withTransaction conn $ \conn -> do
                words <- deleteWordById user wordId conn
                return ()
          return NoContent

        putWordById :: Word -> WordId -> Handler Word
        putWordById word wordId = do
          liftIO $ 
            withResource conns $ \conn -> do
              withTransaction conn $ \conn -> do
                words <- pgUpdateWordById user wordId word conn
                return word

        postWord :: Word -> Handler NoContent
        postWord word = do
          liftIO $
            withResource conns $ \conn -> do
              withTransaction conn $ \conn -> do
                insertWord user (wordLanguage word) (wordWord word) (wordDefinition word) conn
                return ()
          return NoContent

        retrieveKeywords :: Handler [String]
        retrieveKeywords = do
          liftIO $
            withResource conns $ \conn -> do
              withTransaction conn $ \conn -> do
                keywords <- getAllKeywords user conn
                return keywords


-- | API for serving @swagger.json@.
type SwaggerAPI = "swagger.json" :> Get '[JSON] Swagger

-- | API for all objects
type CombinedAPI = "user" :> UserAPI
              :<|> "words" :> WordAPI

-- | Combined API of a Todo service with Swagger documentation.
type API = AuthProtect "jwt-auth" :> CombinedAPI
      :<|> "auth" :> AuthAPI
      :<|> SwaggerSchemaUI "swagger-ui" "swagger.json"

combinedServer :: User -> Pool Connection -> Server CombinedAPI
combinedServer user conns = ( (userServer user conns) :<|> (wordServer user conns) )

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
app conns = serveWithContext api genAuthServerContext (apiServer conns)

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
