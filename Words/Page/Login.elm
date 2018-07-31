module Page.Login exposing (ExternalMsg(..), Model, Msg, initialModel, view, update)

import Util exposing ((=>))
import API exposing (..)
import Route as Route
import Http
import Request exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (attribute, placeholder, type_, action)
import Data.Session exposing (..)
import Views.Forms exposing (..)
import Debug


-- MODEL --


type alias Model =
    { errors : List String
    , username : String
    , userpassword : String
    }


initialModel : Model
initialModel =
    { errors = []
    , username = ""
    , userpassword = ""
    }



-- VIEW --


type Msg
    = TypeLoginMsg String
    | TypePasswordMsg String
    | LoginTryMsg
    | LoginCompletedMsg (Result Http.Error User)


type ExternalMsg
    = NoOp
    | SetAuthUser AuthUser


view : Model -> Html Msg
view model =
    div []
        [ viewFormLogin LoginTryMsg TypeLoginMsg TypePasswordMsg ]



-- UPDATE --


update : Msg -> Model -> ( ( Model, Cmd Msg ), ExternalMsg )
update msg model =
    case msg of
        TypeLoginMsg userName ->
            { model | username = userName }
                => Cmd.none
                => NoOp

        TypePasswordMsg userPassword ->
            { model | userpassword = userPassword }
                => Cmd.none
                => NoOp

        LoginTryMsg ->
            let
                httpCmd =
                    getUserCmd LoginCompletedMsg (.username model) (.userpassword model)
            in
                model
                    => Cmd.batch [ httpCmd ]
                    => NoOp

        LoginCompletedMsg (Ok user) ->
            let
                authUser =
                    (AuthUser (.userid user) (.username model) (.userpassword model))
            in
                model
                    => Cmd.batch [ storeSession authUser, Route.modifyUrl Route.Home ]
                    => SetAuthUser authUser

        LoginCompletedMsg (Err error) ->
            model
                => Cmd.none
                => NoOp
