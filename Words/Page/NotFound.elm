module Page.NotFound exposing (view)

import Html as Html exposing (..)
import Html.Events exposing (..)


-- VIEW --


view : Html msg
view =
    div [] [ p [] [ text "not found" ] ]
