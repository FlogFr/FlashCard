module Page.Home exposing (Model, Msg(..), ExternalMsg(..), initialModel, view, update, init)

import Util exposing ((=>))
import API exposing (..)
import Request exposing (..)
import Task exposing (..)
import Http exposing (..)
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes exposing (..)
import Data.Session exposing (..)
import Route as Route exposing (Route(..), href)
import Views.Words exposing (..)
import Views.Forms exposing (..)
import Debug


-- MODEL --


type alias Model =
    { myLastWords : List Word
    , addWordLanguage : String
    , addWordWord : String
    , addWordDefinition : String
    , searchWord : String
    , searchWords : List Word
    }


initialModel : Model
initialModel =
    { myLastWords = []
    , addWordLanguage = "EN"
    , addWordWord = ""
    , addWordDefinition = ""
    , searchWord = ""
    , searchWords = []
    }


updateLastWords : Model -> List Word -> Model
updateLastWords model listWords =
    { model | myLastWords = listWords }


init : Session -> Task Http.Error (List Word)
init session =
    Http.toTask (getWordsLastRequest session)



-- View --


type Msg
    = TestMsg
    | HomeAddNewWord
    | TypeHomeLanguage String
    | TypeHomeWord String
    | TypeHomeDefinition String
    | UpdateSearchWord String
    | HomeSearchWord
    | HomeSearchWordFinished (Result Http.Error (List Word))
    | HomeAddNewWordFinished (Result Http.Error NoContent)
    | InitFinished (Result Http.Error (List Word))
    | LastWordsReqCompletedMsg (Result Http.Error (List Word))


type ExternalMsg
    = NoOp
    | ReloadPage
    | Logout


view : Model -> Html Msg
view model =
    div []
        [ a [ Route.href Route.Quizz ]
            [ text "take a super quizz" ]
        , div []
            [ h1 [] [ text "You want to add a word?" ]
            , viewFormAddWord HomeAddNewWord TypeHomeLanguage TypeHomeWord TypeHomeDefinition
            ]
        , div []
            [ h1 [] [ text "Search a particular word in your dict?" ]
            , viewFormSearchWord HomeSearchWord UpdateSearchWord
            , viewWordsTable model.searchWords
            ]
        , div []
            [ h1 [] [ text "Your last words of the week:" ]
            , viewWordsTable model.myLastWords
            ]
        ]



-- UPDATE --


update : Session -> Msg -> Model -> ( ( Model, Cmd Msg ), ExternalMsg )
update session msg model =
    case msg of
        TestMsg ->
            model
                => Cmd.none
                => NoOp

        HomeAddNewWord ->
            let
                httpCmd =
                    postWordCmd HomeAddNewWordFinished session (Word 0 (.addWordLanguage model) (.addWordWord model) [] (.addWordDefinition model) Nothing)
            in
                model
                    => Cmd.batch [ httpCmd ]
                    => NoOp

        HomeAddNewWordFinished (Ok _) ->
            model
                => Cmd.none
                => ReloadPage

        HomeAddNewWordFinished (Err httpError) ->
            case httpError of
                BadStatus httpResponse ->
                    model
                        => Cmd.none
                        => Logout

                _ ->
                    model
                        => Cmd.none
                        => NoOp

        TypeHomeLanguage newLanguage ->
            { model | addWordLanguage = newLanguage }
                => Cmd.none
                => NoOp

        TypeHomeWord newWord ->
            { model | addWordWord = newWord }
                => Cmd.none
                => NoOp

        TypeHomeDefinition newDefinition ->
            { model | addWordDefinition = newDefinition }
                => Cmd.none
                => NoOp

        LastWordsReqCompletedMsg (Ok listWords) ->
            { model | myLastWords = listWords }
                => Cmd.none
                => NoOp

        LastWordsReqCompletedMsg (Err httpError) ->
            case httpError of
                BadStatus httpResponse ->
                    model
                        => Cmd.none
                        => Logout

                _ ->
                    model
                        => Cmd.none
                        => NoOp

        InitFinished (Ok newLastWords) ->
            { model | myLastWords = newLastWords }
                => Cmd.none
                => NoOp

        InitFinished (Err httpError) ->
            case httpError of
                BadStatus httpResponse ->
                    model
                        => Cmd.none
                        => Logout

                _ ->
                    model
                        => Cmd.none
                        => NoOp

        UpdateSearchWord searchWord ->
            { model | searchWord = searchWord }
                => Cmd.none
                => NoOp

        HomeSearchWord ->
            model
                => getWordsSearchCmd HomeSearchWordFinished session (.searchWord model)
                => NoOp

        HomeSearchWordFinished (Ok listSearchWords) ->
            { model | searchWords = listSearchWords }
                => Cmd.none
                => NoOp

        HomeSearchWordFinished (Err httpError) ->
            case httpError of
                BadStatus httpResponse ->
                    model
                        => Cmd.none
                        => Logout

                _ ->
                    model
                        => Cmd.none
                        => NoOp
