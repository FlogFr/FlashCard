module Views.Messages exposing (..)

import Data.Message exposing (..)
import Html as Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import API exposing (..)


viewMessageLi : Message -> Html msg
viewMessageLi message =
    case message of
        Message criticity msgString ->
            li [] [ text ("message: " ++ msgString) ]
