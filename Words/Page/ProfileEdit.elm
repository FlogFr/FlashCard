module Page.ProfileEdit exposing (Model, Msg(..), ExternalMsg(..), view, update)

import Util exposing ((=>))
import API exposing (..)
import Request exposing (..)
import Task exposing (..)
import Http exposing (..)
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes exposing (..)
import Data.Session exposing (..)
import Route as Route exposing (Route(..), href)
import Views.Words exposing (..)
import Views.Forms exposing (..)


-- MODEL --


type alias Model =
    { newUser : NewUser
    }



-- View --


type Msg
    = TestMsg
    | UpdateUser NewUser
    | ToUpdateUser
    | UpdateUserRequestFinished (Result Http.Error User)


type ExternalMsg
    = NoOp
    | Logout
    | GoHome


view : Model -> Html Msg
view model =
    div []
        [ viewFormUpdateUser model.newUser UpdateUser ToUpdateUser
        ]



-- UPDATE --


update : Session -> Msg -> Model -> ( ( Model, Cmd Msg ), ExternalMsg )
update session msg model =
    case msg of
        TestMsg ->
            model
                => Cmd.none
                => NoOp

        UpdateUser newUser ->
            { model | newUser = newUser }
                => Cmd.none
                => NoOp

        ToUpdateUser ->
            let
                username =
                    (.username model.newUser)

                password =
                    (.password model.newUser)

                email =
                    (.email model.newUser)

                lang =
                    (.language model.newUser)
            in
                model
                    => Http.send UpdateUserRequestFinished (updateUserRequest session (GrantUser username password email lang))
                    => NoOp

        UpdateUserRequestFinished (Ok user) ->
            model
                => Cmd.none
                => GoHome

        UpdateUserRequestFinished (Err noContent) ->
            model
                => Cmd.none
                => NoOp
