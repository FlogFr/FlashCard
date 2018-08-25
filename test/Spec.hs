{-# LANGUAGE QuasiQuotes, OverloadedStrings #-}
module Main (main) where

import API (runApp, app)
import User
import SQL
import Test.Hspec
import Test.Hspec.Wai
import Test.Hspec.Wai.JSON
import Test.QuickCheck


genUser :: Gen User
genUser = elements [
    User (-1) "testuser1" (Just "testemail1") ["EN", "FR"]
  , User (-2) "testuser2" (Just "testemail2") ["DE", "FR"]
  , User (-3) "testuser3" (Nothing) ["EN", "DE"]
  , User (-4) "testuser4" (Just "testemail4") ["PL"]
  ]

-- with :: IO a -> SpecWith a -> Spec
main :: IO ()
main = hspec spec

spec :: Spec
spec = with webApp $ do
    describe "GET /auth/token" $ do
      it "responds with 200" $
        get "/auth/token" `shouldRespondWith` 302
  where webApp = do
          pool <- initConnectionPool "service=words"
          return $ app pool
