module Views.Page exposing (frame)

import Data.Session exposing (AuthUser, Session)
import Data.Message exposing (..)
import API exposing (User)
import Route as Route exposing (..)
import IziCss exposing (..)
import Views.Messages exposing (..)
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)


frame : Session -> List Message -> Html msg -> Html msg
frame session listMessages content =
    div [ bodyFrame ]
        [ viewHeader session
        , div [ leftFrame ] []
        , div [ mainFrame ] [ viewMessages listMessages, content ]
        , div [ rightFrame ] []
        , viewLeftFooter
        , viewFooter
        , viewRightFooter
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
            ]
        , div [ rightHeaderFrame ] [ viewNav session ]
        ]


viewMessages : List Message -> Html msg
viewMessages listMessages =
    div []
        [ ul [] (List.map viewMessageLi listMessages)
        ]


viewLeftFooter : Html msg
viewLeftFooter =
    div [ leftBottomFrame ] []


viewFooter : Html msg
viewFooter =
    div [ bottomFrame ]
        [ p [ whiteColor ] [ text "Proudly powered by " ]
        , img [ bottomLogo, src "/ressources/haskell-logo.png" ] []
        , img [ bottomLogo, src "/ressources/servant-logo.png" ] []
        , img [ bottomLogo, src "/ressources/postgresql-logo.png" ] []
        , img [ bottomLogo, src "/ressources/elm-logo.png" ] []
        , img [ bottomLogo, src "/ressources/debian-logo.png" ] []
        ]


viewRightFooter : Html msg
viewRightFooter =
    div [ rightBottomFrame ]
        [ p [ whiteColor ] [ text "made with ❤ from ❤ aRkadeFR ❤" ] ]


viewNav : Session -> Html msg
viewNav session =
    case session.user of
        Just user ->
            nav []
                [ a [ Route.href Route.Home, whiteLink ] [ text "Go home" ]
                , a [ Route.href Route.ProfileEdit, whiteLink ] [ text "- Edit My Profile" ]
                , a [ Route.href Route.Logout, whiteLink ] [ text "- Logout" ]
                ]

        Nothing ->
            nav
                []
                [ a [ Route.href Route.Register, whiteLink ] [ text "- REGISTER -" ] ]
