module Page.Login exposing (ExternalMsg(..), Model, Msg, initialModel, view, update)

import Util exposing ((=>))
import API exposing (..)
import Route as Route
import Http
import Request exposing (..)
import Html.Styled as Html exposing (..)
import Html.Styled.Events exposing (..)
import Html.Styled.Attributes exposing (attribute, placeholder, type_, action)
import Data.Session exposing (..)
import Views.Forms exposing (..)
import Views.Errors exposing (..)


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
    | LoginGrantCompletedMsg (Result Http.Error JWTToken)


type ExternalMsg
    = NoOp
    | SetSession Session


view : Model -> Html Msg
view model =
    div []
        [ viewErrorsList (.errors model)
        , h1 [] [ text "Please login" ]
        , p [] [ a [ Route.href Route.Register ] [ text "or register" ] ]
        , viewFormLogin LoginTryMsg TypeLoginMsg TypePasswordMsg
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
                    getJWTTokenRequest (GrantUser (.username model) (.userpassword model))
                        |> Http.send LoginGrantCompletedMsg
            in
                model
                    => Cmd.batch [ httpCmd ]
                    => NoOp

        LoginGrantCompletedMsg (Ok jwtToken) ->
            let
                authUser =
                    (AuthUser (.username model) (.userpassword model))

                session =
                    Session (Just jwtToken) (Just authUser)
            in
                model
                    => Cmd.batch [ storeSession session, Route.modifyUrl Route.Home ]
                    => SetSession session

        LoginGrantCompletedMsg (Err httpError) ->
            case httpError of
                Http.BadStatus httpResponse ->
                    { model | errors = "Wrong credentials" :: (.errors model) }
                        => Cmd.none
                        => NoOp

                Http.NetworkError ->
                    { model | errors = "Wrong credentials" :: (.errors model) }
                        => Cmd.none
                        => NoOp

                _ ->
                    model
                        => Cmd.none
                        => NoOp
