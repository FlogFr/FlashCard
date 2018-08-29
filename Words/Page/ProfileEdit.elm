module Page.ProfileEdit exposing (Model, initialModel, Msg(..), ExternalMsg(..), view, update)

import API exposing (..)
import Browser.Navigation as N
import Request exposing (..)
import Task exposing (..)
import Http exposing (..)
import Html as Html exposing (..)
import Html.Attributes exposing (..)
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
    div [ class "form-div" ]
        [ h1 [] [ text "My profile information" ]
        , viewFormUpdateUser model.user model.nbLanguage IncreaseNbLanguage RemoveLanguage UpdateUser ToUpdateUser UpdatePassword
        ]



-- UPDATE --


update : Session -> N.Key -> Msg -> Model -> ( ( Model, Cmd Msg ), ExternalMsg )
update session key msg model =
    case msg of
        TestMsg ->
            ( ( model
              , Cmd.none
              )
            , NoOp
            )

        UpdatePassword newPassword ->
            ( ( { model | password = newPassword }
              , Cmd.none
              )
            , NoOp
            )

        UpdateUser newUser ->
            ( ( { model | user = newUser }
              , Cmd.none
              )
            , NoOp
            )

        IncreaseNbLanguage ->
            ( ( { model | nbLanguage = (model.nbLanguage + 1) }
              , Cmd.none
              )
            , NoOp
            )

        RemoveLanguage argIndexLanguage ->
            let
                removeLanguage user indexLanguage =
                    { user | languages = ((List.take argIndexLanguage user.languages) ++ (List.drop (argIndexLanguage + 1) user.languages)) }
            in
                ( ( { model
                        | nbLanguage = (model.nbLanguage - 1)
                        , user = removeLanguage model.user argIndexLanguage
                    }
                  , Cmd.none
                  )
                , NoOp
                )

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
                ( ( model
                  , Http.send UpdateUserRequestFinished (updateUserRequest session (FullUser 0 username password email languages))
                  )
                , NoOp
                )

        UpdateUserRequestFinished (Ok user) ->
            let
                newSession =
                    { session | user = Just user }
            in
                ( ( model
                  , Cmd.batch [ storeSession newSession, N.pushUrl key (Route.routeToString Route.Home) ]
                  )
                , UpdateSession newSession
                )

        UpdateUserRequestFinished (Err noContent) ->
            ( ( model
              , Cmd.none
              )
            , NoOp
            )
