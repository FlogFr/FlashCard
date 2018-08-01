module Page.Quizz exposing (Model, Msg(..), initialModel, view)

import Http
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes exposing (..)
import Route exposing (Route(..), href)
import API exposing (..)


-- MODEL --


type alias Model =
    { errors : String
    }


initialModel : Model
initialModel =
    { errors = "No Error"
    }



-- View --


type Msg
    = TestMsg


view : Html Msg
view =
    div []
        [ p [] [ text "super quizz" ]
        ]
