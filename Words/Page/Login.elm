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
import Debug


-- MODEL --


type alias Model =
    { errors : List String
    , username : String
    , userpassword : String
    , jwtToken : Maybe JWTToken
    }


initialModel : Model
initialModel =
    { errors = []
    , username = ""
    , userpassword = ""
    , jwtToken = Nothing
    }



-- VIEW --


type Msg
    = TypeLoginMsg String
    | TypePasswordMsg String
    | LoginTryMsg
    | LoginGrantCompletedMsg (Result Http.Error JWTToken)
    | LoginRequestUserCompletedMsg (Result Http.Error User)


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
            { model | jwtToken = Just jwtToken }
                => Cmd.batch [ getUserCmd LoginRequestUserCompletedMsg jwtToken ]
                => NoOp

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

        LoginRequestUserCompletedMsg (Ok user) ->
            let
                session =
                    Session (model.jwtToken) (Just user)
            in
                model
                    => Cmd.batch [ storeSession session, Route.modifyUrl Route.Home ]
                    => SetSession session

        LoginRequestUserCompletedMsg (Err httpError) ->
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
