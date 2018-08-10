module Views.Words exposing (..)

import Html.Styled as Html exposing (..)
import IziCss exposing (..)
import Html.Attributes exposing (attribute)
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
                , th [] [ text "edit" ]
                ]
            ]
        , tbody []
            (List.map viewWordTr words)
        ]


viewWordCard : Word -> Html msg
viewWordCard word =
    div [ wordCardCss ]
        [ div [ captionWordCss ]
            [ h1 [ captionWordH1Css ] [ text (.wordWord word) ]
            , p [ captionWordLanguageCss ]
                [ a [ iconWindowClose, href (WordDelete (.wordId word)) ] [ text " " ]
                , a [ iconEdit, href (WordEdit (.wordId word)) ] [ text " " ]
                , text (.wordLanguage word)
                ]
            ]
        , div []
            [ p [] [ text (.wordDefinition word) ]
            ]
        ]


viewWordsCards : List Word -> Html msg
viewWordsCards words =
    div [] (List.map viewWordCard words)


viewKeywordsList : List String -> Html msg
viewKeywordsList listKeywords =
    List.map (\k -> li [] [ a [ href (Quizz k) ] [ text k ] ]) listKeywords
        |> ul []
