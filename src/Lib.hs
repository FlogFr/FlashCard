{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveDataTypeable         #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE TypeOperators              #-}

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
import GHC.Generics
import Servant
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
  { name :: String
  , age :: Int
  , email :: String
  } deriving (Eq, Show, Generic)

instance ToSchema Lib.User
instance ToJSON User

initConnectionPool :: DBConnectionString -> IO (Pool Connection)
initConnectionPool connStr =
  createPool (connectPostgreSQL connStr)
             disconnect
             2 -- stripes
             60 -- unused connection are kept open for a minute
             10 -- max. 10 connections open per stripe


type DBConnectionString = String

-- | API for the users
type UsersAPI = Get '[JSON] [User]

-- | API for the words
type WordAPI = Get '[JSON] [Lib.Word]
          :<|> ReqBody '[JSON] Lib.Word :> Post '[JSON] NoContent

-- | API for serving @swagger.json@.
type SwaggerAPI = "swagger.json" :> Get '[JSON] Swagger

-- | API for all objects
type CombinedAPI = "users" :> UsersAPI
              :<|> "words" :> WordAPI

-- | Combined API of a Todo service with Swagger documentation.
type API = CombinedAPI
      :<|> SwaggerSchemaUI "swagger-ui" "swagger.json"

users1 :: [User]
users1 =
  [ User "Isaac Newton"    372 "isaac@newton.co.uk"
  , User "Albert Einstein" 136 "ae@mc2.org"
  ]

wordConstructor :: (Int, String, String, String, Int) -> Lib.Word
wordConstructor (wordId, wordLanguage, wordWord, wordDefinition, wordDifficulty) =
  Lib.Word wordId wordLanguage wordWord [] wordDefinition wordDifficulty

pgRetrieveWords :: Connection -> IO [Lib.Word]
pgRetrieveWords conn = do
  listWords <- getWords conn
  return $ map wordConstructor listWords

usersServer :: Server UsersAPI
usersServer = return users1

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

combinedServer :: Pool Connection -> Server API
combinedServer conns = (usersServer :<|> (wordServer conns)) :<|> swaggerSchemaUIServer apiSwagger

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
app conns = serve api (combinedServer conns)

runApp :: Pool Connection -> IO ()
runApp conns = do
  Network.Wai.Handler.Warp.run 8080 (app conns)
