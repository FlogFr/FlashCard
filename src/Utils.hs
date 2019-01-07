module Utils where

import Protolude

import Data.Text (pack)
import System.Random
import Servant
import HandlerM
import SharedEnv
import Data


facebookUrlLogin :: HandlerM Text
facebookUrlLogin = do
  sharedEnv <- ask
  let facebookState = "CSRF1"
  let facebookRedirectUri = (base_url . settings $ sharedEnv ) <> "/login/facebook"
  let facebookClientId = facebook_appid . settings $ sharedEnv
  return $ "https://www.facebook.com/v3.2/dialog/oauth?response_type=code&client_id=" <> facebookClientId <> "&redirect_uri=" <> facebookRedirectUri <> "&state=" <> facebookState <> "&scope=public_profile,email"


loggedInOr302 :: Session -> HandlerM ()
loggedInOr302 AnonymousSession = do
  throwError $ err302 {
      errHeaders = [
          ("Location", encodeUtf8 "/")
      ]
    }
loggedInOr302 _ = return ()


generateRandomPassword :: IO Text
generateRandomPassword = do
  newPassword <- passwordString []
  return $ pack newPassword
  where passwordString :: [Char] -> IO [Char]
        passwordString fullPassword@[_,_,_,_,_,_,_,_] = return fullPassword
        passwordString currPassword = do
          newIntR <- getStdRandom (randomR (48, 122)) :: IO Int
          if (48 < newIntR && newIntR < 57) || (65 < newIntR && newIntR < 90) || (97 < newIntR && newIntR < 122)
            then passwordString (chr(newIntR):currPassword)
            else passwordString currPassword
