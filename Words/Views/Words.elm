module Views.Words exposing (viewWordsTable)

import Html.Styled as Html exposing (..)
import API exposing (..)
import Route exposing (..)
import Maybe as Maybe


viewWordTr : Word -> Html msg
viewWordTr word =
    tr []
        [ td [] [ text (.wordLanguage word) ]
        , td [] [ text (.wordWord word) ]
        , td [] [ text (.wordDefinition word) ]
        , td [] [ text (String.concat (.wordKeywords word)) ]
        , td [] [ text (toString (Maybe.withDefault 0 (.wordDifficulty word))) ]
        , td [] [ a [ href (WordEdit (.wordId word)) ] [ text "edit" ] ]
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
