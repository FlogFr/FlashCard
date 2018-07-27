module WordApp exposing (main)

import Navigation exposing (Location)
import Util exposing ((=>))
import Http
import Task exposing (..)
import Html exposing (..)
import Route exposing (Route)
import Request exposing (..)
import Views.Page as Page
import Page.Login as Login
import Page.Home as Home
import Page.Quizz as Quizz
import Page.NotFound as NotFound
import Data.Session exposing (Session)
import Request exposing (..)
import API exposing (..)


type Page
    = NotFound
    | Login Login.Model
    | Home Home.Model
    | Quizz



-- MODEL --


type alias Model =
    { session :
        Session
        -- , localStorage : LocalStorage msg
    , page : Page
    }


init : Location -> ( Model, Cmd Msg )
init location =
    setRoute (Route.fromLocation location)
        { session =
            { user = Nothing }
            -- , localStorage = make ports ""
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
    | HomeInit (Result Http.Error Home.Model)
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

                        Login.SetUser user ->
                            { model | session = { user = Just user } }
            in
                { newModel | page = Login pageModel }
                    => Cmd.map LoginMsg pageMsg

        ( Home subModel, HomeInit subMsg ) ->
            let
                ( ( pageModel, pageMsg ), externalMsg ) =
                    Home.update (Home.InitFinished subMsg) subModel
            in
                ( { model | page = Home pageModel }, Cmd.none )

        ( Home subModel, HomeMsg subMsg ) ->
            let
                ( ( pageModel, pageMsg ), externalMsg ) =
                    Home.update subMsg subModel
            in
                ( { model | page = Home pageModel }, Cmd.none )

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


main : Program Never Model Msg
main =
    Navigation.program (Route.fromLocation >> SetRoute)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
