{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators     #-}

module GenerateElmAPI where

import Prelude hiding (Word)
import API (CombinedAPI, userServer , UserAPI , pgRetrieveWords , WordAPI , wordServer)
import Word
import User
import Elm (Spec (Spec), specsToDir, toElmDecoderSource, toElmTypeSource)
import Servant.Elm (Proxy (Proxy), defElmImports, generateElmForAPI)

spec :: Spec
spec = Spec ["Generated", "MyAPI"]
            (defElmImports
             : toElmTypeSource    (Proxy :: Proxy Word)
             : toElmDecoderSource (Proxy :: Proxy Word)
             : generateElmForAPI  (Proxy :: Proxy CombinedAPI))

main :: IO ()
main = do
  specsToDir [spec] "my-elm-dir"
