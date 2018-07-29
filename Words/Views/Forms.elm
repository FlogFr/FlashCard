module Views.Forms exposing (viewFormAddWord, viewFormLogin)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)


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
    Html.form [ onSubmit loginTryMsg, action "javascript:void(0);" ]
        [ input [ onInput typeLoginMsg, placeholder "login" ] []
        , input [ onInput typePasswordMsg, placeholder "password", attribute "type" "password" ] []
        , button [ type_ "submit" ] [ text "log-in" ]
        ]
