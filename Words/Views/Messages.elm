module Views.Messages exposing (..)

import IziCss exposing (..)
import Data.Message exposing (..)
import Html.Styled as Html exposing (..)
import Html.Styled.Events exposing (..)
import Html.Styled.Attributes exposing (..)
import API exposing (..)


viewMessageLi : Message -> Html msg
viewMessageLi message =
    case message of
        Message criticity msgString ->
            li [] [ text ("message: " ++ msgString) ]
