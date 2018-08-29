module API exposing (..)

import Json.Decode as D
import Json.Encode as E
import Http
import String


type alias JWTToken =
    { token : String }


encodeJWTToken : JWTToken -> E.Value
encodeJWTToken x =
    E.object
        [ ( "token", E.string x.token )
        ]


type alias Word =
    { id : Int
    , language : String
    , word : String
    , keywords : List String
    , definition : String
    , difficulty : Maybe Int
    }


encodeWord : Word -> E.Value
encodeWord x =
    E.object
        [ ( "id", E.int x.id )
        , ( "language", E.string x.language )
        , ( "word", E.string x.word )
        , ( "keywords", (E.list E.string) x.keywords )
        , ( "definition", E.string x.definition )
        , ( "difficulty", (Maybe.withDefault E.null << Maybe.map E.int) x.difficulty )
        ]


decodeWord : D.Decoder Word
decodeWord =
    D.map6 Word
        (D.field "id" D.int)
        (D.field "language" D.string)
        (D.field "word" D.string)
        (D.field "keywords" (D.list D.string))
        (D.field "definition" D.string)
        (D.field "difficulty" (D.nullable D.int))


type alias User =
    { userid : Int
    , username : String
    , email : Maybe String
    , languages : List String
    }


type alias FullUser =
    { userid : Int
    , username : String
    , password : String
    , email : Maybe String
    , languages : List String
    }


type alias GrantUser =
    { username : String
    , password : String
    }


type alias NewUser =
    { username : String
    , password : String
    , email : Maybe String
    , languages : List String
    }


encodeUser : User -> E.Value
encodeUser x =
    E.object
        [ ( "id", E.int x.userid )
        , ( "username", E.string x.username )
        , ( "email", (Maybe.withDefault E.null << Maybe.map E.string) x.email )
        , ( "languages", (E.list E.string) x.languages )
        ]


encodeFullUser : FullUser -> E.Value
encodeFullUser x =
    E.object
        [ ( "id", E.int x.userid )
        , ( "username", E.string x.username )
        , ( "passpass", E.string x.password )
        , ( "email", (Maybe.withDefault E.null << Maybe.map E.string) x.email )
        , ( "languages", (E.list E.string) x.languages )
        ]


encodeNewUser : NewUser -> E.Value
encodeNewUser x =
    E.object
        [ ( "username", E.string x.username )
        , ( "password", E.string x.password )
        , ( "email", (Maybe.withDefault E.null << Maybe.map E.string) x.email )
        , ( "languages", (E.list E.string) x.languages )
        ]


encodeGrantUser : GrantUser -> E.Value
encodeGrantUser grantUser =
    E.object
        [ ( "username", E.string (.username grantUser) )
        , ( "password", E.string (.password grantUser) )
        ]


decodeUser : D.Decoder User
decodeUser =
    D.map4 User
        (D.field "id" D.int)
        (D.field "username" D.string)
        (D.field "email" (D.nullable D.string))
        (D.field "languages" (D.list D.string))


decodeToken : D.Decoder String
decodeToken =
    D.field "token" D.string


decodeJWTToken : D.Decoder JWTToken
decodeJWTToken =
    D.map JWTToken
        (D.field "token" D.string)


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
            Http.expectJson (D.list decodeWord)
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
                , keyword
                ]
        , body =
            Http.emptyBody
        , expect =
            Http.expectJson (D.list decodeWord)
        , timeout =
            Nothing
        , withCredentials =
            False
        }


postWordQuizzResponse : List Http.Header -> Int -> String -> Http.Request (Maybe Bool)
postWordQuizzResponse headers wordId response =
    Http.request
        { method =
            "POST"
        , headers =
            headers
        , url =
            String.join "/"
                [ "http://127.1:8080"
                , "words"
                , "quizz"
                , "response"
                , String.fromInt wordId
                ]
        , body =
            Http.jsonBody (E.string response)
        , expect =
            Http.expectJson (D.nullable D.bool)
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
            Http.expectJson (D.list D.string)
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
            Http.expectJson (D.list decodeWord)
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
                Http.expectJson (D.list decodeWord)
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
                , capture_wordId |> String.fromInt
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
                , capture_wordId |> String.fromInt
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
                , capture_wordId |> String.fromInt
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
postWords headers argBody =
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
            Http.jsonBody (encodeWord argBody)
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
