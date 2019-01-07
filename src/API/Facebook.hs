module API.Facebook where

import Protolude

import Control.Monad.Logger
import Control.Exception
import Data.Aeson
import Network.HTTP.Conduit

import Data.Text (unpack)
import HandlerM
import Data.Exception
import Data.APIFacebook


getFacebookAccessToken :: FBAppID -> FBAppSecret -> FBRedirectURI -> Text -> HandlerM FBAccessToken
getFacebookAccessToken fbAppId fbAppSecret fbRedirectURI code = do
  returnBS <- simpleHttp . unpack $ ("https://graph.facebook.com/v3.2/oauth/access_token?client_id=" <> fbAppId <> "&redirect_uri=" <> fbRedirectURI <> "&client_secret=" <> fbAppSecret <> "&code=" <> code :: Text)

  let mfbAccessToken = decode returnBS :: Maybe FBAccessToken
  case mfbAccessToken of
    Just fbAccessToken -> return fbAccessToken
    Nothing -> throw $ ExceptionText "Cant decode the FB Access Token"


getFacebookToken :: FBAppToken -> FBAccessToken -> HandlerM FBToken
getFacebookToken fbAppToken fbAccessToken = do
  -- GET graph.facebook.com/debug_token?
  --      input_token={token-to-inspect}
  --      &access_token={app-token-or-admin-token}
  returnBS <- simpleHttp . unpack $ ("https://graph.facebook.com/debug_token?input_token=" <> access_token fbAccessToken <> "&access_token=" <> fbAppToken :: Text)
  $(logInfo) ("result: " <> show returnBS :: Text)

  let mfbToken = decode returnBS :: Maybe FBToken
  case mfbToken of
    Just fbToken -> return fbToken
    Nothing -> throw $ ExceptionText "Cant decode the FB Token"

getFacebookPermissionList :: FBAppToken -> Text -> HandlerM FBPermissionList
getFacebookPermissionList fbAppToken userId = do
  -- yes, userId is a Text in Facebook DB…
  returnBS <- simpleHttp . unpack $ ("https://graph.facebook.com/v3.2/" <> userId <> "/permissions?access_token=" <> fbAppToken :: Text)

  let mFBPermissions = decode returnBS :: Maybe FBPermissionList

  case mFBPermissions of
    Just fbPermissions -> return fbPermissions
    Nothing -> throw $ ExceptionText "Cant decode the FB Permission List"

getFacebookUser :: FBAccessToken -> Text -> HandlerM FBUser
getFacebookUser fbAppToken userId = do
  returnBS <- simpleHttp . unpack $ ("https://graph.facebook.com/v3.2/" <> userId <> "?access_token=" <> access_token fbAppToken <> "&fields=first_name,last_name,email" :: Text)

  let mFBUser = decode returnBS :: Maybe FBUser

  case mFBUser of
    Just fbUser -> return fbUser
    Nothing -> throw $ ExceptionText "Cant decode the FB User information"
