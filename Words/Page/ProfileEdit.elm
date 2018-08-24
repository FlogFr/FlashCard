module Page.ProfileEdit exposing (Model, initialModel, Msg(..), ExternalMsg(..), view, update)

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
import Debug


-- MODEL --


type alias Model =
    { user : User
    , password : String
    , nbLanguage : Int
    }


initialModel : User -> Model
initialModel user =
    Model user "" ((List.length user.languages) + 1)



-- View --


type Msg
    = TestMsg
    | IncreaseNbLanguage
    | RemoveLanguage Int
    | UpdatePassword String
    | UpdateUser User
    | ToUpdateUser
    | UpdateUserRequestFinished (Result Http.Error User)


type ExternalMsg
    = NoOp
    | Logout
    | UpdateSession Session


view : Model -> Html Msg
view model =
    div []
        [ viewFormUpdateUser model.user model.nbLanguage IncreaseNbLanguage RemoveLanguage UpdateUser ToUpdateUser UpdatePassword
        ]



-- UPDATE --


update : Session -> Msg -> Model -> ( ( Model, Cmd Msg ), ExternalMsg )
update session msg model =
    case msg of
        TestMsg ->
            model
                => Cmd.none
                => NoOp

        UpdatePassword newPassword ->
            { model | password = newPassword }
                => Cmd.none
                => NoOp

        UpdateUser newUser ->
            { model | user = newUser }
                => Cmd.none
                => NoOp

        IncreaseNbLanguage ->
            { model | nbLanguage = (model.nbLanguage + 1) }
                => Cmd.none
                => NoOp

        RemoveLanguage indexLanguage ->
            let
                removeLanguage user indexLanguage =
                    { user | languages = ((List.take indexLanguage user.languages) ++ (List.drop (indexLanguage + 1) user.languages)) }
            in
                { model
                    | nbLanguage = (model.nbLanguage - 1)
                    , user = removeLanguage model.user indexLanguage
                }
                    => Cmd.none
                    => NoOp

        ToUpdateUser ->
            let
                username =
                    (.username model.user)

                password =
                    model.password

                email =
                    (.email model.user)

                languages =
                    (.languages model.user)
            in
                model
                    => Http.send UpdateUserRequestFinished (updateUserRequest session (FullUser 0 username password email languages))
                    => NoOp

        UpdateUserRequestFinished (Ok user) ->
            let
                newSession =
                    { session | user = Just user }
            in
                model
                    => Cmd.batch [ storeSession newSession, Route.modifyUrl Route.Home ]
                    => UpdateSession newSession

        UpdateUserRequestFinished (Err noContent) ->
            model
                => Cmd.none
                => NoOp
