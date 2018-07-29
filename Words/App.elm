module WordApp exposing (main)

import Navigation exposing (Location)
import Util exposing ((=>))
import Http
import Task exposing (..)
import Json.Decode as Decode exposing (Value)
import Html exposing (..)
import Route exposing (Route)
import Request exposing (..)
import Views.Page as Page
import Page.Login as Login
import Page.Home as Home
import Page.Quizz as Quizz
import Page.NotFound as NotFound
import Data.Session exposing (..)
import Request exposing (..)
import API exposing (..)
import Ports exposing (..)


type Page
    = NotFound
    | Login Login.Model
    | Home Home.Model
    | Quizz



-- MODEL --


type alias Model =
    { session : Session
    , page : Page
    }


init : Value -> Location -> ( Model, Cmd Msg )
init val location =
    setRoute (Route.fromLocation location)
        { session = { user = decodeAuthUserFromJson val }
        , page = NotFound
        }



-- VIEW --


view : Model -> Html Msg
view model =
    let
        frame =
            Page.frame model.session
    in
        case model.page of
            Login subModel ->
                Login.view subModel
                    |> frame
                    |> Html.map LoginMsg

            Home subModel ->
                Home.view subModel
                    |> frame
                    |> Html.map HomeMsg

            Quizz ->
                Quizz.view
                    |> frame
                    |> Html.map QuizzMsg

            NotFound ->
                NotFound.view
                    |> frame



-- SUBSCRIPTION --


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- UPDATE --


type Msg
    = SetRoute (Maybe Route)
    | LoginMsg Login.Msg
    | HomeInit (Result Http.Error (List Word))
    | HomeMsg Home.Msg
    | QuizzMsg Quizz.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updatePage (.page model) msg model


updatePage : Page -> Msg -> Model -> ( Model, Cmd Msg )
updatePage page msg model =
    case ( page, msg ) of
        ( _, SetRoute route ) ->
            setRoute route model

        ( Login subModel, LoginMsg subMsg ) ->
            let
                ( ( pageModel, pageMsg ), externalMsg ) =
                    Login.update subMsg subModel

                newModel =
                    case externalMsg of
                        Login.NoOp ->
                            model

                        Login.SetAuthUser authUser ->
                            { model | session = { user = Just authUser } }
            in
                { newModel | page = Login pageModel }
                    => Cmd.map LoginMsg pageMsg

        ( Home subModel, HomeInit subMsg ) ->
            let
                ( ( pageModel, pageMsg ), externalMsg ) =
                    Home.update model.session (Home.InitFinished subMsg) subModel
            in
                { model | page = Home pageModel }
                    => Cmd.map HomeMsg pageMsg

        ( Home subModel, HomeMsg subMsg ) ->
            let
                ( ( pageModel, pageMsg ), externalMsg ) =
                    Home.update model.session subMsg subModel
            in
                case externalMsg of
                    Home.NoOp ->
                        { model | page = Home pageModel }
                            => Cmd.map HomeMsg pageMsg

                    Home.ReloadPage ->
                        setRoute (Just Route.Home) model

        ( Quizz, _ ) ->
            ( model, Cmd.none )

        ( _, _ ) ->
            -- Disregard incoming messages that arrived for the wrong page
            model => Cmd.none


setRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
setRoute maybeRoute model =
    case maybeRoute of
        Nothing ->
            { model | page = NotFound } => Cmd.none

        Just (Route.Login) ->
            { model | page = Login Login.initialModel } => Cmd.none

        Just (Route.Home) ->
            let
                newModel =
                    { model | page = Home Home.initialModel }
            in
                case model.session.user of
                    Nothing ->
                        newModel => Cmd.none

                    Just user ->
                        newModel => Task.attempt HomeInit (Home.init user)

        Just (Route.Quizz) ->
            { model | page = Quizz } => Cmd.none



-- MAIN --


main : Program Value Model Msg
main =
    Navigation.programWithFlags (Route.fromLocation >> SetRoute)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
