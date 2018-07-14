module Generated.MyAPI exposing (..)

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

decodeWord : Decoder Word
decodeWord =
    decode Word
        |> required "wordId" int
        |> required "wordLanguage" string
        |> required "wordWord" string
        |> required "wordKeywords" (list string)
        |> required "wordDefinition" string
        |> required "wordDifficulty" (maybe int)

get : Http.Request (List (Word))
get =
    Http.request
        { method =
            "GET"
        , headers =
            []
        , url =
            String.join "/"
                [ ""
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

post : Word -> Http.Request (NoContent)
post body =
    Http.request
        { method =
            "POST"
        , headers =
            []
        , url =
            String.join "/"
                [ ""
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