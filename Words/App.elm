module WordApp exposing (main)

import Browser
import Browser.Navigation
import Url
import Http
import Maybe
import Result
import Task exposing (..)
import Json.Decode as D
import Json.Encode as E
import Html as Html exposing (..)
import Html
import Route exposing (..)
import Views.Page as Page
import Page.Errored as Errored
import Page.Login as Login
import Page.Register as Register
import Page.ProfileEdit as ProfileEdit
import Page.Home as Home
import Page.WordEdit as WordEdit
import Page.WordDelete as WordDelete
import Page.Quizz as Quizz
import Page.NotFound as NotFound
import Data.Session exposing (..)
import Data.Message exposing (..)
import Ports
import API exposing (..)
import Debug


type Page
    = NotFound
    | Login Login.Model
    | Register Register.Model
    | ProfileEdit ProfileEdit.Model
    | Home Home.Model
    | WordEdit WordEdit.Model
    | WordDelete WordDelete.Model
    | Quizz Quizz.Model



-- MODEL --


type alias Model =
    { messages : List Message
    , session : Session
    , key : Browser.Navigation.Key
    , page : Page
    }


init : D.Value -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url argKey =
    let
        sessionValue =
            Result.withDefault (E.string "") (D.decodeValue (D.field "session" D.value) flags)
    in
        setRoute (fromUrl url)
            { messages = []
            , session = (retrieveSessionFromJson sessionValue)
            , key = argKey
            , page = NotFound
            }



-- VIEW --


view : Model -> Browser.Document Msg
view model =
    let
        frame =
            Page.frame model.session model.messages

        document htmlElement =
            Browser.Document "IziDict.com - My Dictionnary Online!" [ htmlElement ]
    in
        case model.page of
            Login subModel ->
                Login.view subModel
                    |> frame
                    |> Html.map LoginMsg
                    |> document

            Register subModel ->
                Register.view subModel
                    |> frame
                    |> Html.map RegisterMsg
                    |> document

            ProfileEdit subModel ->
                ProfileEdit.view subModel
                    |> frame
                    |> Html.map ProfileEditMsg
                    |> document

            Home subModel ->
                Home.view subModel model.session
                    |> frame
                    |> Html.map HomeMsg
                    |> document

            WordEdit subModel ->
                WordEdit.view subModel
                    |> frame
                    |> Html.map WordEditMsg
                    |> document

            WordDelete subModel ->
                WordDelete.view subModel
                    |> frame
                    |> Html.map WordDeleteMsg
                    |> document

            Quizz subModel ->
                Quizz.view subModel
                    |> frame
                    |> Html.map QuizzMsg
                    |> document

            NotFound ->
                NotFound.view
                    |> frame
                    |> document



-- SUBSCRIPTION --


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- UPDATE --


type Msg
    = SetRoute (Maybe Route)
    | ChangedUrl Url.Url
    | ClickedLink Browser.UrlRequest
    | LoginMsg Login.Msg
    | RegisterMsg Register.Msg
    | RegisterInit (Result Http.Error String)
    | ProfileEditMsg ProfileEdit.Msg
    | HomeInit (Result Errored.PageLoadError Home.InitModel)
    | HomeMsg Home.Msg
    | WordEditInitMsg (Result Http.Error Word)
    | WordEditMsg WordEdit.Msg
    | WordDeleteInitMsg (Result Http.Error NoContent)
    | WordDeleteMsg WordDelete.Msg
    | QuizzInit (Result Http.Error (List Word))
    | QuizzMsg Quizz.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updatePage (.page model) (Debug.log "msg: " msg) model


