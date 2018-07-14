{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE ScopedTypeVariables        #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE TypeOperators              #-}
{-# LANGUAGE UndecidableInstances       #-}
{-# LANGUAGE DeriveDataTypeable         #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Lib
    ( runApp
    , CombinedAPI
    ) where

import Control.Lens
import Data.ByteString (ByteString)
import Data.Aeson.Encode.Pretty (encodePretty)
import Data.Swagger
import Network.Wai
import Network.Wai.Handler.Warp
import Data.Pool
import Database.HDBC.PostgreSQL (Connection)
import Control.Monad.IO.Class
import Control.Exception (bracket)
import qualified Data.ByteString.Lazy.Char8 as BL8
import Servant.API ((:<|>) ((:<|>)), (:>), BasicAuth, Get, JSON)
import Servant.API.BasicAuth (BasicAuthData (BasicAuthData))
import Servant
import Servant.Server
import Servant.Swagger
import Servant.Swagger.UI

import Auth
import User
import Word

-- | API for serving @swagger.json@.
type SwaggerAPI = "swagger.json" :> Get '[JSON] Swagger

-- | API for all objects
type CombinedAPI = "users" :> UserAPI
              :<|> "words" :> WordAPI

-- | Combined API of a Todo service with Swagger documentation.
type API = BasicAuth "words-realm" User :> CombinedAPI
      :<|> SwaggerSchemaUI "swagger-ui" "swagger.json"

combinedServer :: Pool Connection -> Server CombinedAPI
combinedServer conns = (userServer :<|> (wordServer conns))

apiServer :: Pool Connection -> Server API
apiServer conns =
  let authCombinedServer (user :: User) = (combinedServer conns)
  in  (authCombinedServer :<|> swaggerSchemaUIServer apiSwagger)

api :: Proxy API
api = Proxy

-- | Swagger spec for Todo API.
apiSwagger :: Swagger
apiSwagger = toSwagger (Proxy :: Proxy CombinedAPI)
  & info.title        .~ "OuiCook API"
  & info.version      .~ "1.0"
  & info.description  ?~ "OuiCook is 100% API driven"
  & info.license      ?~ "MIT"

app :: Pool Connection -> Application
app conns = serveWithContext api basicAuthServerContext (apiServer conns)

runApp :: Pool Connection -> IO ()
runApp conns = do
  Network.Wai.Handler.Warp.run 8080 (app conns)
