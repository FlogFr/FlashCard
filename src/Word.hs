{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE TypeOperators              #-}
{-# LANGUAGE TemplateHaskell            #-}

module Word
  ( Word
  , WordAPI
  , wordServer
  )
  where

import Prelude hiding (Word)
import Data.Pool
import Data.Aeson
import Data.Swagger
import GHC.Generics
import Control.Monad.IO.Class (liftIO)
import Servant.API ((:<|>) ((:<|>)), (:>), BasicAuth, Get, Post, ReqBody, JSON, NoContent(..))
import Servant.Elm (ElmType)
import Database.HDBC (commit)
import Database.HDBC.PostgreSQL (Connection, begin)
import Servant.Server (Server, Handler)
import Database.YeshQL (yeshFile)

[yeshFile|src/Queries.sql|]

type MaybeInt = Maybe Int
type MaybeString = Maybe [String]
type MaybeStringArr = Maybe [String]

data Word = Word
  { wordId          :: Int
  , wordLanguage    :: String
  , wordWord        :: String
  , wordKeywords    :: [String]
  , wordDefinition  :: String
  , wordDifficulty  :: Maybe Int
  } deriving (Eq, Generic, Show)


instance ToSchema Word
instance ToJSON Word
instance FromJSON Word
instance ElmType Word

wordConstructor :: (Int, String, String, String, Maybe Int) -> Word
wordConstructor (wordId, wordLanguage, wordWord, wordDefinition, wordDifficulty) =
  Word wordId wordLanguage wordWord [] wordDefinition wordDifficulty

pgRetrieveWords :: Connection -> IO [Word]
pgRetrieveWords conn = do
  listWords <- getWords conn
  return $ map wordConstructor listWords

-- | API for the words
type WordAPI = Get '[JSON] [Word]
          :<|> ReqBody '[JSON] Word :> Post '[JSON] NoContent

wordServer :: Pool Connection -> Server WordAPI
wordServer conns = retrieveWords
              :<|> postWord

  where retrieveWords :: Handler [Word]
        retrieveWords = do
          liftIO $ 
            withResource conns $ \conn -> do
              begin conn
              words <- pgRetrieveWords conn
              commit conn
              return words

        postWord :: Word -> Handler NoContent
        postWord word = do
          liftIO $
            withResource conns $ \conn -> do
              begin conn
              insertWord (wordLanguage word) (wordWord word) (wordDefinition word) conn
              commit conn
              return ()
          return NoContent
