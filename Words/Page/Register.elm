module Page.Register exposing (ExternalMsg(..), Model, Msg(..), init, initialModel, view, update)

import Util exposing ((=>))
import API exposing (..)
import Task exposing (..)
import Route as Route
import Http
import Request exposing (..)
import Html.Styled as Html exposing (..)
import Html.Styled.Events exposing (..)
import Html.Styled.Attributes exposing (attribute, placeholder, type_, action)
import API exposing (..)
import Data.Session exposing (..)
import Views.Forms exposing (..)
import Debug


-- MODEL --


type alias Model =
    { token : String
    , newUser : NewUser
    }


initialModel : Model
initialModel =
    { token = ""
    , newUser = NewUser "" "" ""
    }


init : Task Http.Error String
init =
    Http.toTask getToken



-- VIEW --


type Msg
    = InitFinished (Result Http.Error String)
    | UpdateNewUser NewUser
    | Register
    | RegisterFinished (Result Http.Error NoContent)
    | RetrieveUserFinished (Result Http.Error User)


type ExternalMsg
    = NoOp
    | SetAuthUser AuthUser


view : Model -> Html Msg
view model =
    div []
        [ viewFormRegister model.newUser UpdateNewUser Register ]



-- UPDATE --


update : Msg -> Model -> ( ( Model, Cmd Msg ), ExternalMsg )
update msg model =
    case msg of
        InitFinished (Ok token) ->
            { model | token = token }
                => Cmd.none
                => NoOp

        InitFinished (Err _) ->
            model
                => Cmd.none
                => NoOp

        UpdateNewUser newUser ->
            { model | newUser = newUser }
                => Cmd.none
                => NoOp

        Register ->
            model
                => Http.send RegisterFinished (postNewUser model.token model.newUser)
                => NoOp

        RegisterFinished (Ok _) ->
            model
                => getUserCmd RetrieveUserFinished model.newUser.username model.newUser.password
                => NoOp

        RegisterFinished (Err _) ->
            model
                => Cmd.none
                => NoOp

        RetrieveUserFinished (Ok user) ->
            let
                authUser =
                    (AuthUser (.userid user) (model.newUser.username) (model.newUser.password))
            in
                model
                    => Cmd.batch [ storeSession authUser, Route.modifyUrl Route.Home ]
                    => SetAuthUser authUser

        RetrieveUserFinished (Err _) ->
            model
                => Cmd.none
                => NoOp
