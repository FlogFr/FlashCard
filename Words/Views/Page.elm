module Views.Page exposing (frame)

import Data.Session exposing (Session)
import API exposing (User)
import Route as Route exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)


frame : Session -> Html msg -> Html msg
frame session content =
    div []
        [ viewHeader session
        , content
        , viewFooter
        ]


viewHeader : Session -> Html msg
viewHeader session =
    nav []
        [ h1 []
            [ text "Learn the words!"
            , a [ Route.href Route.Login ] [ text "Return to login" ]
            , a [ Route.href Route.Home ] [ text "Go home" ]
            ]
        , viewSignIn session.user
        ]


viewFooter : Html msg
viewFooter =
    div []
        []


viewSignIn : Maybe User -> Html msg
viewSignIn maybeUser =
    case maybeUser of
        Just user ->
            div [] [ text ("Hello dear " ++ user.username) ]

        Nothing ->
            div [] [ text "Please sign in" ]
