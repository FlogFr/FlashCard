module Views.Errors exposing (..)

import Html as Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import List
import API exposing (..)


viewErrorParagraph : String -> Html msg
viewErrorParagraph error =
    p [] [ text error ]


viewErrorsDiv : List String -> Html msg
viewErrorsDiv errors =
    div []
        (List.map viewErrorParagraph errors)


viewErrorsList : List String -> Html msg
viewErrorsList errors =
    ul [] (List.map (\e -> li [] [ text e ]) errors)
