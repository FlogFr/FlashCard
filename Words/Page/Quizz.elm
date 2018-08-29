module Page.Quizz exposing (Model, Msg(..), ExternalMsg(..), initialModel, view, init, update)

import Http
import Random
import Time
import Process
import Task exposing (..)
import Html as Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Route exposing (Route(..), href)
import Data.Session exposing (..)
import Views.Words exposing (..)
import Request exposing (..)
import API exposing (..)


-- MODEL --


type alias Model =
    { errors : List String
    , keyword : String
    , words : List Word
    , word : Maybe ( Word, Maybe Bool )
    , wordResponse : String
    }


initialModel : String -> Model
initialModel keyWord =
    { errors = []
    , words = []
    , word = Nothing
    , wordResponse = ""
    , keyword = keyWord
    }


init : Session -> String -> Task Http.Error (List Word)
init session keyword =
    Http.toTask (getWordsQuizzRequest session keyword)



-- View --


type Msg
    = TestMsg
    | QuizzInitFinished (Result Http.Error (List Word))
    | QuizzReInit
    | QuizzReInitFinished (Result Http.Error (List Word))
    | TakeQuizz
    | TakeQuizzNb Int
    | TakeQuizzUpdateResponse String
    | TakeQuizzAttempt
    | TakeQuizzResponse (Result Http.Error (Maybe Bool))


type ExternalMsg
    = NoOp



-- Helper --


boolToColor : Bool -> String
boolToColor boo =
    case boo of
        True ->
            "green"

        False ->
            "red"


delay : Float -> msg -> Cmd msg
delay timeout msg =
    Process.sleep timeout
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity


view : Model -> Html Msg
view model =
    case model.word of
        Just ( quizzWord, maybeVerified ) ->
            let
                color =
                    Maybe.withDefault "black" (Maybe.map boolToColor maybeVerified)
            in
                case maybeVerified of
                    Just _ ->
                        div []
                            [ div [ class "container-quizz-buttons" ]
                                [ a [ onClick QuizzReInit ] [ span [ class "icon-arrows-cw" ] [] ]
                                ]
                            , h2 [ style "color" color ] [ text "The word to find:" ]
                            , div [ class "container-cards" ] [ viewWordCard quizzWord ]
                            ]

                    Nothing ->
                        div []
                            [ div [ class "container-quizz-buttons" ]
                                [ a [ onClick QuizzReInit ] [ span [ class "icon-arrows-cw" ] [] ]
                                ]
                            , h2 [ style "color" color ] [ text "The word to find:" ]
                            , div [ class "container-cards" ] [ viewWordCardForm quizzWord TakeQuizzUpdateResponse TakeQuizzAttempt ]
                            ]

        Nothing ->
            div []
                [ div [ class "container-quizz-buttons" ]
                    [ a [ onClick QuizzReInit ] [ span [ class "icon-arrows-cw" ] [] ]
                    , a [ onClick TakeQuizz ] [ span [ class "icon-play-circled" ] [] ]
                    ]
                , h2 [] [ text "My words for the quizz:" ]
                , div [ class "container-cards" ] (viewWordsCards (.words model))
                ]


update : Session -> Msg -> Model -> ( ( Model, Cmd Msg ), ExternalMsg )
update session msg model =
    case msg of
        QuizzReInit ->
            ( ( { model | word = Nothing, wordResponse = "" }
              , Task.attempt QuizzReInitFinished (init session model.keyword)
              )
            , NoOp
            )

        QuizzInitFinished (Ok listWords) ->
            ( ( { model | words = listWords }
              , Cmd.none
              )
            , NoOp
            )

        QuizzInitFinished (Err _) ->
            ( ( model
              , Cmd.none
              )
            , NoOp
            )

        QuizzReInitFinished (Ok listWords) ->
            ( ( { model | words = listWords, word = Nothing, wordResponse = "" }
              , Cmd.none
              )
            , NoOp
            )

        QuizzReInitFinished (Err _) ->
            ( ( model
              , Cmd.none
              )
            , NoOp
            )

        TakeQuizz ->
            ( ( model
              , Random.generate TakeQuizzNb (Random.int 0 (List.length model.words))
              )
            , NoOp
            )

        TakeQuizzNb randomInt ->
            let
                randomWord =
                    List.head (List.drop randomInt model.words)
            in
                ( ( { model | word = (Maybe.map (\w -> ( w, Nothing )) randomWord) }
                  , Cmd.none
                  )
                , NoOp
                )

        TakeQuizzUpdateResponse newReponse ->
            ( ( { model | wordResponse = newReponse }
              , Cmd.none
              )
            , NoOp
            )

        TakeQuizzAttempt ->
            let
                wordId =
                    case model.word of
                        Just ( theWord, _ ) ->
                            theWord.id

                        Nothing ->
                            0
            in
                ( ( model
                  , postWordQuizzResponseCmd TakeQuizzResponse session wordId model.wordResponse
                  )
                , NoOp
                )

        TakeQuizzResponse (Ok maybeVerified) ->
            let
                newWord =
                    case model.word of
                        Just ( theWord, _ ) ->
                            Just ( theWord, maybeVerified )

                        Nothing ->
                            Nothing
            in
                ( ( { model | word = newWord }
                  , delay 4000 QuizzReInit
                  )
                , NoOp
                )

        TakeQuizzResponse (Err _) ->
            ( ( model
              , Task.attempt QuizzReInitFinished (init session model.keyword)
              )
            , NoOp
            )

        TestMsg ->
            ( ( model
              , Cmd.none
              )
            , NoOp
            )
