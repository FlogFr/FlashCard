module Template where

import Protolude

import Data.HashMap.Strict
import Control.Concurrent.STM.TMVar
import Control.Exception
import Text.Mustache
import Text.Blaze.Html
import SharedEnv
import Data.Settings
import HandlerM

data LCException = TemplateParseException
  deriving (Show)

instance Exception LCException

compileTemplate' :: FilePath -> IO Template
compileTemplate' templateName = do
    let searchSpace = ["src/templates/", "emails/"]
    compiled <- automaticCompile searchSpace templateName
    case compiled of
      Left err -> do
        putStrLn $ ("TemplateParseException: " <> (show err) :: Text)
        throw TemplateParseException
      Right template -> return template


compileTemplate :: FilePath -> HandlerM Template
compileTemplate templateName = do
  sharedEnv <- ask
  case production . settings $ sharedEnv of
    True -> do
      let tCacheTemplate = cacheTemplate sharedEnv

      templateCache' <- liftIO $ atomically $ readTMVar tCacheTemplate

      let mCacheValue = lookup templateName templateCache'
      case mCacheValue of
        -- if the key exists in the templateCache', return it
        Just template -> return template
        -- if the template doesnt exists, load and compile the
        -- template with the partials, then save it into the
        -- cache
        Nothing -> do
          -- check the cache
          template <- liftIO $ compileTemplate' templateName
          let newCache = insert templateName template templateCache'
          _ <- liftIO $ atomically $ swapTMVar tCacheTemplate newCache
          return $ template
    False -> liftIO $ compileTemplate' templateName


-- substituteTemplate template context = substitute template (object ["ctx" ~= context])
substituteTemplate :: ToMustache ctx => Template -> ctx -> Text
substituteTemplate template context = substitute template context

preEscapedToMarkupSubstituteTemplate :: ToMustache ctx => Template -> ctx -> HandlerM Html
preEscapedToMarkupSubstituteTemplate template context = do
  return $ preEscapedToMarkup $ substitute template context
