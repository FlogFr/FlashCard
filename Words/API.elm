module API exposing (..)

import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Json.Encode
import Http
import String


type alias JWTToken =
    { token : String }


encodeJWTToken : JWTToken -> Json.Encode.Value
encodeJWTToken x =
    Json.Encode.object
        [ ( "token", Json.Encode.string x.token )
        ]


type alias Word =
    { wordId : Int
    , wordLanguage : String
    , wordWord : String
    , wordKeywords : List String
    , wordDefinition : String
    , wordDifficulty : Maybe Int
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
    }


type alias GrantUser =
    { username : String
    , password : String
    }


type alias NewUser =
    { username : String
    , password : String
    , email : String
    }


encodeUser : User -> Json.Encode.Value
encodeUser x =
    Json.Encode.object
        [ ( "userid", Json.Encode.int x.userid )
        , ( "username", Json.Encode.string x.username )
        ]


encodeNewUser : NewUser -> Json.Encode.Value
encodeNewUser newUser =
    Json.Encode.object
        [ ( "newUsername", Json.Encode.string (.username newUser) )
        , ( "newPassword", Json.Encode.string (.password newUser) )
        , ( "newEmail", Json.Encode.string (.email newUser) )
        ]


encodeGrantUser : GrantUser -> Json.Encode.Value
encodeGrantUser grantUser =
    Json.Encode.object
        [ ( "grantUsername", Json.Encode.string (.username grantUser) )
        , ( "grantPassword", Json.Encode.string (.password grantUser) )
        ]


decodeUser : Decoder User
decodeUser =
    decode User
        |> required "userid" int
        |> required "username" string


decodeToken : Decoder String
decodeToken =
    field "token" string


decodeJWTToken : Decoder JWTToken
decodeJWTToken =
    decode JWTToken
        |> required "token" string


type NoContent
    = NoContent


getToken : Http.Request String
getToken =
    Http.request
        { method =
            "GET"
        , headers =
            []
        , url =
            String.join "/"
                [ "http://127.1:8080"
                , "auth"
                , "token"
                ]
        , body =
            Http.emptyBody
        , expect =
            Http.expectJson decodeToken
        , timeout =
            Nothing
        , withCredentials =
            False
        }


getJWTToken : GrantUser -> Http.Request JWTToken
getJWTToken grantUser =
    Http.request
        { method =
            "POST"
        , headers =
            []
        , url =
            String.join "/"
                [ "http://127.1:8080"
                , "auth"
                , "grant"
                ]
        , body =
            Http.jsonBody (encodeGrantUser grantUser)
        , expect =
            Http.expectJson decodeJWTToken
        , timeout =
            Nothing
        , withCredentials =
            False
        }


postNewUser : String -> NewUser -> Http.Request NoContent
postNewUser token newUser =
    Http.request
        { method =
            "POST"
        , headers =
            []
        , url =
            String.join "/"
                [ "http://127.1:8080"
                , "auth"
                , "create"
                , token
                ]
        , body =
            Http.jsonBody (encodeNewUser newUser)
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


getUser : List Http.Header -> Http.Request User
getUser headers =
    Http.request
        { method =
            "GET"
        , headers =
            headers
        , url =
            String.join "/"
                [ "http://127.1:8080"
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


getWordsAll : List Http.Header -> Http.Request (List Word)
getWordsAll headers =
    Http.request
        { method =
            "GET"
        , headers =
            headers
        , url =
            String.join "/"
                [ "http://127.1:8080"
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


getWordsLast : List Http.Header -> Http.Request (List Word)
getWordsLast headers =
    Http.request
        { method =
            "GET"
        , headers =
            headers
        , url =
            String.join "/"
                [ "http://127.1:8080"
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


getWordsSearchBySearchWord : List Http.Header -> String -> Http.Request (List Word)
getWordsSearchBySearchWord headers capture_searchWord =
    Http.request
        { method =
            "GET"
        , headers =
            headers
        , url =
            String.join "/"
                [ "http://127.1:8080"
                , "words"
                , "search"
                , capture_searchWord |> Http.encodeUri
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


getWordsIdByWordId : List Http.Header -> Int -> Http.Request Word
getWordsIdByWordId headers capture_wordId =
    Http.request
        { method =
            "GET"
        , headers =
            headers
        , url =
            String.join "/"
                [ "http://127.1:8080"
                , "words"
                , "id"
                , capture_wordId |> toString |> Http.encodeUri
                ]
        , body =
            Http.emptyBody
        , expect =
            Http.expectJson decodeWord
        , timeout =
            Nothing
        , withCredentials =
            False
        }


deleteWordsIdByWordId : List Http.Header -> Int -> Http.Request NoContent
deleteWordsIdByWordId headers capture_wordId =
    Http.request
        { method =
            "DELETE"
        , headers =
            headers
        , url =
            String.join "/"
                [ "http://127.1:8080"
                , "words"
                , "id"
                , capture_wordId |> toString |> Http.encodeUri
                ]
        , body =
            Http.emptyBody
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


putWordsIdByWordId : List Http.Header -> Int -> Word -> Http.Request Word
putWordsIdByWordId headers capture_wordId body =
    Http.request
        { method =
            "PUT"
        , headers =
            headers
        , url =
            String.join "/"
                [ "http://127.1:8080"
                , "words"
                , "id"
                , capture_wordId |> toString |> Http.encodeUri
                ]
        , body =
            Http.jsonBody (encodeWord body)
        , expect =
            Http.expectJson decodeWord
        , timeout =
            Nothing
        , withCredentials =
            False
        }


postWords : List Http.Header -> Word -> Http.Request NoContent
postWords headers body =
    Http.request
        { method =
            "POST"
        , headers =
            headers
        , url =
            String.join "/"
                [ "http://127.1:8080"
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
