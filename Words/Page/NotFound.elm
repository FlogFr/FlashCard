module Page.NotFound exposing (view)

import Html.Styled as Html exposing (..)
import Html.Styled.Events exposing (..)


-- VIEW --


view : Html msg
view =
    div [] [ p [] [ text "not found" ] ]