updatePage : Page -> Msg -> Model -> ( Model, Cmd Msg )
updatePage page msg model =
    case ( page, msg ) of
        ( _, ChangedUrl url ) ->
            setRoute (fromUrl url) model

        ( _, ClickedLink urlRequest ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Browser.Navigation.pushUrl model.key (Url.toString url)
                    )

                Browser.External url ->
                    case url of
                        "" ->
                            ( model, Cmd.none )

                        _ ->
                            ( model, Browser.Navigation.load url )

        ( _, SetRoute route ) ->
            setRoute route model

        ( Login subModel, LoginMsg subMsg ) ->
            let
                ( ( pageModel, pageMsg ), externalMsg ) =
                    Login.update subMsg model.key subModel

                newModel =
                    case externalMsg of
                        Login.NoOp ->
                            model

                        Login.SetSession newSession ->
                            { model | session = newSession }
            in
                ( { newModel | page = Login pageModel }
                , Cmd.map LoginMsg pageMsg
                )

        ( Register subModel, RegisterInit subMsg ) ->
            let
                ( ( pageModel, pageMsg ), externalMsg ) =
                    Register.update (Register.InitFinished subMsg) subModel
            in
                ( { model | page = Register pageModel }
                , Cmd.map RegisterMsg pageMsg
                )

        ( Register subModel, RegisterMsg subMsg ) ->
            let
                ( ( pageModel, pageMsg ), externalMsg ) =
                    Register.update subMsg subModel
            in
                case externalMsg of
                    Register.NoOp ->
                        ( { model | page = Register pageModel }
                        , Cmd.map RegisterMsg pageMsg
                        )

                    Register.GoLogin ->
                        ( { model | page = Login Login.initialModel }
                        , Cmd.none
                        )

        ( ProfileEdit subModel, ProfileEditMsg subMsg ) ->
            let
                ( ( pageModel, pageMsg ), externalMsg ) =
                    ProfileEdit.update model.session model.key subMsg subModel
            in
                case externalMsg of
                    ProfileEdit.NoOp ->
                        ( { model | page = ProfileEdit pageModel }
                        , Cmd.map ProfileEditMsg pageMsg
                        )

                    ProfileEdit.Logout ->
                        ( { model | session = (Session Nothing Nothing), messages = ((Message Warning "You got logged out") :: model.messages) }
                        , Cmd.batch [ deleteSession, Browser.Navigation.pushUrl model.key "/" ]
                        )

                    ProfileEdit.UpdateSession newSession ->
                        ( { model | session = newSession }
                        , Cmd.map ProfileEditMsg pageMsg
                        )

        ( Home subModel, HomeInit subMsg ) ->
            let
                ( ( pageModel, pageMsg ), externalMsg ) =
                    Home.update model.session (Home.InitFinished subMsg) subModel
            in
                case externalMsg of
                    Home.NoOp ->
                        ( { model | page = Home pageModel }
                        , Cmd.map HomeMsg pageMsg
                        )

                    Home.Logout ->
                        ( { model | session = (Session Nothing Nothing), messages = ((Message Warning "You got logged out") :: model.messages) }
                        , Cmd.batch [ deleteSession, Browser.Navigation.pushUrl model.key "/" ]
                        )

                    Home.ReloadPage ->
                        case model.session.user of
                            Nothing ->
                                ( { model | page = Home pageModel }
                                , Cmd.none
                                )

                            Just user ->
                                ( { model | page = Home pageModel }
                                , Task.attempt HomeInit (Home.init (.session model))
                                )

        ( Home subModel, HomeMsg subMsg ) ->
            let
                ( ( pageModel, pageMsg ), externalMsg ) =
                    Home.update model.session subMsg subModel
            in
                case externalMsg of
                    Home.NoOp ->
                        ( { model | page = Home pageModel }
                        , Cmd.map HomeMsg pageMsg
                        )

                    Home.Logout ->
                        ( { model | session = (Session Nothing Nothing), messages = ((Message Warning "You got logged out") :: model.messages) }
                        , Cmd.batch [ deleteSession, Browser.Navigation.pushUrl model.key "/" ]
                        )

                    Home.ReloadPage ->
                        case model.session.user of
                            Nothing ->
                                ( { model | page = Home pageModel }
                                , Cmd.none
                                )

                            Just user ->
                                ( { model | page = Home pageModel }
                                , Task.attempt HomeInit (Home.init (.session model))
                                )

        ( WordEdit subModel, WordEditInitMsg subMsg ) ->
            let
                ( ( pageModel, pageMsg ), externalMsg ) =
                    WordEdit.update model.session (WordEdit.WordEditInitFinished subMsg) subModel
            in
                case externalMsg of
                    WordEdit.NoOp ->
                        ( { model | page = WordEdit pageModel }
                        , Cmd.map WordEditMsg pageMsg
                        )

                    WordEdit.Logout ->
                        ( { model | session = (Session Nothing Nothing), messages = ((Message Warning "You got logged out") :: model.messages) }
                        , Cmd.batch [ deleteSession, Browser.Navigation.pushUrl model.key "/" ]
                        )

                    WordEdit.GoHome ->
                        ( model
                        , Browser.Navigation.pushUrl model.key
                            ("/"
                                ++ (Route.routeToString Route.Home)
                            )
                        )

        ( WordEdit subModel, WordEditMsg subMsg ) ->
            let
                ( ( pageModel, pageMsg ), externalMsg ) =
                    WordEdit.update model.session subMsg subModel
            in
                case externalMsg of
                    WordEdit.NoOp ->
                        ( { model | page = WordEdit pageModel }
                        , Cmd.map WordEditMsg pageMsg
                        )

                    WordEdit.Logout ->
                        ( { model | session = (Session Nothing Nothing), messages = ((Message Warning "You got logged out") :: model.messages) }
                        , Cmd.batch [ deleteSession, Browser.Navigation.pushUrl model.key "/" ]
                        )

                    WordEdit.GoHome ->
                        ( model
                        , Browser.Navigation.pushUrl model.key
                            ("/"
                                ++ (Route.routeToString Route.Home)
                            )
                        )

        ( WordDelete subModel, WordDeleteInitMsg subMsg ) ->
            let
                ( ( pageModel, pageMsg ), externalMsg ) =
                    WordDelete.update model.session (WordDelete.WordDeleteInitFinished subMsg) subModel
            in
                case externalMsg of
                    WordDelete.NoOp ->
                        ( { model | page = WordDelete pageModel }
                        , Cmd.map WordDeleteMsg pageMsg
                        )

                    WordDelete.Logout ->
                        ( { model | session = (Session Nothing Nothing), messages = ((Message Warning "You got logged out") :: model.messages) }
                        , Cmd.batch [ deleteSession, Browser.Navigation.pushUrl model.key "/" ]
                        )

                    WordDelete.GoHome ->
                        ( model
                        , Browser.Navigation.pushUrl model.key
                            ("/"
                                ++ (Route.routeToString Route.Home)
                            )
                        )

        ( Quizz subModel, QuizzInit subMsg ) ->
            let
                ( ( pageModel, pageMsg ), externalMsg ) =
                    Quizz.update model.session (Quizz.QuizzInitFinished subMsg) subModel
            in
                ( { model | page = Quizz pageModel }
                , Cmd.map QuizzMsg pageMsg
                )

        ( Quizz subModel, QuizzMsg subMsg ) ->
            let
                ( ( pageModel, pageMsg ), externalMsg ) =
                    Quizz.update model.session subMsg subModel
            in
                case externalMsg of
                    Quizz.NoOp ->
                        ( { model | page = Quizz pageModel }
                        , Cmd.map QuizzMsg pageMsg
                        )

        ( _, _ ) ->
            -- Disregard incoming messages that arrived for the wrong page
            ( model, Cmd.none )


setRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
setRoute maybeRoute model =
    case maybeRoute of
        Nothing ->
            ( { model | page = NotFound }
            , Cmd.none
            )

        Just (Route.Login) ->
            ( { model | page = Login Login.initialModel }
            , Cmd.none
            )

        Just (Route.Register) ->
            ( { model | page = Register Register.initialModel }
            , Task.attempt RegisterInit Register.init
            )

        Just (Route.ProfileEdit) ->
            let
                user =
                    case model.session.user of
                        Just sessionUser ->
                            sessionUser

                        Nothing ->
                            User 0 "" (Just "") []
            in
                ( { model | page = ProfileEdit (ProfileEdit.initialModel user) }
                , Cmd.none
                )

        Just (Route.Logout) ->
            ( { model | session = (Session Nothing Nothing) }
            , Cmd.batch [ deleteSession, Browser.Navigation.pushUrl model.key "/" ]
            )

        Just (Route.Home) ->
            let
                newModel =
                    { model | page = Home (Home.initialModel model.session) }
            in
                case model.session.user of
                    Nothing ->
                        ( newModel
                        , Cmd.none
                        )

                    Just user ->
                        ( newModel
                        , Task.attempt HomeInit (Home.init (.session model))
                        )

        Just (Route.WordEdit wordId) ->
            let
                newModel =
                    { model | page = WordEdit WordEdit.initialModel }
            in
                case model.session.user of
                    Nothing ->
                        ( newModel
                        , Cmd.none
                        )

                    Just user ->
                        ( newModel
                        , Task.attempt WordEditInitMsg (WordEdit.init (.session model) wordId)
                        )

        Just (Route.WordDelete wordId) ->
            let
                newModel =
                    { model | page = WordDelete (WordDelete.Model wordId) }
            in
                case model.session.user of
                    Nothing ->
                        ( newModel
                        , Cmd.none
                        )

                    Just user ->
                        ( newModel
                        , Task.attempt WordDeleteInitMsg (WordDelete.init (.session model) wordId)
                        )

        Just (Route.Quizz keywordQuizz) ->
            ( { model | page = (Quizz (Quizz.initialModel keywordQuizz)) }
            , Task.attempt QuizzInit (Quizz.init (.session model) keywordQuizz)
            )



-- MAIN --


main : Program D.Value Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = ClickedLink
        , onUrlChange = ChangedUrl
        }
