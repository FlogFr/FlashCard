module Page.Home exposing (Model, Msg(..), initialModel, view, update, init)

import Util exposing ((=>))
import API exposing (..)
import Request exposing (..)
import Task exposing (..)
import Http
import Html exposing (..)
import Html.Attributes exposing (..)
import Route as Route exposing (Route(..), href)
import Views.Words exposing (..)


-- MODEL --


type alias Model =
    { myLastWords : List Word
    }


initialModel : Model
initialModel =
    { myLastWords = []
    }


init : User -> Task Http.Error Model
init user =
    let
        httpTask =
            -- Result Http.Error (List Word)
            Http.toTask (getWordsLastRequest user)
    in
        Task.map Model httpTask



-- View --


type Msg
    = TestMsg
    | InitFinished (Result Http.Error Model)
    | LastWordsReqCompletedMsg (Result Http.Error (List Word))


type ExternalMsg
    = NoOp


view : Model -> Html Msg
view model =
    div []
        [ a [ Route.href Route.Quizz ]
            [ text "take a super quizz" ]
        , div
            []
            [ viewWordsTable model.myLastWords
            ]
        ]



-- UPDATE --


update : Msg -> Model -> ( ( Model, Cmd Msg ), ExternalMsg )
update msg model =
    case msg of
        TestMsg ->
            model
                => Cmd.none
                => NoOp

        LastWordsReqCompletedMsg (Ok listWords) ->
            { model | myLastWords = listWords }
                => Cmd.none
                => NoOp

        LastWordsReqCompletedMsg (Err error) ->
            model
                => Cmd.none
                => NoOp

        InitFinished (Ok newModel) ->
            newModel
                => Cmd.none
                => NoOp

        InitFinished (Err error) ->
            model
                => Cmd.none
                => NoOp
