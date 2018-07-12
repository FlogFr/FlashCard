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
{-# LANGUAGE TemplateHaskell            #-}

module Lib
    ( runApp
    , Lib.Word
    , initConnectionPool
    , WordAPI
    ) where

import Control.Lens
import Data.ByteString (ByteString)
import Data.Aeson
import Data.Aeson.TH
import Data.Aeson.Encode.Pretty (encodePretty)
import Data.Swagger
import Network.Wai
import Network.Wai.Handler.Warp
import Data.Pool
import Database.HDBC
import Database.HDBC.PostgreSQL
import Control.Monad.IO.Class
import Control.Exception (bracket)
import Database.YeshQL
import Queries (getWords, insertWord)
import qualified Data.ByteString.Lazy.Char8 as BL8
import Servant.API ((:<|>) ((:<|>)), (:>), BasicAuth, Get, JSON)
import Servant.API.BasicAuth (BasicAuthData (BasicAuthData))
import GHC.Generics
import Servant
import Servant.Server
import Servant.Swagger
import Servant.Swagger.UI


data Word = Word
  { wordId          :: Int
  , wordLanguage    :: String
  , wordWord        :: String
  , wordKeywords    :: [String]
  , wordDefinition  :: String
  , wordDifficulty  :: Int
  } deriving (Eq, Generic, Show)

instance ToSchema Lib.Word
instance ToJSON Lib.Word
instance FromJSON Lib.Word

data User = User
  { userId :: Int
  , userName :: String
  } deriving (Eq, Show, Generic)

instance ToSchema Lib.User
instance ToJSON User

userFlog :: User
userFlog = (User 1 "flog")

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
basicAuthServerContext :: Servant.Server.Context (BasicAuthCheck User ': '[])
basicAuthServerContext = authCheck :. EmptyContext

initConnectionPool :: DBConnectionString -> IO (Pool Connection)
initConnectionPool connStr =
  createPool (connectPostgreSQL connStr)
             disconnect
             2 -- stripes
             60 -- unused connection are kept open for a minute
             10 -- max. 10 connections open per stripe


type DBConnectionString = String

-- | API for the users
type UsersAPI = Get '[JSON] User

-- | API for the words
type WordAPI = Get '[JSON] [Lib.Word]
          :<|> ReqBody '[JSON] Lib.Word :> Post '[JSON] NoContent

-- | API for serving @swagger.json@.
type SwaggerAPI = "swagger.json" :> Get '[JSON] Swagger

-- | API for all objects
type CombinedAPI = "users" :> UsersAPI
              :<|> "words" :> WordAPI

-- | Combined API of a Todo service with Swagger documentation.
type API = BasicAuth "words-realm" User :> CombinedAPI
      :<|> SwaggerSchemaUI "swagger-ui" "swagger.json"

wordConstructor :: (Int, String, String, String, Int) -> Lib.Word
wordConstructor (wordId, wordLanguage, wordWord, wordDefinition, wordDifficulty) =
  Lib.Word wordId wordLanguage wordWord [] wordDefinition wordDifficulty

pgRetrieveWords :: Connection -> IO [Lib.Word]
pgRetrieveWords conn = do
  listWords <- getWords conn
  return $ map wordConstructor listWords

usersServer :: Server UsersAPI
usersServer = return userFlog

wordServer :: Pool Connection -> Server WordAPI
wordServer conns = retrieveWords
              :<|> postWord

  where retrieveWords :: Handler [Lib.Word]
        retrieveWords = do
          liftIO $ 
            withResource conns $ \conn -> do
              begin conn
              words <- pgRetrieveWords conn
              commit conn
              return words

        postWord :: Lib.Word -> Handler NoContent
        postWord word = do
          liftIO $
            withResource conns $ \conn -> do
              begin conn
              insertWord (wordLanguage word) (wordWord word) (wordDefinition word) conn
              commit conn
              return ()
          return NoContent

combinedServer :: Pool Connection -> Server CombinedAPI
combinedServer conns = (usersServer :<|> (wordServer conns))

apiServer :: Pool Connection -> Server API
apiServer conns =
  let authCombinedServer (user :: User) = (combinedServer conns)
  in  (authCombinedServer :<|> swaggerSchemaUIServer apiSwagger)

api :: Proxy API
api = Proxy

-- | Swagger spec for Todo API.
apiSwagger :: Swagger
apiSwagger = toSwagger (Proxy :: Proxy CombinedAPI)
  & info.title        .~ "OuiCook API"
  & info.version      .~ "1.0"
  & info.description  ?~ "OuiCook is 100% API driven"
  & info.license      ?~ "MIT"
  -- & host              ?~ "example.com"

app :: Pool Connection -> Application
app conns = serveWithContext api basicAuthServerContext (apiServer conns)

runApp :: Pool Connection -> IO ()
runApp conns = do
  Network.Wai.Handler.Warp.run 8080 (app conns)
