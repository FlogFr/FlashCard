module Views.Forms exposing (viewFormAddWord, viewFormLogin)

import IziCss exposing (..)
import Html.Styled as Html exposing (..)
import Html.Styled.Events exposing (..)
import Html.Styled.Attributes exposing (..)


viewFormAddWord : msg -> (String -> msg) -> (String -> msg) -> (String -> msg) -> Html msg
viewFormAddWord homeAddNewWord typeHomeLanguage typeHomeWord typeHomeDefinition =
    Html.form [ onSubmit homeAddNewWord, action "javascript:void(0);" ]
        [ select [ onInput typeHomeLanguage, name "language" ]
            [ option [] [ text "EN" ]
            , option [] [ text "FR" ]
            , option [] [ text "PL" ]
            , option [] [ text "TS" ]
            ]
        , input [ onInput typeHomeWord, placeholder "word" ] []
        , input [ onInput typeHomeDefinition, placeholder "definition" ] []
        , button [ type_ "submit" ] [ text "add word" ]
        ]


viewFormLogin : msg -> (String -> msg) -> (String -> msg) -> Html msg
viewFormLogin loginTryMsg typeLoginMsg typePasswordMsg =
    Html.form [ niceBoxed, onSubmit loginTryMsg, action "javascript:void(0);" ]
        [ input [ inputCss, onInput typeLoginMsg, placeholder "login" ] []
        , input [ inputCss, onInput typePasswordMsg, placeholder "password", attribute "type" "password" ] []
        , btn [ type_ "submit" ] [ text "log-in" ]
        ]
