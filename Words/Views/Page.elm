module Views.Page exposing (frame)

import Data.Session exposing (AuthUser, Session)
import API exposing (User)
import Route as Route exposing (..)
import IziCss exposing (..)
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes exposing (..)


frame : Session -> Html msg -> Html msg
frame session content =
    div [ bodyFrame ]
        [ viewHeader session
        , div [ mainFrame ] [ content ]
        , viewFooter
        ]


viewHeader : Session -> Html msg
viewHeader session =
    div [ headerFrame ]
        [ h1 [ titleCss ]
            [ img [ logo, src "/ressources/dictionnary.logo.png" ] []
            , text "IziDict.com - Strengthen your words!"
            ]
        , viewNav session.user
        ]


viewFooter : Html msg
viewFooter =
    div [ bottomFrame ]
        [ p [] [ text "made with ❤ from ❤ WAW ❤" ] ]


viewNav : Maybe AuthUser -> Html msg
viewNav maybeUser =
    case maybeUser of
        Just user ->
            nav []
                [ a [ Route.href Route.Home ] [ text "Go home" ]
                ]

        Nothing ->
            nav []
                []
