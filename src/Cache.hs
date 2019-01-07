module Cache where

import Protolude

import Data.Text (pack)
import Control.Concurrent.STM.TMVar
import Data.HashMap.Strict
import SharedEnv
import Data.Settings
import HandlerM


readCacheOrFile :: FilePath -> HandlerM Text
readCacheOrFile filePath = do
  sharedEnv <- ask
  if production . settings $ sharedEnv
    then do
      let tCache = cache sharedEnv

      cache' <- liftIO $ atomically $ readTMVar tCache

      let cacheKey = "FILE-" <> pack filePath :: Text

      let mCacheValue = lookup cacheKey cache'

      case mCacheValue of
        -- if the key exists in the cache', return it
        Just cacheValue -> return $ decodeUtf8 cacheValue
        -- if the key doesnt exists, read the file,
        -- save it in the cache, and return the content
        Nothing -> do
          contentTxt <- liftIO $ readFile filePath
          let newCache = insert cacheKey (encodeUtf8 contentTxt) cache'
          _ <- liftIO $ atomically $ swapTMVar tCache newCache
          return $ contentTxt
    else liftIO $ readFile filePath
