{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators     #-}

module Main (main) where

import Prelude hiding (Word)
import API (CombinedAPI, userServer , UserAPI , WordAPI , wordServer)
import Word
import User
import Elm (Spec (Spec), specsToDir, toElmDecoderSource, toElmEncoderSource, toElmTypeSource)
import Servant.API (NoContent(..))
import Servant.Elm (Proxy (Proxy), defElmImports, generateElmForAPI)

spec :: Spec
spec = Spec ["API"]
            (defElmImports
             : toElmTypeSource    (Proxy :: Proxy Word)
             : toElmEncoderSource (Proxy :: Proxy Word)
             : toElmDecoderSource (Proxy :: Proxy Word)
             : toElmTypeSource    (Proxy :: Proxy User)
             : toElmEncoderSource (Proxy :: Proxy User)
             : toElmDecoderSource (Proxy :: Proxy User)
             : toElmTypeSource    (Proxy :: Proxy NoContent)
             : generateElmForAPI  (Proxy :: Proxy CombinedAPI))

main :: IO ()
main = do
  specsToDir [spec] "."
