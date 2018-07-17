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
import Servant
import Servant.Server
import Servant.Swagger
import Servant.Swagger.UI

import Auth
import API ( userServer , UserAPI , pgRetrieveWords , WordAPI , wordServer)
import User
import Word

