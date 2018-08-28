module Views.Words exposing (..)

import Html as Html exposing (..)
import Html.Attributes exposing (attribute)
import API exposing (..)
import Route exposing (..)
import Maybe as Maybe


viewWordTr : Word -> Html msg
viewWordTr word =
    tr []
        [ td [] [ text (.language word) ]
        , td [] [ text (.word word) ]
        , td [] [ text (.definition word) ]
        , td [] [ text (String.concat (List.intersperse ", " (.keywords word))) ]
        , td []
            [ a [ href (WordEdit (.id word)) ] [ text "edit" ]
            , a [ href (WordDelete (.id word)) ] [ text "delete" ]
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
    div []
        [ div []
            [ h1 [] [ text (.word word) ]
            , p []
                [ a [ href (WordDelete (.id word)) ] [ text " " ]
                , a [ href (WordEdit (.id word)) ] [ text " " ]
                , text (.language word)
                ]
            ]
        , div []
            [ p [] [ text (.definition word) ]
            ]
        ]


viewWordsCards : List Word -> Html msg
viewWordsCards words =
    div [] (List.map viewWordCard words)


viewKeywordsList : List String -> Html msg
viewKeywordsList listKeywords =
    List.map (\k -> li [] [ a [ href (Quizz k) ] [ text k ] ]) listKeywords
        |> ul []
