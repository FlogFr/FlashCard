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
    { id : Int
    , language : String
    , word : String
    , keywords : List String
    , definition : String
    , difficulty : Maybe Int
    }


encodeWord : Word -> Json.Encode.Value
encodeWord x =
    Json.Encode.object
        [ ( "id", Json.Encode.int x.id )
        , ( "language", Json.Encode.string x.language )
        , ( "word", Json.Encode.string x.word )
        , ( "keywords", (Json.Encode.list << List.map Json.Encode.string) x.keywords )
        , ( "definition", Json.Encode.string x.definition )
        , ( "difficulty", (Maybe.withDefault Json.Encode.null << Maybe.map Json.Encode.int) x.difficulty )
        ]


decodeWord : Decoder Word
decodeWord =
    decode Word
        |> required "id" int
        |> required "language" string
        |> required "word" string
        |> required "keywords" (list string)
        |> required "definition" string
        |> required "difficulty" (maybe int)


type alias User =
    { userid : Int
    , username : String
    , email : String
    , lang : String
    }


type alias FullUser =
    { userid : Int
    , username : String
    , password : String
    , email : String
    , lang : String
    }


type alias GrantUser =
    { username : String
    , password : String
    }


type alias NewUser =
    { username : String
    , password : String
    , email : String
    , language : String
    }


encodeUser : User -> Json.Encode.Value
encodeUser x =
    Json.Encode.object
        [ ( "id", Json.Encode.int x.userid )
        , ( "username", Json.Encode.string x.username )
        , ( "email", Json.Encode.string x.email )
        , ( "lang", Json.Encode.string x.lang )
        ]


encodeFullUser : FullUser -> Json.Encode.Value
encodeFullUser x =
    Json.Encode.object
        [ ( "id", Json.Encode.int x.userid )
        , ( "username", Json.Encode.string x.username )
        , ( "passpass", Json.Encode.string x.password )
        , ( "email", Json.Encode.string x.email )
        , ( "lang", Json.Encode.string x.lang )
        ]


encodeNewUser : NewUser -> Json.Encode.Value
encodeNewUser newUser =
    Json.Encode.object
        [ ( "username", Json.Encode.string (.username newUser) )
        , ( "password", Json.Encode.string (.password newUser) )
        , ( "email", Json.Encode.string (.email newUser) )
        , ( "lang", Json.Encode.string (.language newUser) )
        ]


encodeGrantUser : GrantUser -> Json.Encode.Value
encodeGrantUser grantUser =
    Json.Encode.object
        [ ( "username", Json.Encode.string (.username grantUser) )
        , ( "password", Json.Encode.string (.password grantUser) )
        ]


decodeUser : Decoder User
decodeUser =
    decode User
        |> required "id" int
        |> required "username" string
        |> required "email" string
        |> required "lang" string


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


updateUser : List Http.Header -> FullUser -> Http.Request User
updateUser headers fullUser =
    Http.request
        { method =
            "PUT"
        , headers =
            headers
        , url =
            String.join "/"
                [ "http://127.1:8080"
                , "user"
                ]
        , body =
            Http.jsonBody (encodeFullUser fullUser)
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


getWordsQuizz : List Http.Header -> String -> Http.Request (List Word)
getWordsQuizz headers keyword =
    Http.request
        { method =
            "GET"
        , headers =
            headers
        , url =
            String.join "/"
                [ "http://127.1:8080"
                , "words"
                , "quizz"
                , "keyword"
                , keyword |> Http.encodeUri
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


getWordsKeywords : List Http.Header -> Http.Request (List String)
getWordsKeywords headers =
    Http.request
        { method =
            "GET"
        , headers =
            headers
        , url =
            String.join "/"
                [ "http://127.1:8080"
                , "words"
                , "keywords"
                ]
        , body =
            Http.emptyBody
        , expect =
            Http.expectJson (list string)
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


getWordsSearchBySearchWord : List Http.Header -> String -> String -> Http.Request (List Word)
getWordsSearchBySearchWord headers searchWord searchKeyword =
    let
        queryParamsStr =
            case searchKeyword of
                "--" ->
                    "word=" ++ searchWord

                keyword ->
                    "word=" ++ searchWord ++ "&keyword=" ++ keyword

        queryParams =
            ("?" ++ queryParamsStr)
    in
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
                    , queryParams
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
