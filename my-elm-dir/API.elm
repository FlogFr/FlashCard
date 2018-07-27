module API exposing (..)

import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Json.Encode
import Http
import String


type alias Word =
    { wordId : Int
    , wordLanguage : String
    , wordWord : String
    , wordKeywords : List (String)
    , wordDefinition : String
    , wordDifficulty : Maybe (Int)
    }

encodeWord : Word -> Json.Encode.Value
encodeWord x =
    Json.Encode.object
        [ ( "wordId", Json.Encode.int x.wordId )
        , ( "wordLanguage", Json.Encode.string x.wordLanguage )
        , ( "wordWord", Json.Encode.string x.wordWord )
        , ( "wordKeywords", (Json.Encode.list << List.map Json.Encode.string) x.wordKeywords )
        , ( "wordDefinition", Json.Encode.string x.wordDefinition )
        , ( "wordDifficulty", (Maybe.withDefault Json.Encode.null << Maybe.map Json.Encode.int) x.wordDifficulty )
        ]

decodeWord : Decoder Word
decodeWord =
    decode Word
        |> required "wordId" int
        |> required "wordLanguage" string
        |> required "wordWord" string
        |> required "wordKeywords" (list string)
        |> required "wordDefinition" string
        |> required "wordDifficulty" (maybe int)

type alias User =
    { userid : Int
    , username : String
    , userpassword : String
    }

decodeUser : Decoder User
decodeUser =
    decode User
        |> required "userid" int
        |> required "username" string
        |> required "userpassword" string

type NoContent
    = NoContent

getUser : Http.Request (User)
getUser =
    Http.request
        { method =
            "GET"
        , headers =
            []
        , url =
            String.join "/"
                [ ""
                , "user"
                ]
        , body =
            Http.emptyBody
        , expect =
            Http.expectJson decodeUser
        , timeout =
            Nothing
        , withCredentials =
            False
        }

getWordsAll : Http.Request (List (Word))
getWordsAll =
    Http.request
        { method =
            "GET"
        , headers =
            []
        , url =
            String.join "/"
                [ ""
                , "words"
                , "all"
                ]
        , body =
            Http.emptyBody
        , expect =
            Http.expectJson (list decodeWord)
        , timeout =
            Nothing
        , withCredentials =
            False
        }

getWordsLast : Http.Request (List (Word))
getWordsLast =
    Http.request
        { method =
            "GET"
        , headers =
            []
        , url =
            String.join "/"
                [ ""
                , "words"
                , "last"
                ]
        , body =
            Http.emptyBody
        , expect =
            Http.expectJson (list decodeWord)
        , timeout =
            Nothing
        , withCredentials =
            False
        }

postWords : Word -> Http.Request (NoContent)
postWords body =
    Http.request
        { method =
            "POST"
        , headers =
            []
        , url =
            String.join "/"
                [ ""
                , "words"
                ]
        , body =
            Http.jsonBody (encodeWord body)
        , expect =
            Http.expectStringResponse
                (\{ body } ->
                    if String.isEmpty body then
                        Ok NoContent
                    else
                        Err "Expected the response body to be empty"
                )
        , timeout =
            Nothing
        , withCredentials =
            False
        }