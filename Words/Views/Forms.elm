module Views.Forms exposing (..)

import Html as Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import String
import API exposing (..)


viewFormAddWord : List String -> msg -> (String -> msg) -> (String -> msg) -> (String -> msg) -> Html msg
viewFormAddWord possibleLanguages homeAddNewWord typeHomeLanguage typeHomeWord typeHomeDefinition =
    Html.form [ onSubmit homeAddNewWord, action "javascript:void(0);" ]
        [ select [ onInput typeHomeLanguage, name "language" ] (List.map (\l -> option [] [ text l ]) possibleLanguages)
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
    Html.form [ onSubmit loginTryMsg, action "javascript:void(0);" ]
        [ label [ for "username" ] [ text "Username" ]
        , input [ onInput typeLoginMsg, placeholder "username", attribute "type" "text" ] []
        , label [ for "password" ] [ text "Password" ]
        , input [ onInput typePasswordMsg, placeholder "password", attribute "type" "password" ] []
        , button [ type_ "submit" ] [ text "log-in" ]
        ]


updateNiemeListElement : Int -> a -> List a -> List a
updateNiemeListElement nieme newElem l =
    List.append (List.append (List.take (nieme - 1) l) [ newElem ]) (List.drop nieme l)


viewLanguageUserInput : User -> msg -> (User -> msg) -> (Int -> msg) -> Int -> Html msg
viewLanguageUserInput user toIncreaseNbLanguage toUpdateUser toRemoveLanguage indexInput =
    let
        language =
            case (List.head <| List.drop indexInput user.languages) of
                Just responseLanguage ->
                    responseLanguage

                Nothing ->
                    ""
    in
        (div []
            [ input [ onInput (\v -> toUpdateUser { user | languages = updateNiemeListElement (indexInput + 1) v user.languages }), placeholder "languages to learn (2chars)", value language ] []
            , button [ onClick toIncreaseNbLanguage, type_ "button" ] [ text ("(+) Add a language") ]
            , button [ onClick (toRemoveLanguage indexInput), type_ "button" ] [ text ("(-) Remove language") ]
            ]
        )


viewLanguageUserInputs : Int -> msg -> (Int -> msg) -> User -> (User -> msg) -> List (Html msg)
viewLanguageUserInputs numberOfInput toIncreaseNbLanguage toRemoveLanguage user toUpdateUser =
    let
        createLanguageInput indexInput _ =
            viewLanguageUserInput user toIncreaseNbLanguage toUpdateUser toRemoveLanguage indexInput
    in
        List.indexedMap createLanguageInput (List.repeat numberOfInput ())


viewFormUpdateUser : User -> Int -> msg -> (Int -> msg) -> (User -> msg) -> msg -> (String -> msg) -> Html msg
viewFormUpdateUser user nbLanguage toIncreaseNbLanguage toRemoveLanguage toUpdateNewUser toUpdateMsg toUpdatePassword =
    Html.form [ onSubmit toUpdateMsg, action "javascript:void(0);" ]
        ([ input [ onInput toUpdatePassword, placeholder "new password", attribute "type" "password" ] []
         , input [ onInput (\v -> toUpdateNewUser { user | email = Just v }), placeholder "new email", value (Maybe.withDefault "" user.email) ] []
         ]
            ++ (viewLanguageUserInputs nbLanguage toIncreaseNbLanguage toRemoveLanguage user toUpdateNewUser)
            ++ [ button [ type_ "submit" ] [ text "update password" ]
               ]
        )


viewLanguageNewUserInput : NewUser -> msg -> (NewUser -> msg) -> Int -> Html msg
viewLanguageNewUserInput newUser toIncreaseNbLanguage toUpdateRegisterModel indexInput =
    (div [ class "group-form" ]
        [ label [ for ("language" ++ String.fromInt indexInput) ] [ text "Language" ]
        , input [ onInput (\v -> toUpdateRegisterModel { newUser | languages = updateNiemeListElement (indexInput + 1) v newUser.languages }), placeholder "languages to learn (2chars)" ] []
        , button [ onClick toIncreaseNbLanguage, class "button-add", type_ "button" ] [ span [ class "icon-plus" ] [] ]
        ]
    )


viewLanguageNewUserInputs : Int -> msg -> NewUser -> (NewUser -> msg) -> List (Html msg)
viewLanguageNewUserInputs numberOfInput toIncreaseNbLanguage newUser toUpdateRegisterModel =
    let
        createLanguageInput indexInput _ =
            viewLanguageNewUserInput newUser toIncreaseNbLanguage toUpdateRegisterModel indexInput
    in
        List.indexedMap createLanguageInput (List.repeat numberOfInput ())


viewFormRegister : NewUser -> Int -> msg -> (NewUser -> msg) -> msg -> Html msg
viewFormRegister newUser nbLanguage toIncreaseNbLanguage toUpdateRegisterModel toRegisterMsg =
    Html.form [ onSubmit toRegisterMsg, action "javascript:void(0);" ]
        ([ label [ for "username" ] [ text "Username" ]
         , input [ onInput (\v -> toUpdateRegisterModel { newUser | username = v }), placeholder "username" ] []
         , label [ for "password" ] [ text "Password" ]
         , input [ onInput (\v -> toUpdateRegisterModel { newUser | password = v }), placeholder "password", attribute "type" "password" ] []
         , label [ for "email" ] [ text "Email" ]
         , input [ onInput (\v -> toUpdateRegisterModel { newUser | email = Just v }), placeholder "email" ] []
         ]
            ++ (viewLanguageNewUserInputs nbLanguage toIncreaseNbLanguage newUser toUpdateRegisterModel)
            ++ [ button [ type_ "submit" ] [ text "please, register me" ]
               ]
        )


viewKeywordInput : Word -> msg -> (Int -> msg) -> (Word -> msg) -> Int -> Html msg
viewKeywordInput word toIncreaseNbKeyword toRemoveKeyword toUpdateWord indexInput =
    let
        keyword =
            case (List.head <| List.drop indexInput word.keywords) of
                Just responseKeyword ->
                    responseKeyword

                Nothing ->
                    ""
    in
        (div []
            [ input [ onInput (\v -> toUpdateWord { word | keywords = updateNiemeListElement (indexInput + 1) v word.keywords }), placeholder "keyword", value keyword ] []
            , button [ onClick toIncreaseNbKeyword, type_ "button" ] [ text ("(+) Add a keyword") ]
            , button [ onClick (toRemoveKeyword indexInput), type_ "button" ] [ text ("(-) Remove keyword") ]
            ]
        )


viewKeywordInputs : Int -> msg -> (Int -> msg) -> Word -> (Word -> msg) -> List (Html msg)
viewKeywordInputs numberOfInput toIncreaseNbKeyword toRemoveKeyword word toUpdateWord =
    let
        createWordInput indexInput _ =
            viewKeywordInput word toIncreaseNbKeyword toRemoveKeyword toUpdateWord indexInput
    in
        List.indexedMap createWordInput (List.repeat numberOfInput ())


viewWordForm : Word -> Int -> msg -> (Int -> msg) -> (Word -> msg) -> msg -> Html msg
viewWordForm word nbKeyword toIncreaseNbKeyword toRemoveKeyword toUpdateWord toUpdateMsg =
    Html.form [ onSubmit toUpdateMsg ]
        ([ input [ onInput (\v -> toUpdateWord { word | language = v }), placeholder "language", value (.language word) ] []
         , input [ onInput (\v -> toUpdateWord { word | word = v }), placeholder "definition", value (.word word) ] []
         ]
            ++ (viewKeywordInputs nbKeyword toIncreaseNbKeyword toRemoveKeyword word toUpdateWord)
            ++ [ input [ onInput (\v -> toUpdateWord { word | definition = v }), placeholder "definition", value (.definition word) ] []
               , input [ placeholder "difficulty (0 to 10)", value (String.fromInt (Maybe.withDefault 0 (.difficulty word))) ] []
               , button [ type_ "submit" ] [ text "Update word" ]
               ]
        )
