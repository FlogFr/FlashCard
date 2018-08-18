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
import Views.Errors exposing (..)
import Debug


-- MODEL --


type alias Model =
    { errors : List String
    , token : String
    , newUser : NewUser
    }


initialModel : Model
initialModel =
    { errors = []
    , token = ""
    , newUser = NewUser "" "" "" ""
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


type ExternalMsg
    = NoOp
    | GoLogin


view : Model -> Html Msg
view model =
    div []
        [ viewErrorsDiv model.errors
        , h1 [] [ text "Register:" ]
        , viewFormRegister model.newUser UpdateNewUser Register
        ]



-- UPDATE --


update : Msg -> Model -> ( ( Model, Cmd Msg ), ExternalMsg )
update msg model =
    case msg of
        InitFinished (Ok token) ->
            { model | token = token }
                => Cmd.none
                => NoOp

        InitFinished (Err err) ->
            let
                errorString =
                    case err of
                        Http.BadUrl _ ->
                            "bad url"

                        Http.Timeout ->
                            "timeout"

                        Http.NetworkError ->
                            "network error"

                        Http.BadStatus _ ->
                            "bad status"

                        Http.BadPayload _ _ ->
                            "bad payload"
            in
                { model | errors = errorString :: model.errors }
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
                => Cmd.none
                => GoLogin

        RegisterFinished (Err err) ->
            let
                errorString =
                    case Debug.log "error: " err of
                        Http.BadUrl _ ->
                            "bad url"

                        Http.Timeout ->
                            "timeout"

                        Http.NetworkError ->
                            "network error"

                        Http.BadStatus _ ->
                            "bad status"

                        Http.BadPayload _ _ ->
                            "bad payload"
            in
                { model | errors = errorString :: model.errors }
                    => Cmd.none
                    => NoOp
