module Main (main) where

import Protolude

import Control.Concurrent.STM
import Data.HashMap.Strict as HM
import SharedEnv
import Server

main :: IO ()
main = do
  -- Setup the STM variables
  newTCache <- atomically $ (newTMVar HM.empty)
  newTCacheTemplate <- atomically $ (newTMVar HM.empty)

  -- New shared environment
  sharedEnv <- initSharedEnv "config.yml" newTCache newTCacheTemplate

  withAsync ( startApp sharedEnv ) $ \asyncThreadApp -> do

    _ <- waitAny [asyncThreadApp]

    return ()
