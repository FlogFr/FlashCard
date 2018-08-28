module Page.Register exposing (ExternalMsg(..), Model, Msg(..), init, initialModel, view, update)

import API exposing (..)
import Task exposing (..)
import Route as Route
import Http
import Request exposing (..)
import Html as Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (attribute, placeholder, type_, action, class)
import API exposing (..)
import Data.Session exposing (..)
import Views.Forms exposing (..)
import Views.Errors exposing (..)


-- MODEL --


type alias Model =
    { errors : List String
    , token : String
    , newUser : NewUser
    , nbLanguage : Int
    }


initialModel : Model
initialModel =
    { errors = []
    , token = ""
    , newUser = NewUser "" "" (Just "") []
    , nbLanguage = 1
    }


init : Task Http.Error String
init =
    Http.toTask getToken



-- VIEW --


type Msg
    = InitFinished (Result Http.Error String)
    | IncreaseNbLanguage
    | UpdateNewUser NewUser
    | Register
    | RegisterFinished (Result Http.Error NoContent)


type ExternalMsg
    = NoOp
    | GoLogin


view : Model -> Html Msg
view model =
    div [ class "form-div" ]
        [ h1 [] [ text "Register", span [] [ a [ Route.href Route.Login ] [ text "or login" ] ] ]
        , viewFormRegister model.newUser model.nbLanguage IncreaseNbLanguage UpdateNewUser Register
        ]



-- UPDATE --


update : Msg -> Model -> ( ( Model, Cmd Msg ), ExternalMsg )
update msg model =
    case msg of
        InitFinished (Ok token) ->
            ( ( { model | token = token }
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
                ( ( { model | errors = errorString :: model.errors }
                  , Cmd.none
                  )
                , NoOp
                )

        UpdateNewUser newUser ->
            ( ( { model | newUser = newUser }
              , Cmd.none
              )
            , NoOp
            )

        Register ->
            ( ( model
              , Http.send RegisterFinished (postNewUser model.token model.newUser)
              )
            , NoOp
            )

        RegisterFinished (Ok _) ->
            ( ( model
              , Cmd.none
              )
            , GoLogin
            )

        RegisterFinished (Err err) ->
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
                ( ( { model | errors = errorString :: model.errors }
                  , Cmd.none
                  )
                , NoOp
                )
