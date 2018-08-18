module Views.Forms exposing (..)

import IziCss exposing (..)
import Html.Styled as Html exposing (..)
import Html.Styled.Events exposing (..)
import Html.Styled.Attributes exposing (..)
import API exposing (..)


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


viewFormSearchWord : List String -> msg -> (String -> msg) -> (String -> msg) -> Html msg
viewFormSearchWord keywords toSearchMsg toUpdateSearchWord toUpdateSearchKeyword =
    Html.form [ onSubmit toSearchMsg, action "javascript:void(0);" ]
        [ input [ onInput toUpdateSearchWord, placeholder "original word" ] []
        , select [ onInput toUpdateSearchKeyword, name "keyword" ]
            (List.concat
                [ [ option [] [ text "--" ] ]
                , (List.map (\k -> option [] [ text k ]) keywords)
                ]
            )
        , button [ type_ "submit" ] [ text "update search word" ]
        ]


viewFormLogin : msg -> (String -> msg) -> (String -> msg) -> Html msg
viewFormLogin loginTryMsg typeLoginMsg typePasswordMsg =
    Html.form [ niceBoxed, onSubmit loginTryMsg, action "javascript:void(0);" ]
        [ input [ inputCss, onInput typeLoginMsg, placeholder "login" ] []
        , input [ inputCss, onInput typePasswordMsg, placeholder "password", attribute "type" "password" ] []
        , btn [ type_ "submit" ] [ text "log-in" ]
        ]


viewFormUpdateUser : NewUser -> (NewUser -> msg) -> msg -> Html msg
viewFormUpdateUser newUser toUpdateNewUser toUpdateMsg =
    Html.form [ niceBoxed, onSubmit toUpdateMsg, action "javascript:void(0);" ]
        [ input [ inputCss, onInput (\v -> toUpdateNewUser { newUser | password = v }), placeholder "new password", attribute "type" "password" ] []
        , input [ inputCss, onInput (\v -> toUpdateNewUser { newUser | email = v }), placeholder "new email" ] []
        , input [ inputCss, onInput (\v -> toUpdateNewUser { newUser | language = v }), placeholder "language to learn (2chars)" ] []
        , btn [ type_ "submit" ] [ text "update password" ]
        ]


viewFormRegister : NewUser -> (NewUser -> msg) -> msg -> Html msg
viewFormRegister newUser toUpdateRegisterModel toRegisterMsg =
    Html.form [ niceBoxed, onSubmit toRegisterMsg, action "javascript:void(0);" ]
        [ input [ onInput (\v -> toUpdateRegisterModel { newUser | username = v }), placeholder "username" ] []
        , input [ onInput (\v -> toUpdateRegisterModel { newUser | password = v }), placeholder "password", attribute "type" "password" ] []
        , input [ onInput (\v -> toUpdateRegisterModel { newUser | email = v }), placeholder "email" ] []
        , input [ onInput (\v -> toUpdateRegisterModel { newUser | language = v }), placeholder "language to learn" ] []
        , btn [ type_ "submit" ] [ text "please, register me" ]
        ]


viewWordForm : Word -> (Word -> msg) -> msg -> Html msg
viewWordForm word toUpdateWord toUpdateMsg =
    Html.form [ onSubmit toUpdateMsg ]
        [ input [ onInput (\v -> toUpdateWord { word | language = v }), placeholder "language", value (.language word) ] []
        , input [ onInput (\v -> toUpdateWord { word | word = v }), placeholder "definition", value (.word word) ] []
        , input [ onInput (\v -> toUpdateWord { word | keywords = (String.split "," v) }), placeholder "keywords (comma separated)", value (List.foldr (++) "" (List.intersperse "," (.keywords word))) ] []
        , input [ onInput (\v -> toUpdateWord { word | definition = v }), placeholder "definition", value (.definition word) ] []
        , input [ placeholder "difficulty (0 to 10)", value (toString (Maybe.withDefault 0 (.difficulty word))) ] []
        , btn [ type_ "submit" ] [ text "Update word" ]
        ]
