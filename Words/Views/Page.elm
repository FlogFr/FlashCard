module Views.Page exposing (frame)

import Data.Session exposing (Session)
import Data.Message exposing (..)
import API exposing (User)
import Route as Route exposing (..)
import Views.Messages exposing (..)
import Html as Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


frame : Session -> List Message -> Html msg -> Html msg
frame session listMessages content =
    div [ class "container" ]
        [ viewHeader session
        , div [] []
        , div [ class "main" ] [ viewMessages listMessages, content ]
        , div [] []
        , viewFooter
        ]


viewHeader : Session -> Html msg
viewHeader session =
    div [ class "header" ]
        [ div [ class "header-title" ]
            [ h1 []
                [ img [ src "/ressources/dictionnary.logo.png" ] []
                , text "IziDict.com"
                ]
            ]
        , div [ class "logos" ]
            [ img [ class "support-logo", src "/ressources/Logo.ELM.png" ] []
            , img [ class "support-logo", src "/ressources/Logo.Haskell.png" ] []
            , img [ class "support-logo", src "/ressources/Logo.Github.png" ] []
            , img [ class "support-logo", src "/ressources/Logo.Servant.png" ] []
            , img [ class "support-logo", src "/ressources/Logo.PostgreSQL.png" ] []
            , img [ class "support-logo", src "/ressources/Logo.Debian.png" ] []
            ]
        , div [ class "navigation" ] [ viewNav session ]
        ]


viewMessages : List Message -> Html msg
viewMessages listMessages =
    div [ class "messages" ]
        [ ul [] (List.map viewMessageLi listMessages)
        ]


viewFooter : Html msg
viewFooter =
    div [ class "footer" ]
        [ p [] [ text "Made with ❤ from WAW ❤ by ", a [ Html.Attributes.href "https://github.com/aRkadeFR" ] [ text "aRkadeFR" ] ]
        ]


viewNav : Session -> Html msg
viewNav session =
    case session.user of
        Just user ->
            nav []
                [ ul []
                    [ li [] [ a [ Route.href Route.Home ] [ text "Go home" ] ]
                    , li [] [ a [ Route.href Route.ProfileEdit ] [ text "Edit Profile" ] ]
                    , li [] [ a [ Route.href Route.Logout ] [ text "Logout" ] ]
                    ]
                ]

        Nothing ->
            nav []
                [ ul []
                    [ li [] [ a [ Route.href Route.Login ] [ text "Login" ] ]
                    , li [] [ a [ Route.href Route.Register ] [ text "Register" ] ]
                    ]
                ]
