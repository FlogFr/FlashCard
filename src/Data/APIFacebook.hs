module Data.APIFacebook where

import Protolude
import Data.Aeson


type FBAppID = Text
type FBAppToken = Text
type FBAppSecret = Text
type FBRedirectURI = Text


data FBUser = FBUser {
    first_name :: Text
  , last_name :: Text
  , email :: Text
  } deriving (Generic, Show)

instance FromJSON FBUser

data FBToken = FBToken {
    app_id :: Text
  , user_id :: Text
  } deriving (Generic, Show)


instance FromJSON FBToken where
  parseJSON (Object o) = FBToken <$> ((o .: "data") >>= (.: "app_id"))
                                 <*> ((o .: "data") >>= (.: "user_id"))
  parseJSON _ = mzero


data FBAccessToken = FBAccessToken {
    access_token :: Text
  , token_type :: Text
  , expires_in :: Integer
  } deriving (Generic, Show)


instance FromJSON FBAccessToken

data FBPermission = FBPermission {
    permission :: Text
  , status :: Text
  } deriving (Generic, Show)

instance FromJSON FBPermission where
  parseJSON (Object o) =
    FBPermission <$> (o .: "permission")
                 <*> (o .: "status")
  parseJSON _ = mzero

newtype FBPermissionList = FBPermissionList { fBPermissionList :: [FBPermission] }
  deriving (Show)

instance FromJSON FBPermissionList where
  parseJSON (Object o) = FBPermissionList <$> o .: "data"
  parseJSON _ = mzero
