module Page.Home exposing (Model, InitModel, Msg(..), ExternalMsg(..), initialModel, view, update, init)

import API exposing (..)
import Request exposing (..)
import Task exposing (..)
import Http exposing (..)
import Html as Html exposing (..)
import Html.Attributes exposing (..)
import Page.Errored exposing (..)
import Data.Session exposing (..)
import Route as Route exposing (Route(..), href)
import Views.Words exposing (..)
import Views.Forms exposing (..)


-- MODEL --


type InitModel
    = InitModel (List Word) (List String)


type alias Model =
    { myLastWords : List Word
    , keywords : List String
    , addWordLanguage : String
    , addWordWord : String
    , addWordDefinition : String
    , searchWord : String
    , searchKeyword : String
    , searchWords : List Word
    }


initialModel : Session -> Model
initialModel session =
    let
        initialLanguage =
            case session.user of
                Just user ->
                    case (List.head user.languages) of
                        Just firstLang ->
                            firstLang

                        Nothing ->
                            "EN"

                Nothing ->
                    "EN"
    in
        { myLastWords = []
        , keywords = []
        , addWordLanguage = initialLanguage
        , addWordWord = ""
        , addWordDefinition = ""
        , searchWord = ""
        , searchKeyword = "--"
        , searchWords = []
        }


updateLastWords : Model -> List Word -> Model
updateLastWords model listWords =
    { model | myLastWords = listWords }


init : Session -> Task Page.Errored.PageLoadError InitModel
init session =
    let
        loadLastWords =
            Http.toTask (getWordsLastRequest session)

        loadKeywords =
            Http.toTask (getWordsKeywordsRequest session)

        handleLoadError _ =
            PageLoadError
    in
        Task.map2 InitModel loadLastWords loadKeywords
            |> Task.mapError handleLoadError



-- View --


type Msg
    = TestMsg
    | HomeAddNewWord
    | TypeHomeLanguage String
    | TypeHomeWord String
    | TypeHomeDefinition String
    | UpdateSearchWord String
    | UpdateSearchKeyword String
    | HomeSearchWord
    | HomeSearchWordFinished (Result Http.Error (List Word))
    | HomeAddNewWordFinished (Result Http.Error NoContent)
    | InitFinished (Result PageLoadError InitModel)
    | LastWordsReqCompletedMsg (Result Http.Error (List Word))


type ExternalMsg
    = NoOp
    | ReloadPage
    | Logout


view : Model -> Session -> Html Msg
view model session =
    let
        myLangs =
            case session.user of
                Just user ->
                    user.languages

                Nothing ->
                    [ "EN", "FR" ]
    in
        div []
            [ div []
                [ h1 [] [ text "You want to add a word?" ]
                , div [ class "form-div" ] [ viewFormAddWord myLangs HomeAddNewWord TypeHomeLanguage TypeHomeWord TypeHomeDefinition ]
                ]
            , div []
                [ h1 [] [ text "Take a quizz" ]
                , div [ class "quizz-container-links" ] (List.map (\l -> a [ href (Route.Quizz l) ] [ text l ]) (myLangs))
                ]
            , div []
                [ h1 [] [ text "Search a particular word in your dict?" ]
                , div [ class "form-div" ]
                    [ viewFormSearchWord (.keywords model)
                        HomeSearchWord
                        UpdateSearchWord
                        UpdateSearchKeyword
                    ]
                , viewWordsTable model.searchWords
                ]
            , div []
                [ h1 [] [ text "Your last words of the week:" ]
                , div [ class "container-cards" ] (viewWordsCards model.myLastWords)
                ]
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

        HomeAddNewWord ->
            let
                httpCmd =
                    postWordCmd HomeAddNewWordFinished session (Word 0 (.addWordLanguage model) (.addWordWord model) [] (.addWordDefinition model) Nothing)
            in
                ( ( model
                  , Cmd.batch [ httpCmd ]
                  )
                , NoOp
                )

        HomeAddNewWordFinished (Ok _) ->
            ( ( model
              , Cmd.none
              )
            , ReloadPage
            )

        HomeAddNewWordFinished (Err httpError) ->
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

        TypeHomeLanguage newLanguage ->
            ( ( { model | addWordLanguage = newLanguage }
              , Cmd.none
              )
            , NoOp
            )

        TypeHomeWord newWord ->
            ( ( { model | addWordWord = newWord }
              , Cmd.none
              )
            , NoOp
            )

        TypeHomeDefinition newDefinition ->
            ( ( { model | addWordDefinition = newDefinition }
              , Cmd.none
              )
            , NoOp
            )

        LastWordsReqCompletedMsg (Ok listWords) ->
            ( ( { model | myLastWords = listWords }
              , Cmd.none
              )
            , NoOp
            )

        LastWordsReqCompletedMsg (Err httpError) ->
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

        InitFinished (Ok (InitModel lastWords keywords)) ->
            ( ( { model | myLastWords = lastWords, keywords = keywords }
              , Cmd.none
              )
            , NoOp
            )

        InitFinished (Err pageLoadError) ->
            ( ( model
              , Cmd.none
              )
            , Logout
            )

        UpdateSearchWord newSearchWord ->
            ( ( { model | searchWord = newSearchWord }
              , Cmd.none
              )
            , NoOp
            )

        UpdateSearchKeyword newSearchKeyword ->
            ( ( { model | searchKeyword = newSearchKeyword }
              , Cmd.none
              )
            , NoOp
            )

        HomeSearchWord ->
            ( ( model
              , getWordsSearchCmd HomeSearchWordFinished session (.searchWord model) (.searchKeyword model)
              )
            , NoOp
            )

        HomeSearchWordFinished (Ok listSearchWords) ->
            ( ( { model | searchWords = listSearchWords }
              , Cmd.none
              )
            , NoOp
            )

        HomeSearchWordFinished (Err httpError) ->
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
