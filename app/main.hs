module Main (main) where

import API
import SQL
import Data.Yaml
import Config
import System.Environment

main :: IO ()
main = do
  maybeConfig <- decodeFile "config.yml"
  case maybeConfig of
    Just config -> do
      pool <- initConnectionPool $ "service=" ++ (pgservice config)
      runApp pool
    Nothing -> fail "impossible to load the config.yml file"
