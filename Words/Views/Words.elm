module Views.Words exposing (..)

import Html as Html exposing (..)
import Html.Attributes exposing (attribute, href, class, action, placeholder, target, rel)
import Html.Events exposing (..)
import API exposing (..)
import Route as R
import Url
import Maybe as Maybe


viewWordTr : Word -> Html msg
viewWordTr word =
    tr []
        [ td [] [ text (.language word) ]
        , td [] [ text (.word word) ]
        , td [] [ text (.definition word) ]
        , td [] [ text (String.concat (List.intersperse ", " (.keywords word))) ]
        , td []
            [ a [ R.href (R.WordEdit (.id word)) ] [ span [ class "icon-pencil" ] [] ]
            , a [ R.href (R.WordDelete (.id word)) ] [ span [ class "icon-trash-empty" ] [] ]
            ]
        ]


viewWordsTable : List Word -> Html msg
viewWordsTable words =
    table []
        [ thead []
            [ tr []
                [ th [] [ text "language" ]
                , th [] [ text "original" ]
                , th [] [ text "my translation" ]
                , th [] [ text "keywords" ]
                , th [] [ text "edit" ]
                ]
            ]
        , tbody []
            (List.map viewWordTr words)
        ]


viewWordCard : Word -> Html msg
viewWordCard word =
    let
        dicUrl =
            "https://"
                ++ (String.toLower word.language)
                ++ ".wiktionary.org/wiki/Special:Search?search="
                ++ (Url.percentEncode word.word)
    in
        div [ class "word-container" ]
            [ text " "
            , div [ class "word-container-header" ]
                [ h1 [] [ text (.word word) ]
                , div [ class "word-container-header-icons" ]
                    [ a [ R.href (R.WordDelete (.id word)) ] [ span [ class "icon-trash-empty" ] [] ]
                    , a [ R.href (R.WordEdit (.id word)) ] [ span [ class "icon-pencil" ] [] ]
                    , a [ href dicUrl, target "_blank", rel "noopener noreferrer" ]
                        [ span
                            [ class
                                "icon-search"
                            ]
                            []
                        , span [] [ text (.language word) ]
                        ]
                    ]
                ]
            , div [ class "word-container-body" ]
                [ p [] [ text (.definition word) ]
                ]
            ]


viewWordCardForm : Word -> (String -> msg) -> msg -> Html msg
viewWordCardForm word toUpdateWord toTakeQuizz =
    div [ class "word-container" ]
        [ text " "
        , div [ class "word-container-header" ]
            [ h1 [] [ text (.word word) ]
            , div [ class "word-container-header-icons" ]
                [ a [ R.href (R.WordDelete (.id word)) ] [ span [ class "icon-trash-empty" ] [] ]
                , a [ R.href (R.WordEdit (.id word)) ] [ span [ class "icon-pencil" ] [] ]
                , span [] [ text (.language word) ]
                ]
            ]
        , div [ class "word-container-body" ]
            [ Html.form
                [ onSubmit toTakeQuizz
                , action "javascript:void(0);"
                ]
                [ input [ onInput toUpdateWord, placeholder "response" ] []
                ]
            ]
        ]


viewWordsCards : List Word -> List (Html msg)
viewWordsCards words =
    List.intersperse (text " ") (List.map viewWordCard words)


viewKeywordsList : List String -> Html msg
viewKeywordsList listKeywords =
    List.map (\k -> li [] [ a [ R.href (R.Quizz k) ] [ text k ] ]) listKeywords
        |> ul []
