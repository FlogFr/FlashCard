module Page.WordDelete exposing (Model, Msg(..), ExternalMsg(..), view, update, init)

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
    { wordId : Int
    }


init : Session -> Int -> Task Http.Error NoContent
init session wordId =
    Http.toTask (deleteWordByIdRequest session wordId)



-- View --


type Msg
    = WordDeleteInitFinished (Result Http.Error NoContent)


type ExternalMsg
    = NoOp
    | GoHome


view : Model -> Html Msg
view model =
    div []
        [ p [] [ text "Deleting the word…" ]
        ]



-- UPDATE --


update : Session -> Msg -> Model -> ( ( Model, Cmd Msg ), ExternalMsg )
update session msg model =
    case msg of
        WordDeleteInitFinished (Ok _) ->
            model
                => Cmd.none
                => GoHome

        WordDeleteInitFinished (Err err) ->
            model
                => Cmd.none
                => NoOp
