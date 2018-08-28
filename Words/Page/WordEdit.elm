module Page.WordEdit exposing (Model, Msg(..), ExternalMsg(..), view, update, init, initialModel)

import API exposing (..)
import String
import Request exposing (..)
import Task exposing (..)
import Http exposing (..)
import Html as Html exposing (..)
import Html.Attributes exposing (..)
import Data.Session exposing (..)
import Route as Route exposing (Route(..), href)
import Views.Words exposing (..)
import Views.Forms exposing (..)


-- MODEL --


type alias Model =
    { word : Maybe Word
    , nbKeyword : Int
    }


initialModel : Model
initialModel =
    { word = Nothing
    , nbKeyword = 1
    }


init : Session -> Int -> Task Http.Error Word
init session wordId =
    Http.toTask (getWordByIdRequest session wordId)



-- View --


type Msg
    = TestMsg
    | IncreaseNbKeyword
    | RemoveKeyword Int
    | WordEditInitFinished (Result Http.Error Word)
    | UpdateWord Word
    | UpdateWordRequest
    | UpdateWordRequestFinished (Result Http.Error Word)


type ExternalMsg
    = NoOp
    | GoHome
    | Logout


view : Model -> Html Msg
view model =
    case model.word of
        Nothing ->
            div []
                [ p [] [ text "Loading the word…" ]
                ]

        Just word ->
            div []
                [ p [] [ text ("Word #" ++ String.fromInt (.id word)) ]
                , viewWordForm word model.nbKeyword IncreaseNbKeyword RemoveKeyword UpdateWord UpdateWordRequest
                ]



-- UPDATE --


update : Session -> Msg -> Model -> ( ( Model, Cmd Msg ), ExternalMsg )
update session msg model =
    case msg of
        TestMsg ->
            ( ( model
              , Cmd.none
              )
            , NoOp
            )

        IncreaseNbKeyword ->
            ( ( { model | nbKeyword = (model.nbKeyword + 1) }
              , Cmd.none
              )
            , NoOp
            )

        RemoveKeyword argIndexKeyword ->
            let
                removeKeyword word indexKeyword =
                    case word of
                        Just w ->
                            Just { w | keywords = ((List.take argIndexKeyword w.keywords) ++ (List.drop (argIndexKeyword + 1) w.keywords)) }

                        Nothing ->
                            word
            in
                ( ( { model
                        | nbKeyword = (model.nbKeyword - 1)
                        , word = removeKeyword model.word argIndexKeyword
                    }
                  , Cmd.none
                  )
                , NoOp
                )

        UpdateWord newWord ->
            ( ( { model | word = Just newWord }
              , Cmd.none
              )
            , NoOp
            )

        WordEditInitFinished (Err httpError) ->
            case httpError of
                BadStatus httpResponse ->
                    ( ( model
                      , Cmd.none
                      )
                    , Logout
                    )

                _ ->
                    ( ( model
                      , Cmd.none
                      )
                    , NoOp
                    )

        WordEditInitFinished (Ok word) ->
            ( ( { model | word = Just word, nbKeyword = (List.length word.keywords + 1) }
              , Cmd.none
              )
            , NoOp
            )

        UpdateWordRequest ->
            case model.word of
                Nothing ->
                    ( ( model
                      , Cmd.none
                      )
                    , NoOp
                    )

                Just word ->
                    ( ( model
                      , putWordsIdByWordIdCmd UpdateWordRequestFinished session word
                      )
                    , NoOp
                    )

        UpdateWordRequestFinished (Ok word) ->
            ( ( { model | word = Just word }
              , Cmd.none
              )
            , GoHome
            )

        UpdateWordRequestFinished (Err httpError) ->
            case httpError of
                BadStatus httpResponse ->
                    ( ( model
                      , Cmd.none
                      )
                    , Logout
                    )

                _ ->
                    ( ( model
                      , Cmd.none
                      )
                    , NoOp
                    )
