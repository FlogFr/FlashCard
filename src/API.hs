{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE ScopedTypeVariables        #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE TypeOperators              #-}
{-# LANGUAGE UndecidableInstances       #-}

module API
  ( runApp
  , app
  , CombinedAPI
  , userServer
  , UserAPI
  , WordAPI
  , wordServer
  )
  where

import           Auth
import           Control.Lens
import           Control.Monad.IO.Class               (liftIO)
import           Data.Pool
import           Data.Swagger
import           Database.HDBC.PostgreSQL             (Connection)
import           Database.HDBC                        (withTransaction)
import           FullUser
import           GrantUser
import           JWTToken
import           Network.Wai
import           Network.Wai.Handler.Warp
import           Network.Wai.Middleware.Cors
import           Network.Wai.Middleware.RequestLogger (logStdoutDev)
import           NewUser
import           Prelude                              hiding (Word, words)
import           Servant
import           Servant.API                          ((:<|>) ((:<|>)), (:>),
                                                       Get, JSON,
                                                       NoContent (..), Post,
                                                       ReqBody)
import           Servant.Swagger
import           Servant.Swagger.UI
import           SQL
import           Token
import           User
import           Word


pgNewToken :: Connection -> IO Token
pgNewToken conn = do
  maybeToken <- getNewToken conn
  case maybeToken of
    Just returnedToken -> return $ Token returnedToken
    Nothing    -> return $ Token ""

pgCreateUser :: String -> NewUser -> Connection -> IO NoContent
pgCreateUser uuid newUser conn = do
  maybeTokenIsValid <- verifyToken uuid conn
  case maybeTokenIsValid of
    Just tokenIsValid -> if tokenIsValid
      then do
        _ <- insertUser newUser conn
        return NoContent
      else return NoContent
    Nothing -> return NoContent

pgGrantUserJWTToken :: GrantUser -> Connection -> IO JWTToken
pgGrantUserJWTToken grantUser conn = do
  maybeJWTToken <- getSessionJWT (GrantUser.username grantUser)
                                 (GrantUser.password grantUser)
                                 conn
  case maybeJWTToken of
    Just jwtToken -> return $ JWTToken jwtToken
    Nothing       -> return $ JWTToken ""


-- | API for the users
type AuthAPI = "token" :> Get '[JSON] Token
          :<|> "create" :> Capture "uuid" String :> ReqBody '[JSON] NewUser :> Post '[JSON] NoContent
          :<|> "grant" :> ReqBody '[JSON] GrantUser :> Post '[JSON] JWTToken

authServer :: Pool Connection -> Server AuthAPI
authServer conns = newToken :<|> createUser :<|> grantHandler
 where
  newToken :: Handler Token
  newToken = liftIO $ withResource conns $ \conn ->
    withTransaction conn $ \transactionConn -> pgNewToken transactionConn

  createUser :: String -> NewUser -> Handler NoContent
  createUser uuid newUser = do
    liftIO pgExec
    return NoContent
   where
    pgExec =
      withResource conns
        $ \conn -> withTransaction conn $ \transactionConn -> do
            _ <- pgCreateUser uuid newUser transactionConn
            return ()

  grantHandler :: GrantUser -> Handler JWTToken
  grantHandler grantUser = liftIO $ withResource conns $ \conn ->
    withTransaction conn
      $ \transactionConn -> pgGrantUserJWTToken grantUser transactionConn

-- | API for the users
type UserAPI = Get '[JSON] User
          :<|> ReqBody '[JSON] FullUser :> Put '[JSON] User

userServer :: User -> Pool Connection -> Server UserAPI
userServer user conns = retrieveUser :<|> putUser
 where
  retrieveUser :: Handler User
  retrieveUser = return user

  putUser :: FullUser -> Handler User
  putUser fullUser =
    liftIO
      $ withResource conns
      $ \conn -> withTransaction conn $ \transactionConn -> do
          maybeUser <- updateFullUser user fullUser transactionConn
          case maybeUser of
            Just updatedUser -> return updatedUser
            Nothing          -> fail "cant find the user to update"

-- Helpers for the word API
pgRetrieveSearchWords
  :: User -> Maybe String -> Maybe String -> Connection -> IO [Word]
pgRetrieveSearchWords user maybeSearchWord maybeSearchKeyword conn =
  case (maybeSearchWord, maybeSearchKeyword) of
    (Just searchWord, Just searchKeyword) ->
      getSearchWordsKeyword user searchWord searchKeyword conn
    (Just searchWord, Nothing) -> getSearchWords user searchWord conn
    (Nothing, Just searchKeyword) -> getSearchKeyword user searchKeyword conn
    (Nothing, Nothing) -> getSearchWordsUser user conn

-- | API for the words
type WordAPI = "all" :> Get '[JSON] [Word]
          :<|> "last" :> Get '[JSON] [Word]
          :<|> "quizz" :> "keyword" :> Capture "searchKeyword" String :> Get '[JSON] [Word]
          :<|> "search" :> QueryParam "word" String :> QueryParam "keyword" String :> Get '[JSON] [Word]
          :<|> "id" :> Capture "wordId" WordId :> Get '[JSON] Word
          :<|> "id" :> Capture "wordId" WordId :> Delete '[JSON] NoContent
          :<|> ReqBody '[JSON] Word :> "id" :> Capture "wordId" WordId :> Put '[JSON] Word
          :<|> ReqBody '[JSON] Word :> Post '[JSON] NoContent
          :<|> "keywords" :> Get '[JSON] [String]

wordServer :: User -> Pool Connection -> Server WordAPI
wordServer user conns =
  retrieveAllWords
    :<|> retrieveLastWords
    :<|> quizzWordsByKeyword
    :<|> retrieveSearchWords
    :<|> retrieveWordById
    :<|> deleteWordByIdHandler
    :<|> putWordById
    :<|> postWord
    :<|> retrieveKeywords
 where
  retrieveAllWords :: Handler [Word]
  retrieveAllWords = liftIO $ withResource conns $ \conn ->
    withTransaction conn $ \transactionConn -> getAllWords user transactionConn

  retrieveLastWords :: Handler [Word]
  retrieveLastWords = liftIO $ withResource conns $ \conn ->
    withTransaction conn $ \transactionConn -> getLastWords user transactionConn

  quizzWordsByKeyword :: String -> Handler [Word]
  quizzWordsByKeyword keyword = liftIO $ withResource conns $ \conn ->
    withTransaction conn
      $ \transactionConn -> getQuizzWordsKeyword user keyword transactionConn

  retrieveSearchWords :: Maybe String -> Maybe String -> Handler [Word]
  retrieveSearchWords maybeSearchWord maybeSearchKeyword =
    liftIO $ withResource conns $ \conn ->
      withTransaction conn $ \transactionConn -> pgRetrieveSearchWords
        user
        maybeSearchWord
        maybeSearchKeyword
        transactionConn

  retrieveWordById :: WordId -> Handler Word
  retrieveWordById wordId =
    liftIO
      $ withResource conns
      $ \conn -> withTransaction conn $ \transactionConn -> do
          maybeWord <- getWordById user wordId transactionConn
          case maybeWord of
            Just userWord -> return userWord
            Nothing       -> fail "impossible to find the word"

  deleteWordByIdHandler :: WordId -> Handler NoContent
  deleteWordByIdHandler wordId =
    liftIO
      $ withResource conns
      $ \conn -> withTransaction conn $ \transactionConn -> do
          _ <- deleteWordById user wordId transactionConn
          return NoContent

  putWordById :: Word -> WordId -> Handler Word
  putWordById userWord wordId =
    liftIO
      $ withResource conns
      $ \conn -> withTransaction conn $ \transactionConn -> do
          maybeWord <- updateWordById user wordId userWord transactionConn
          case maybeWord of
            Just returnUserWord -> return returnUserWord
            Nothing             -> fail "impossible to find the word"

  postWord :: Word -> Handler NoContent
  postWord newWord =
    liftIO
      $ withResource conns
      $ \conn -> withTransaction conn $ \transactionConn -> do
          _ <- insertWord user newWord transactionConn
          return NoContent

  retrieveKeywords :: Handler [String]
  retrieveKeywords = liftIO $ withResource conns $ \conn ->
    withTransaction conn
      $ \transactionConn -> getAllKeywords user transactionConn


-- | API for serving @swagger.json@.
-- type SwaggerAPI = "swagger.json" :> Get '[JSON] Swagger

-- | API for all objects
type CombinedAPI = "user" :> UserAPI
              :<|> "words" :> WordAPI

-- | Combined API of a Todo service with Swagger documentation.
type API = AuthProtect "jwt-auth" :> CombinedAPI
      :<|> "auth" :> AuthAPI
      :<|> SwaggerSchemaUI "swagger-ui" "swagger.json"

combinedServer :: User -> Pool Connection -> Server CombinedAPI
combinedServer user conns =
  userServer user conns :<|> wordServer user conns

apiServer :: Pool Connection -> Server API
apiServer conns =
  let authCombinedServer (user :: User) = combinedServer user conns
  in  authCombinedServer
      :<|> authServer conns
      :<|> swaggerSchemaUIServer apiSwagger

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
corsPolicy = CorsResourcePolicy
  { corsOrigins        = Nothing
  , corsMethods        = ["GET", "HEAD", "PUT", "POST", "DELETE"]
  , corsRequestHeaders = ["Authorization", "Content-Type"]
  , corsExposedHeaders = corsExposedHeaders simpleCorsResourcePolicy
  , corsMaxAge         = corsMaxAge simpleCorsResourcePolicy
  , corsVaryOrigin     = corsVaryOrigin simpleCorsResourcePolicy
  , corsRequireOrigin  = False
  , corsIgnoreFailures = corsIgnoreFailures simpleCorsResourcePolicy
  }

runApp :: Pool Connection -> IO ()
runApp conns =
  Network.Wai.Handler.Warp.run
    8080
    (logStdoutDev . cors (const $ Just corsPolicy) $ app conns)
