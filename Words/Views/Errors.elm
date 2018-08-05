module Views.Errors exposing (viewErrorsDiv)

import IziCss exposing (..)
import Html.Styled as Html exposing (..)
import Html.Styled.Events exposing (..)
import Html.Styled.Attributes exposing (..)
import List
import API exposing (..)


viewErrorParagraph : String -> Html msg
viewErrorParagraph error =
    p [ errorStyle ] [ text error ]


viewErrorsDiv : List String -> Html msg
viewErrorsDiv errors =
    div []
        (List.map viewErrorParagraph errors)
