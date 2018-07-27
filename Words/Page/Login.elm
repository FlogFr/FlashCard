module Page.Login exposing (ExternalMsg(..), Model, Msg, initialModel, view, update)

import Util exposing ((=>))
import API exposing (..)
import Route as Route
import Http
import Request exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (attribute, placeholder, type_, action)
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
    | SetUser User


view : Model -> Html Msg
view model =
    div []
        [ form
            [ onSubmit LoginTryMsg, action "javascript:void(0);" ]
            [ input [ onInput TypeLoginMsg, placeholder "login" ] []
            , input [ onInput TypePasswordMsg, placeholder "password", attribute "type" "password" ] []
            , button [ type_ "submit" ] [ text "log-in" ]
            ]
        ]



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
            model
                => Cmd.batch [ Route.modifyUrl Route.Home ]
                => SetUser user

        LoginCompletedMsg (Err error) ->
            model
                => Cmd.none
                => NoOp
