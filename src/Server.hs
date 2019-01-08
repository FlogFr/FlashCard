module Server where

import           Protolude
import           Control.Monad.Logger
import Network.HTTP.Media ((//))
import           Network.Wai
import           Network.Wai.Handler.Warp       ( run )
import           Network.Wai.Middleware.RequestLogger
                                                ( logStdoutDev )

import           Servant
import qualified Data.Vector                   as V
import qualified Data.ByteString.Base64 as BS64
import           Servant.Multipart
import Text.Read hiding (String)
import Data.Text (unpack)
import Data.Byteable
import Mustache
import Crypto.Hash
import Data.List ((!!))
import           HandlerM
import           SharedEnv
import           Text.Mustache.Types
import qualified Data.Aeson                    as A
import qualified Data.HashMap.Strict           as HM
import qualified Data.ByteString.Lazy          as BSL
import           Servant.HTML.Blaze
import           Text.Blaze.Html5              as H
                                                ( Html )
import           Data.Settings
import Database.PostgreSQL.LibPQ hiding (status)
import Database.Queries
import API.Facebook
import Template
import Utils
import Cache
import Data
import Css
import Form
import           Auth

data OctetStreamFavico

instance Accept OctetStreamFavico where
  contentType _ = "image" // "x-icon"

instance MimeRender OctetStreamFavico ByteString where
  mimeRender _ = BSL.fromStrict

type API = "static" :> Raw
      :<|> AuthProtect "custom-auth" :> FrontAPI

server :: ServerT API HandlerM
server =
  staticServer
  :<|> frontServer
  where
    staticServer = serveDirectoryFileServer "www"


type FrontAPI = Get '[HTML] H.Html
           :<|> "register" :> Get '[HTML] H.Html
           :<|> "register" :> MultipartForm Mem RegisterForm :> Post '[HTML] H.Html
           :<|> "logout" :> Post '[HTML] H.Html
           :<|> "login" :> Get '[HTML] H.Html
           :<|> "login" :> MultipartForm Mem UserLoginForm :> Post '[HTML] H.Html
           :<|> "login" :> "facebook" :> QueryParam "code" Text :> QueryParam "state" Text :> QueryParam "error" Text :> QueryParam "error_code" Integer :> QueryParam "error_description" Text :> Get '[HTML] H.Html
           :<|> "account" :> Get '[HTML] H.Html
           :<|> "account" :> MultipartForm Mem UserUpdateForm :> Post '[HTML] H.Html
           :<|> "dashboard" :> Get '[HTML] H.Html
           :<|> "dashboard" :> MultipartForm Mem SearchForm :> Post '[HTML] H.Html
           :<|> "flashcard" :> "add" :> Get '[HTML] H.Html
           :<|> "flashcard" :> "add" :> MultipartForm Mem FlashCardForm :> Post '[HTML] H.Html
           :<|> "flashcard" :> "edit" :> Capture "flashCardId" Integer :> Get '[HTML] H.Html
           :<|> "flashcard" :> "edit" :> Capture "flashCardId" Integer :> MultipartForm Mem FlashCardForm :> Post '[HTML] H.Html
           :<|> "flashcard" :> "delete" :> Capture "flashCardId" Integer :> Get '[HTML] H.Html
           :<|> "quizz" :> Get '[HTML] H.Html
           :<|> "quizz" :> "finish" :> Get '[HTML] H.Html
           :<|> "quizz" :> "answer" :> Capture "flashCardId" Integer :> Get '[HTML] H.Html
           :<|> "quizz" :> MultipartForm Mem QuizzForm :> Post '[HTML] H.Html
           :<|> "favicon.ico" :> Get '[OctetStreamFavico] ByteString
           :<|> "sitemap.xml" :> Get '[PlainText] Text
           :<|> "robots.txt" :> Get '[PlainText] Text



frontServer :: Session -> ServerT FrontAPI HandlerM
frontServer session =
  getHomePage
  :<|> getRegisterPage []
  :<|> postRegisterPage
  :<|> postLogoutPage
  :<|> getLoginPage []
  :<|> postLoginPage
  :<|> loginFacebookCallback
  :<|> getAccountPage []
  :<|> postAccountPage
  :<|> getDashboardPage [] Nothing
  :<|> postDashboardSearchPage
  :<|> getFlashCardAddPage []
  :<|> postFlashCardAddPage
  :<|> getFlashCardEditPage []
  :<|> postFlashCardEditPage
  :<|> getFlashCardDeletePage
  :<|> getQuizzPage []
  :<|> getQuizzFinishPage
  :<|> getQuizzAnswerPage []
  :<|> postQuizzPage
  :<|> faviconIco
  :<|> sitemapXml
  :<|> robotsTxt

  where
    getHomePage :: HandlerM H.Html
    getHomePage = do
      css <- izidictCSSText
      facebookUrlLogin' <- facebookUrlLogin 
      baseUrl' <- baseUrl
      let frontEndVariables = A.Object $ HM.fromList [
                                           ("session", A.toJSON session)
                                         ]

      let frontContext = Object $ HM.fromList [
                                             ("css", String $ css)
                                           , ("frontEndVariables", String . decodeUtf8 . BSL.toStrict . A.encode $ frontEndVariables)
                                           , ("facebookLoginUrl", String facebookUrlLogin')
                                           , ("base_url", String baseUrl')
                                         ]
      $(logInfo) ("homepage" ::Text)
      template <- compileTemplate "home.html"
      preEscapedToMarkupSubstituteTemplate template frontContext

    getRegisterPage :: [Message] -> HandlerM H.Html
    getRegisterPage messages = do
      css <- izidictCSSText
      facebookUrlLogin' <- facebookUrlLogin 
      baseUrl' <- baseUrl
      let frontEndVariables = A.Object $ HM.fromList [
                                           ("session", A.toJSON session)
                                         ]

      let frontContext = Object $ HM.fromList [
                                             ("css", String $ css)
                                           , ("frontEndVariables", String . decodeUtf8 . BSL.toStrict . A.encode $ frontEndVariables)
                                           , ("messages", Array . V.fromList $ map (toMustache . MessageMustache . description) messages)
                                           , ("facebookLoginUrl", String facebookUrlLogin')
                                           , ("base_url", String baseUrl')
                                         ]
      $(logInfo) ("homepage" ::Text)
      template <- compileTemplate "register.html"
      preEscapedToMarkupSubstituteTemplate template frontContext

    postRegisterPage :: RegisterForm -> HandlerM H.Html
    postRegisterPage form' = do
      eitherUserInserted <- runSqlFile
            "sql/registerUser.sql"
            [ Just (Oid 25, encodeUtf8 . registerFormEmail $ form', Binary)
            , Just (Oid 25, encodeUtf8 . registerFormPassword $ form', Binary)
            ] :: HandlerM (Either ExceptionPostgreSQL [User])

      case eitherUserInserted of
        Left pgErr -> do
          case pgErr of
            ExceptionPGUniqueViolation -> do
              $(logInfo) ("User already in database")
              getRegisterPage [(Message "User already registered")]
            _ -> do
              $(logInfo) ("Unknown PG Exception: " <> (show pgErr) :: Text)
              throwError $ err302 {
                errHeaders = [
                  ("Location", "/login")
                ]
              }
        Right userInserted' -> do
          -- Send a welcoming email if new user
          $(logInfo) ("log: " <> (show userInserted') :: Text)
          $(logInfo) ("Need to send a welcoming email to the user")
          $(logInfo) ("Inserting the 10 default general culture flashcard for this user")
          _ <- runSqlFile'
                 "sql/insertDefaultFlashCards.sql"
                 [ Just (Oid 25, show . userId $ (userInserted'!!0), Text)
                 ] :: HandlerM [Integer]
          throwError $ err302 {
            errHeaders = [
              ("Location", "/login")
            ]
          }

    postLogoutPage :: HandlerM H.Html
    postLogoutPage = do
      throwError $ err302 {
        errHeaders = [
          ("Location", "/")
            , ("Set-Cookie", "jwt=deleted; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT")
        ]
      }

    getLoginPage :: [Message] -> HandlerM H.Html
    getLoginPage messages = do
      css <- izidictCSSText
      baseUrl' <- baseUrl
      let frontEndVariables = A.Object $ HM.fromList [
                                           ("session", A.toJSON session)
                                         ]

      let frontContext = Object $ HM.fromList [
                                             ("css", String $ css)
                                           , ("messages", Array . V.fromList $ map (toMustache . MessageMustache . description) messages)
                                           , ("frontEndVariables", String . decodeUtf8 . BSL.toStrict . A.encode $ frontEndVariables)
                                           , ("base_url", String baseUrl')
                                         ]
      template <- compileTemplate "login.html"
      preEscapedToMarkupSubstituteTemplate template frontContext

    postLoginPage :: UserLoginForm -> HandlerM H.Html
    postLoginPage form = do
      jwtSecrets <- runSqlFile'
                      "sql/getNewRandomSession.sql"
                      [ Just (Oid 25, encodeUtf8 . userLoginFormEmail $ form, Text)
                      , Just (Oid 25, encodeUtf8 . userLoginFormPassword $ form, Text)
                      ] :: HandlerM [Text]

      if length jwtSecrets > 0
        then do
          let jwtHeader = BS64.encode $ "{\"alg\": \"HS256\", \"typ\": \"JWT\"}"
          let jwtPayload = BS64.encode $ "{\"email\": \"" <> (encodeUtf8 . userLoginFormEmail $ form) <> "\"}"
          let jwtSignature = BS64.encode $ toBytes $ hmacAlg SHA256 (encodeUtf8 $ jwtSecrets!!0) (jwtHeader <> "." <> jwtPayload)

          let jwt = jwtHeader <> "." <> jwtPayload <> "." <> jwtSignature

          throwError $ err302 {
            errHeaders = [
                ("Location", "/dashboard")
              , ("Set-Cookie", "jwt=" <> jwt <> "; path=/; expires=Thu, 01 Jan 2200 00:00:00 GMT")
            ]
          }
        else getLoginPage [Message "Wrong credentials"]

    getAccountPage :: [Message] -> HandlerM H.Html
    getAccountPage messages = do
      loggedInOr302 session
      css <- izidictCSSText
      baseUrl' <- baseUrl
      let frontEndVariables = A.Object $ HM.fromList [
                                           ("session", A.toJSON session)
                                         ]

      let frontContext = Object $ HM.fromList [
                                             ("css", String $ css)
                                           , ("account", (toMustache . UserMustache . sessionUser $ session))
                                           , ("messages", Array . V.fromList $ map (toMustache . MessageMustache . description) messages)
                                           , ("frontEndVariables", String . decodeUtf8 . BSL.toStrict . A.encode $ frontEndVariables)
                                           , ("base_url", String baseUrl')
                                         ]
      template <- compileTemplate "account.html"
      preEscapedToMarkupSubstituteTemplate template frontContext

    postAccountPage :: UserUpdateForm -> HandlerM H.Html
    postAccountPage form' = do
      loggedInOr302 session
      $(logInfo) ("log: " <> (show form') :: Text)
      -- check password
      passwordChecked <- runSqlFile'
                        "sql/checkPassword.sql"
                        [ Just (Oid 25, show . userEmail . sessionUser $ session, Text) -- User Email
                        , Just (Oid 25, encodeUtf8 . userUpdateFormPassword $ form', Text) -- Password
                        ] :: HandlerM [Integer]
      _ <- if length passwordChecked > 1
            then return mempty
            else getAccountPage [(Message "Wrong credentials")]

      -- update password
      _ <- runSqlFile'
              "sql/updatePassword.sql"
              [ Just (Oid 25, encodeUtf8 . userEmail . sessionUser $ session, Text) -- User Email
              , Just (Oid 25, encodeUtf8 . userUpdateFormNewPassword $ form', Text) -- Password
              ] :: HandlerM [Integer]

      throwError $ err302 {
        errHeaders = [
            ("Location", "/account")
        ]
      }

    getDashboardPage :: [Message] -> Maybe Text -> HandlerM H.Html
    getDashboardPage messages mSearchText = do
      loggedInOr302 session
      flashcards <- case mSearchText of
                      Just searchText -> runSqlFile'
                                  "sql/searchFlashCards.sql"
                                  [ Just (Oid 25, show . userId . sessionUser $ session, Text) -- User ID
                                  , Just (Oid 25, encodeUtf8 searchText, Text)
                                  ] :: HandlerM [FlashCard]
                      Nothing -> runSqlFile'
                                  "sql/getFlashCards.sql"
                                  [ Just (Oid 25, show . userId . sessionUser $ session, Text) -- User ID
                                  ] :: HandlerM [FlashCard]
      css <- izidictCSSText
      baseUrl' <- baseUrl
      let frontEndVariables = A.Object $ HM.fromList [
                                           ("session", A.toJSON session)
                                         ]

      let frontContext = Object $ HM.fromList [
                             ("flashcards", Array . V.fromList $ map (toMustache . FlashCardMustache) flashcards)
                           , ("css", String $ css)
                           , ("messages", Array . V.fromList $ map (toMustache . MessageMustache . description) messages)
                           , ("frontEndVariables", String . decodeUtf8 . BSL.toStrict . A.encode $ frontEndVariables)
                           , ("base_url", String baseUrl')
                         ]
      template <- compileTemplate "dashboard.html"
      preEscapedToMarkupSubstituteTemplate template frontContext

    postDashboardSearchPage :: SearchForm -> HandlerM H.Html
    postDashboardSearchPage form' = do
      getDashboardPage [] (Just $ searchFormText form')

    getFlashCardAddPage :: [Message] -> HandlerM H.Html
    getFlashCardAddPage messages = do
      loggedInOr302 session
      css <- izidictCSSText
      baseUrl' <- baseUrl
      let frontEndVariables = A.Object $ HM.fromList [
                                           ("session", A.toJSON session)
                                         ]

      let frontContext = Object $ HM.fromList [
                                             ("css", String $ css)
                                           , ("messages", Array . V.fromList $ map (toMustache . MessageMustache . description) messages)
                                           , ("frontEndVariables", String . decodeUtf8 . BSL.toStrict . A.encode $ frontEndVariables)
                                           , ("base_url", String baseUrl')
                                         ]
      template <- compileTemplate "flashcard.add.html"
      preEscapedToMarkupSubstituteTemplate template frontContext

    postFlashCardAddPage :: FlashCardForm -> HandlerM H.Html
    postFlashCardAddPage form' = do
      loggedInOr302 session
      _ <- runSqlFile'
              "sql/addFlashCard.sql"
              [ Just (Oid 25, show . userId . sessionUser $ session, Text) -- User Id
              , Just (Oid 25, encodeUtf8 . flashCardFormRecto $ form', Text)
              , Just (Oid 25, encodeUtf8 $ "{" <> (mconcat . intersperse "," $ flashCardFormTags form') <> "}", Text)
              , Just (Oid 25, encodeUtf8 . flashCardFormVerso $ form', Text)
              ] :: HandlerM [Integer]
      throwError $ err302 {
        errHeaders = [
            ("Location", "/dashboard")
        ]
      }

    getFlashCardEditPage :: [Message] -> Integer -> HandlerM H.Html
    getFlashCardEditPage messages flashCardId' = do
      loggedInOr302 session
      css <- izidictCSSText
      baseUrl' <- baseUrl
      flashcards <- runSqlFile'
                      "sql/getFlashCard.sql"
                      [ Just (Oid 25, show . userId . sessionUser $ session, Text) -- User ID
                      , Just (Oid 25, show flashCardId', Text) -- FlashCard ID
                      ] :: HandlerM [FlashCard]
      $(logInfo) ("log: " <> (show flashcards) :: Text)
      if length flashcards < 1
        then
          throwError $ err302 {
            errHeaders = [
                ("Location", "/")
            ]
          }
        else return ()
      let frontEndVariables = A.Object $ HM.fromList [
                                           ("session", A.toJSON session)
                                         ]

      let frontContext = Object $ HM.fromList [
                             ("css", String $ css)
                           , ("flashcard", (toMustache . FlashCardMustache) (flashcards!!0))
                           , ("messages", Array . V.fromList $ map (toMustache . MessageMustache . description) messages)
                           , ("frontEndVariables", String . decodeUtf8 . BSL.toStrict . A.encode $ frontEndVariables)
                           , ("base_url", String baseUrl')
                           ]
      template <- compileTemplate "flashcard.edit.html"
      preEscapedToMarkupSubstituteTemplate template frontContext

    postFlashCardEditPage :: Integer -> FlashCardForm -> HandlerM H.Html
    postFlashCardEditPage flashCardId' form' = do
      _ <- runSqlFile'
              "sql/updateFlashCard.sql"
              [ Just (Oid 25, show . userId . sessionUser $ session, Text) -- User Id
              , Just (Oid 25, show flashCardId', Text) -- Word Id
              , Just (Oid 25, encodeUtf8 . flashCardFormRecto $ form', Text)
              , Just (Oid 25, encodeUtf8 $ "{" <> (mconcat . intersperse "," $ flashCardFormTags form') <> "}", Text)
              , Just (Oid 25, encodeUtf8 . flashCardFormVerso $ form', Text)
              ] :: HandlerM [Integer]
      throwError $ err302 {
        errHeaders = [
            ("Location", "/dashboard")
        ]
      }

    getFlashCardDeletePage :: Integer -> HandlerM H.Html
    getFlashCardDeletePage flashCardId' = do
      loggedInOr302 session
      _ <- runSqlFile'
              "sql/deleteFlashCard.sql"
              [ Just (Oid 25, show . userId . sessionUser $ session, Text) -- User Id
              , Just (Oid 25, show flashCardId', Text) -- Word Id
              ] :: HandlerM [Integer]
      throwError $ err302 {
        errHeaders = [
            ("Location", "/dashboard")
        ]
      }

    getQuizzPage :: [Message] -> HandlerM H.Html
    getQuizzPage messages = do
      loggedInOr302 session
      css <- izidictCSSText
      baseUrl' <- baseUrl
      flashcards <- runSqlFile'
            "sql/getQuizzFlashCard.sql"
            [ Just (Oid 25, show . userId . sessionUser $ session, Text) -- User Id
            ] :: HandlerM [FlashCard]

      if length flashcards < 1
        then throwError $ err302 {errHeaders = [("Location", "/quizz/finish")]}
        else return ()

      let frontEndVariables = A.Object $ HM.fromList [
                                           ("session", A.toJSON session)
                                         ]

      let frontContext = Object $ HM.fromList [
                                             ("css", String $ css)
                                           , ("flashcard", (toMustache . FlashCardMustache) (flashcards!!0))
                                           , ("messages", Array . V.fromList $ map (toMustache . MessageMustache . description) messages)
                                           , ("frontEndVariables", String . decodeUtf8 . BSL.toStrict . A.encode $ frontEndVariables)
                                           , ("base_url", String baseUrl')
                                         ]
      template <- compileTemplate "quizz.html"
      preEscapedToMarkupSubstituteTemplate template frontContext

    getQuizzFinishPage :: HandlerM H.Html
    getQuizzFinishPage = do
      loggedInOr302 session
      css <- izidictCSSText
      baseUrl' <- baseUrl
      let frontEndVariables = A.Object $ HM.fromList [
                                           ("session", A.toJSON session)
                                         ]
      let frontContext = Object $ HM.fromList [
                                             ("css", String $ css)
                                           , ("frontEndVariables", String . decodeUtf8 . BSL.toStrict . A.encode $ frontEndVariables)
                                           , ("base_url", String baseUrl')
                                         ]
      template <- compileTemplate "quizz.finish.html"
      preEscapedToMarkupSubstituteTemplate template frontContext

    getQuizzAnswerPage :: [Message] -> Integer -> HandlerM H.Html
    getQuizzAnswerPage messages flashCardId' = do
      loggedInOr302 session
      flashcards <- runSqlFile'
                      "sql/getFlashCard.sql"
                      [ Just (Oid 25, show . userId . sessionUser $ session, Text) -- User ID
                      , Just (Oid 25, show flashCardId', Text) -- FlashCard ID
                      ] :: HandlerM [FlashCard]

      css <- izidictCSSText
      baseUrl' <- baseUrl
      let frontEndVariables = A.Object $ HM.fromList [
                                           ("session", A.toJSON session)
                                         ]

      let frontContext = Object $ HM.fromList [
                                             ("css", String $ css)
                                           , ("flashcard", (toMustache . FlashCardMustache) (flashcards!!0))
                                           , ("messages", Array . V.fromList $ map (toMustache . MessageMustache . description) messages)
                                           , ("frontEndVariables", String . decodeUtf8 . BSL.toStrict . A.encode $ frontEndVariables)
                                           , ("base_url", String baseUrl')
                                         ]

      template <- compileTemplate "quizz.answer.html"
      preEscapedToMarkupSubstituteTemplate template frontContext

    postQuizzPage :: QuizzForm -> HandlerM H.Html
    postQuizzPage form' = do
      -- verify the word
      flashCardVerified <- runSqlFile'
                      "sql/verifyFlashCardAnswer.sql"
                      [ Just (Oid 25, show . userId . sessionUser $ session, Text) -- User Id
                      , Just (Oid 25, encodeUtf8 . quizzFormId $ form', Text) -- FlashCard Id
                      , Just (Oid 25, encodeUtf8 ((fromMaybe "" $ quizzFormRecto form') <> (fromMaybe "" $ quizzFormVerso form')), Text) -- Answer
                      ] :: HandlerM [Bool]
      _ <- if (flashCardVerified!!0)
            then do
              runSqlFile'
                "sql/increaseBucketFlashCard.sql"
                [ Just (Oid 25, show . userId . sessionUser $ session, Text) -- User Id
                , Just (Oid 25, encodeUtf8 . quizzFormId $ form', Text) -- FlashCard Id
                ] :: HandlerM [Integer]
            else do
              runSqlFile'
                "sql/decreaseBucketFlashCard.sql"
                [ Just (Oid 25, show . userId . sessionUser $ session, Text) -- User Id
                , Just (Oid 25, encodeUtf8 . quizzFormId $ form', Text) -- FlashCard Id
                ] :: HandlerM [Integer]

      getQuizzAnswerPage [(Message (if (flashCardVerified!!0) then "Right answer :)" else "Wrong answer :("))] (read . unpack . quizzFormId $ form' :: Integer)

    faviconIco :: HandlerM ByteString
    faviconIco = do
      fileBS <- readCacheOrFileBS "www/favicon.ico"
      return $ fileBS

    sitemapXml :: HandlerM Text 
    sitemapXml = do
      baseUrl' <- baseUrl
      let frontContext = Object $ HM.fromList [
                                             ("base_url", String baseUrl')
                                         ]

      template <- compileTemplate "sitemap.xml"
      return $ substituteTemplate template frontContext

    robotsTxt :: HandlerM Text
    robotsTxt = do
      baseUrl' <- baseUrl
      let frontContext = Object $ HM.fromList [
                                             ("base_url", String baseUrl')
                                         ]

      template <- compileTemplate "robots.txt"
      return $ substituteTemplate template frontContext


    loginFacebookCallback :: Maybe Text -> Maybe Text -> Maybe Text -> Maybe Integer -> Maybe Text -> HandlerM H.Html
    loginFacebookCallback mCode _ _ _ _ = do
      code <- case mCode of
        Nothing -> do
          $(logInfo) "didnt receive the code & state"
          throwError $ err302 {errHeaders = [("Location", "/")]}
        Just code' -> return code'

      sharedEnv <- ask
      let facebookAppId = facebook_appid . settings $ sharedEnv
      let facebookRedirectUri = (base_url . settings $ sharedEnv) <> "/login/facebook"
      let facebookAppSecret = facebook_appsecret . settings $ sharedEnv
      let facebookAppToken = facebook_apptoken . settings $ sharedEnv

      fbAccessToken <- getFacebookAccessToken facebookAppId facebookAppSecret facebookRedirectUri code

      fbToken <- getFacebookToken facebookAppToken fbAccessToken

      let userId' = user_id fbToken

      fbPermissions <- getFacebookPermissionList facebookAppToken userId'

      let nbDeclinedPermissions = length $ filter (\p -> (status p) == "declined") (fBPermissionList fbPermissions)

      if nbDeclinedPermissions > 0
        then do
          $(logInfo) ("Some Facebook permission were rejected, need to re-ask" :: Text)
          let facebookClientId = facebook_appid . settings $ sharedEnv
          throwError $ err302 {errHeaders = [("Location", encodeUtf8 $ "https://www.facebook.com/v3.2/dialog/oauth?client_id=" <> facebookClientId <> "&redirect_uri=" <> facebookRedirectUri <> "&auth_type=rerequest&scope=public_profile,email")]}
        else return ()

      -- Retrieving email address + personnal information
      fbUser <- getFacebookUser fbAccessToken userId'
      randomPassword <- liftIO $ generateRandomPassword

      -- Create a new account
      eitherNBUserInserted <- runSqlFile
            "sql/insertUser.sql"
            [ Just (Oid 25, encodeUtf8 . first_name $ fbUser, Text)
            , Just (Oid 25, encodeUtf8 . last_name $ fbUser, Binary)
            , Just (Oid 25, encodeUtf8 . email $ fbUser, Binary)
            , Just (Oid 25, encodeUtf8 randomPassword, Binary)]
            :: HandlerM (Either ExceptionPostgreSQL [User])

      $(logInfo) ("either nb user inserted: " <> (show eitherNBUserInserted) :: Text)

      case eitherNBUserInserted of
        Right userInserted' -> do
          let userInserted = userInserted'!!0
          -- Send a welcoming email if new user
          $(logInfo) ("Need to send a welcoming email to the user " <> (show userInserted) :: Text)
          -- Insert the default FlashCards
          _ <- runSqlFile'
                 "sql/insertDefaultFlashCards.sql"
                 [ Just (Oid 25, show . userId $ userInserted, Text)
                 ] :: HandlerM [Integer]
          return ()
        Left pgErr -> do
          case pgErr of
            ExceptionPGUniqueViolation -> $(logInfo) ("User already in database")
            _ -> $(logInfo) ("Unknown PG Exception: " <> (show pgErr) :: Text)

      jwtSecrets <- runSqlFile'
                      "sql/getNewRandomSessionWithoutPasswordCheck.sql"
                      [ Just (Oid 25, encodeUtf8 . email $ fbUser, Text)
                      ] :: HandlerM [Text]

      let jwtHeader = BS64.encode $ "{\"alg\": \"HS256\", \"typ\": \"JWT\"}"
      let jwtPayload = BS64.encode $ "{\"email\": \"" <> (encodeUtf8 . email $ fbUser) <> "\"}"

      let jwtSignature = BS64.encode $ toBytes $ hmacAlg SHA256 (encodeUtf8 $ jwtSecrets!!0) (jwtHeader <> "." <> jwtPayload)

      let jwt = jwtHeader <> "." <> jwtPayload <> "." <> jwtSignature

      throwError $ err302 {
        errHeaders = [
            ("Location", "/dashboard")
          , ("Set-Cookie", "jwt=" <> jwt <> "; path=/; expires=Thu, 01 Jan 2200 00:00:00 GMT")
        ]
      }


startApp :: SharedEnv -> IO ()
startApp sharedEnv =
  run (app_port . settings $ sharedEnv) (logStdoutDev (app sharedEnv) )

app :: SharedEnv -> Application
-- serveWithContext :: (HasServer api context) => Proxy api -> Context context -> Server api -> Application
-- hoistServer :: HasServer api '[] => Proxy api -> (forall x. m x -> n x) -> ServerT api m -> ServerT api n 
-- hoistServerWithContext :: HasServer api context => Proxy api -> Proxy context -> (forall x . m x -> n x) -> ServerT api m -> ServerT api n
app c = serveWithContext api (authServerContext (dbConnectionPool c)) $ hoistServerWithContext api contextProxy (nt c) server

api :: Proxy API
api = Proxy
