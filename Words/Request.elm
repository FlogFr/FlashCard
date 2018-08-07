module Request exposing (..)

import Data.Session exposing (..)
import API exposing (..)
import Http exposing (..)
import Base64
import Debug


getJWTTokenRequest : GrantUser -> Http.Request JWTToken
getJWTTokenRequest grantUser =
    getJWTToken grantUser


getUserRequest : Session -> Http.Request User
getUserRequest session =
    let
        jwtToken =
            case session.authToken of
                Just jwtToken ->
                    (.token jwtToken)

                Nothing ->
                    ""

        requestAuthHeader =
            Http.header "Authorization" jwtToken
    in
        getUser [ requestAuthHeader ]


getUserCmd : (Result Error User -> msg) -> Session -> Cmd msg
getUserCmd msgType session =
    Http.send msgType (getUserRequest session)


getWordsKeywordsRequest : Session -> Http.Request (List String)
getWordsKeywordsRequest session =
    let
        jwtToken =
            case session.authToken of
                Just jwtToken ->
                    (.token jwtToken)

                Nothing ->
                    ""

        requestAuthHeader =
            Http.header "Authorization" jwtToken
    in
        getWordsKeywords [ requestAuthHeader ]


getWordsLastRequest : Session -> Http.Request (List Word)
getWordsLastRequest session =
    let
        jwtToken =
            case session.authToken of
                Just jwtToken ->
                    (.token jwtToken)

                Nothing ->
                    ""

        requestAuthHeader =
            Http.header "Authorization" jwtToken
    in
        getWordsLast [ requestAuthHeader ]


getWordsSearchRequest : Session -> String -> Http.Request (List Word)
getWordsSearchRequest session searchWord =
    let
        jwtToken =
            case session.authToken of
                Just jwtToken ->
                    (.token jwtToken)

                Nothing ->
                    ""

        requestAuthHeader =
            Http.header "Authorization" jwtToken
    in
        getWordsSearchBySearchWord [ requestAuthHeader ] searchWord


getWordsSearchCmd : (Result Error (List Word) -> msg) -> Session -> String -> Cmd msg
getWordsSearchCmd msgType session searchWord =
    Http.send msgType (getWordsSearchRequest session searchWord)


getWordByIdRequest : Session -> Int -> Http.Request Word
getWordByIdRequest session wordId =
    let
        jwtToken =
            case session.authToken of
                Just jwtToken ->
                    (.token jwtToken)

                Nothing ->
                    ""

        requestAuthHeader =
            Http.header "Authorization" jwtToken
    in
        getWordsIdByWordId [ requestAuthHeader ] wordId


deleteWordByIdRequest : Session -> Int -> Http.Request NoContent
deleteWordByIdRequest session wordId =
    let
        jwtToken =
            case session.authToken of
                Just jwtToken ->
                    (.token jwtToken)

                Nothing ->
                    ""

        requestAuthHeader =
            Http.header "Authorization" jwtToken
    in
        deleteWordsIdByWordId [ requestAuthHeader ] wordId


getWordByIdCmd : (Result Error Word -> msg) -> Session -> Int -> Cmd msg
getWordByIdCmd msgType session wordId =
    Http.send msgType (getWordByIdRequest session wordId)


putWordsIdByWordIdRequest : Session -> Word -> Http.Request Word
putWordsIdByWordIdRequest session word =
    let
        jwtToken =
            case session.authToken of
                Just jwtToken ->
                    (.token jwtToken)

                Nothing ->
                    ""

        requestAuthHeader =
            Http.header "Authorization" jwtToken
    in
        putWordsIdByWordId [ requestAuthHeader ] (.wordId word) word


putWordsIdByWordIdCmd : (Result Error Word -> msg) -> Session -> Word -> Cmd msg
putWordsIdByWordIdCmd msgType session word =
    Http.send msgType (putWordsIdByWordIdRequest session word)


postWordRequest : Session -> Word -> Http.Request NoContent
postWordRequest session word =
    let
        jwtToken =
            case session.authToken of
                Just jwtToken ->
                    (.token jwtToken)

                Nothing ->
                    ""

        requestAuthHeader =
            Http.header "Authorization" jwtToken
    in
        postWords [ requestAuthHeader ] word


postWordCmd : (Result Error NoContent -> msg) -> Session -> Word -> Cmd msg
postWordCmd msgType session word =
    Http.send msgType (postWordRequest session word)
