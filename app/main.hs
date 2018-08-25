module Main (main) where

import API
import SQL
import Data.Yaml
import Config


main :: IO ()
main = do
  maybeConfig <- decodeFileEither "config.yml"
  case maybeConfig of
    Right config -> do
      pool <- initConnectionPool $ "service=" ++ pgservice config
      runApp pool
    Left _ -> fail "impossible to load the config.yml file"
