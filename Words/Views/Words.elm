module Views.Words exposing (viewWordsTable, viewKeywordsList)

import Html.Styled as Html exposing (..)
import IziCss exposing (..)
import API exposing (..)
import Route exposing (..)
import Maybe as Maybe


viewWordTr : Word -> Html msg
viewWordTr word =
    tr []
        [ td [ tdBorder ] [ text (.wordLanguage word) ]
        , td [ tdBorder ] [ text (.wordWord word) ]
        , td [ tdBorder ] [ text (.wordDefinition word) ]
        , td [ tdBorder ] [ text (String.concat (List.intersperse ", " (.wordKeywords word))) ]
        , td [ tdBorder ] [ text (toString (Maybe.withDefault 0 (.wordDifficulty word))) ]
        , td [ tdBorder ]
            [ a [ href (WordEdit (.wordId word)) ] [ text "edit" ]
            , a [ href (WordDelete (.wordId word)) ] [ text "delete" ]
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
                , th [] [ text "difficulty" ]
                , th [] [ text "edit" ]
                ]
            ]
        , tbody []
            (List.map viewWordTr words)
        ]


viewKeywordsList : List String -> Html msg
viewKeywordsList listKeywords =
    List.map (\k -> li [] [ text k ]) listKeywords
        |> ul []
