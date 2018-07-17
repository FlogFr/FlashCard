{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE TypeOperators              #-}
{-# LANGUAGE TemplateHaskell            #-}

module API
  ( userServer
  , UserAPI
  , pgRetrieveWords
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
import PostgreSQL (getWords, insertWord)
import Word (Word(..), wordConstructor)
import User (User(..))


userServer :: User -> Server UserAPI
userServer user = return user

-- | API for the users
type UserAPI = Get '[JSON] User

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
