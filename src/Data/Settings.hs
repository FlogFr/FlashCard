module Data.Settings where


import Protolude
import Control.Monad
import qualified Data.Text as T
import qualified Data.Yaml as Y
import Data.APIFacebook

data Settings = Settings
  { base_url :: T.Text
  , production :: Bool
  , app_port :: Int
  , pgservice :: T.Text
  , facebook_appid :: FBAppID
  , facebook_appsecret :: FBAppSecret
  , facebook_apptoken :: FBAppToken
  } deriving (Show, Generic, Eq)

instance Y.ToJSON Settings
instance Y.FromJSON Settings

loadSettings :: T.Text -> IO (Settings)
loadSettings pathFileCfg = do
  maybeSettings <- Y.decodeFileEither . T.unpack $ pathFileCfg
  case maybeSettings of
    Right config -> return config
    Left err -> fail ("impossible to load the config.yml file" ++ show err)
