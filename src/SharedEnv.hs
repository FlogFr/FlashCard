module SharedEnv where

import Protolude

import qualified Data.Text                     as T
import qualified Control.Concurrent.STM.TMVar  as STMVar
import Data.HashMap.Strict as HM
import Database.PostgreSQL.LibPQ (Connection)
import Database (initConnectionPool)
import           Data.Pool                      ( Pool )
import Text.Mustache.Types
import           Data


data SharedEnv = SharedEnv
  { settings :: Settings
  , cache :: STMVar.TMVar (HashMap Text ByteString)
  , cacheTemplate :: STMVar.TMVar (HashMap FilePath Template)
  , dbConnectionPool :: Pool Connection
  } deriving (Generic)


initSharedEnv :: T.Text -> STMVar.TMVar (HashMap Text ByteString) -> STMVar.TMVar TemplateCache -> IO (SharedEnv)
initSharedEnv pathFileCfg tCache tCachetemplate = do
  settingsLoaded <- loadSettings pathFileCfg

  -- Setup the DB pools connection
  dbConnectionPool' <- initConnectionPool $ "service=" <> (pgservice settingsLoaded)

  return (SharedEnv settingsLoaded tCache tCachetemplate dbConnectionPool')
