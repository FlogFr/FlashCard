module Views.Navigation exposing (viewNavigation)

import Data.Session exposing (Session)
import Maybe exposing (..)
import List
import Html exposing (..)
import Html.Attributes exposing (..)


viewNavigation : Session -> Html msg
viewNavigation session =
    case session.user of
        Just _ ->
            li []
                [ a []
                    [ span [ class "icon-pencil" ] []
                    , text "Edit Profile"
                    ]
                ]

        Nothing ->
            li [] []
