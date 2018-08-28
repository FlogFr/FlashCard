module Page.Quizz exposing (Model, Msg(..), initialModel, view, init, update)

import Http
import Task exposing (..)
import Html as Html exposing (..)
import Html.Attributes exposing (..)
import Route exposing (Route(..), href)
import Data.Session exposing (..)
import Views.Words exposing (..)
import Request exposing (..)
import API exposing (..)


-- MODEL --


type alias Model =
    { errors : List String
    , keyword : String
    , words : List Word
    }


initialModel : String -> Model
initialModel keyWord =
    { errors = []
    , words = []
    , keyword = keyWord
    }


init : Session -> String -> Task Http.Error (List Word)
init session keyword =
    Http.toTask (getWordsQuizzRequest session keyword)



-- View --


type Msg
    = TestMsg
    | QuizzInitFinished (Result Http.Error (List Word))


type ExternalMsg
    = NoOp


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "My words for the quizz:" ]
        , viewWordsCards (.words model)
        ]


update : Session -> Msg -> Model -> ( ( Model, Cmd Msg ), ExternalMsg )
update session msg model =
    case msg of
        QuizzInitFinished (Ok listWords) ->
            ( ( { model | words = listWords }
              , Cmd.none
              )
            , NoOp
            )

        QuizzInitFinished (Err _) ->
            ( ( model
              , Cmd.none
              )
            , NoOp
            )

        TestMsg ->
            ( ( model
              , Cmd.none
              )
            , NoOp
            )
