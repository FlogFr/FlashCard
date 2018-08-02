module Page.WordEdit exposing (Model, Msg(..), ExternalMsg(..), view, update, init, initialModel)

import Util exposing ((=>))
import API exposing (..)
import Request exposing (..)
import Task exposing (..)
import Http
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes exposing (..)
import Data.Session exposing (..)
import Route as Route exposing (Route(..), href)
import Views.Words exposing (..)
import Views.Forms exposing (..)
import Debug


-- MODEL --


type alias Model =
    { word : Maybe Word
    }


initialModel : Model
initialModel =
    { word = Nothing }


init : AuthUser -> Int -> Task Http.Error Word
init user wordId =
    Http.toTask (getWordByIdRequest user wordId)



-- View --


type Msg
    = TestMsg
    | UpdateWord Word
    | WordEditInitFinished (Result Http.Error Word)


type ExternalMsg
    = NoOp


view : Model -> Html Msg
view model =
    case model.word of
        Nothing ->
            div []
                [ p [] [ text "Loading the word…" ]
                ]

        Just word ->
            div []
                [ p [] [ text ("Word #" ++ toString (.wordId word)) ]
                , viewWordForm word UpdateWord
                ]



-- UPDATE --


update : Session -> Msg -> Model -> ( ( Model, Cmd Msg ), ExternalMsg )
update session msg model =
    case msg of
        TestMsg ->
            model
                => Cmd.none
                => NoOp

        UpdateWord newWord ->
            Debug.log "new word: " { model | word = Just newWord }
                => Cmd.none
                => NoOp

        WordEditInitFinished (Err _) ->
            model
                => Cmd.none
                => NoOp

        WordEditInitFinished (Ok word) ->
            { model | word = Just word }
                => Cmd.none
                => NoOp
