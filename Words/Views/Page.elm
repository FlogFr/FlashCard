module Views.Page exposing (frame)

import Data.Session exposing (AuthUser, Session)
import API exposing (User)
import Route as Route exposing (..)
import IziCss exposing (..)
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)


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
        [ div [ leftHeaderFrame ] []
        , div [ centerHeaderFrame ]
            [ h1 [ titleCss ]
                [ img [ logo, src "/ressources/dictionnary.logo.png" ] []
                , text "IziDict.com"
                ]
            , viewNav session
            ]
        , div [ rightHeaderFrame ] []
        ]


viewFooter : Html msg
viewFooter =
    div [ bottomFrame ]
        [ p [] [ text "made with ❤ from ❤ WAW ❤" ] ]


viewNav : Session -> Html msg
viewNav session =
    case session.user of
        Just user ->
            nav []
                [ a [ Route.href Route.Home ] [ text "Go home" ]
                , a [ Route.href Route.Logout ] [ text "- Logout -" ]
                ]

        Nothing ->
            nav
                []
                [ a [ Route.href Route.Register ] [ text "- REGISTER -" ] ]
