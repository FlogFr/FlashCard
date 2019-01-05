module Form where

import Protolude

import Servant.Multipart


-- | Lookup a textual input with the given @name@ attribute.
lookupInputs :: Text -> MultipartData tag -> Maybe [Text]
lookupInputs iname = Just . fmap iValue . filter ((==iname) . iName) . inputs


data UserLoginForm = UserLoginForm {
    userLoginFormEmail    :: Text
  , userLoginFormPassword :: Text
  } deriving (Show)
instance FromMultipart Mem UserLoginForm where
  fromMultipart multipartData =
    UserLoginForm <$> lookupInput "email" multipartData
                  <*> lookupInput "password" multipartData

data RegisterForm = RegisterForm {
    registerFormEmail    :: Text
  , registerFormPassword :: Text
  } deriving (Show)
instance FromMultipart Mem RegisterForm where
  fromMultipart multipartData =
    RegisterForm <$> lookupInput "email" multipartData
                 <*> lookupInput "password" multipartData

data UserUpdateForm = UserUpdateForm {
    userUpdateFormEmail       :: Text
  , userUpdateFormUsername    :: Text
  , userUpdateFormPassword    :: Text
  , userUpdateFormNewPassword :: Text
  } deriving (Show)
instance FromMultipart Mem UserUpdateForm where
  fromMultipart multipartData =
    UserUpdateForm <$> lookupInput "email"        multipartData
                   <*> lookupInput "username"     multipartData
                   <*> lookupInput "password"     multipartData
                   <*> lookupInput "new-password" multipartData

data FlashCardForm = FlashCardForm {
    flashCardFormId    :: Text
  , flashCardFormRecto :: Text
  , flashCardFormTags  :: [Text]
  , flashCardFormVerso :: Text
  } deriving (Show)
instance FromMultipart Mem FlashCardForm where
  fromMultipart multipartData =
    FlashCardForm <$> lookupInput  "id"    multipartData
                  <*> lookupInput  "recto" multipartData
                  <*> lookupInputs "tag"   multipartData
                  <*> lookupInput  "verso" multipartData

data SearchForm = SearchForm {
    searchFormText    :: Text
  } deriving (Show)
instance FromMultipart Mem SearchForm where
  fromMultipart multipartData =
    SearchForm <$> lookupInput  "search-text" multipartData

data QuizzForm = QuizzForm {
    quizzFormId    :: Text
  , quizzFormRecto :: Maybe Text
  , quizzFormVerso :: Maybe Text
  } deriving (Show)
instance FromMultipart Mem QuizzForm where
  fromMultipart multipartData =
    QuizzForm <$> lookupInput  "id"    multipartData
              <*> Just (lookupInput "recto" multipartData)
              <*> Just (lookupInput "verso" multipartData)
