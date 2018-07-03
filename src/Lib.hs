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
    , wordAPI
    , WordAPI
    , writeSwaggerJSON
    ) where

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
$(deriveJSON defaultOptions ''Lib.Word)

initConnectionPool :: DBConnectionString -> IO (Pool Connection)
initConnectionPool connStr =
  createPool (connectPostgreSQL connStr)
             disconnect
             2 -- stripes
             60 -- unused connection are kept open for a minute
             10 -- max. 10 connections open per stripe


type DBConnectionString = String

wordAPI :: Proxy WordAPI
wordAPI = Proxy

-- | API for the words
type WordAPI = "words" :> Get '[JSON] [Lib.Word]
          :<|> "words" :> ReqBody '[JSON] Lib.Word :> Post '[JSON] NoContent

-- | API for serving @swagger.json@.
type SwaggerAPI = "swagger.json" :> Get '[JSON] Swagger

-- | Combined API of a Todo service with Swagger documentation.
type API = WordAPI :<|> SwaggerAPI

wordConstructor :: (Int, String, String, String, Int) -> Lib.Word
wordConstructor (wordId, wordLanguage, wordWord, wordDefinition, wordDifficulty) =
  Lib.Word wordId wordLanguage wordWord [] wordDefinition wordDifficulty

pgRetrieveWords :: Connection -> IO [Lib.Word]
pgRetrieveWords conn = do
  listWords <- getWords conn
  return $ map wordConstructor listWords

-- | Swagger spec for Todo API.
wordSwagger :: Swagger
wordSwagger = toSwagger wordAPI

-- | Output generated @swagger.json@ file for the @'TodoAPI'@.
writeSwaggerJSON :: IO ()
writeSwaggerJSON = BL8.writeFile "example/swagger.json" (encodePretty wordSwagger)

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


server :: Pool Connection -> Server WordAPI
server conns = wordServer conns

runApp :: Pool Connection -> IO ()
runApp conns = Network.Wai.Handler.Warp.run 8080 (serve wordAPI $ server conns)
