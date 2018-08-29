module Request exposing (..)

import Data.Session exposing (..)
import API exposing (..)
import Http exposing (..)
import Base64
import Debug


getJWTTokenRequest : GrantUser -> Http.Request JWTToken
getJWTTokenRequest grantUser =
    getJWTToken grantUser


getUserRequest : JWTToken -> Http.Request User
getUserRequest jwtToken =
    let
        requestAuthHeader =
            Http.header "Authorization" (jwtToken.token)
    in
        getUser [ requestAuthHeader ]


getUserCmd : (Result Error User -> msg) -> JWTToken -> Cmd msg
getUserCmd msgType jwtToken =
    Http.send msgType (getUserRequest jwtToken)


updateUserRequest : Session -> FullUser -> Http.Request User
updateUserRequest session user =
    let
        jwtToken =
            case session.authToken of
                Just responseJwtToken ->
                    (.token responseJwtToken)

                Nothing ->
                    ""

        requestAuthHeader =
            Http.header "Authorization" jwtToken
    in
        updateUser [ requestAuthHeader ] user


getWordsKeywordsRequest : Session -> Http.Request (List String)
getWordsKeywordsRequest session =
    let
        jwtToken =
            case session.authToken of
                Just responseJwtToken ->
                    (.token responseJwtToken)

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
                Just responseJwtToken ->
                    (.token responseJwtToken)

                Nothing ->
                    ""

        requestAuthHeader =
            Http.header "Authorization" jwtToken
    in
        getWordsLast [ requestAuthHeader ]


getWordsSearchRequest : Session -> String -> String -> Http.Request (List Word)
getWordsSearchRequest session searchWord searchKeyword =
    let
        jwtToken =
            case session.authToken of
                Just responseJwtToken ->
                    (.token responseJwtToken)

                Nothing ->
                    ""

        requestAuthHeader =
            Http.header "Authorization" jwtToken
    in
        getWordsSearchBySearchWord [ requestAuthHeader ] searchWord searchKeyword


getWordsSearchCmd : (Result Error (List Word) -> msg) -> Session -> String -> String -> Cmd msg
getWordsSearchCmd msgType session searchWord searchKeyword =
    Http.send msgType (getWordsSearchRequest session searchWord searchKeyword)


getWordByIdRequest : Session -> Int -> Http.Request Word
getWordByIdRequest session wordId =
    let
        jwtToken =
            case session.authToken of
                Just responseJwtToken ->
                    (.token responseJwtToken)

                Nothing ->
                    ""

        requestAuthHeader =
            Http.header "Authorization" jwtToken
    in
        getWordsIdByWordId [ requestAuthHeader ] wordId


getWordsQuizzRequest : Session -> String -> Http.Request (List Word)
getWordsQuizzRequest session keyword =
    let
        jwtToken =
            case session.authToken of
                Just responseJwtToken ->
                    (.token responseJwtToken)

                Nothing ->
                    ""

        requestAuthHeader =
            Http.header "Authorization" jwtToken
    in
        getWordsQuizz [ requestAuthHeader ] keyword


postWordQuizzResponseRequest : Session -> Int -> String -> Http.Request (Maybe Bool)
postWordQuizzResponseRequest session wordId response =
    let
        jwtToken =
            case session.authToken of
                Just responseJwtToken ->
                    (.token responseJwtToken)

                Nothing ->
                    ""

        requestAuthHeader =
            Http.header "Authorization" jwtToken
    in
        postWordQuizzResponse [ requestAuthHeader ] wordId response


postWordQuizzResponseCmd :
    (Result Error (Maybe Bool) -> msg)
    -> Session
    -> Int
    -> String
    -> Cmd msg
postWordQuizzResponseCmd msgType session wordId wordResponse =
    Http.send msgType (postWordQuizzResponseRequest session wordId wordResponse)


deleteWordByIdRequest : Session -> Int -> Http.Request NoContent
deleteWordByIdRequest session wordId =
    let
        jwtToken =
            case session.authToken of
                Just responseJwtToken ->
                    (.token responseJwtToken)

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
                Just responseJwtToken ->
                    (.token responseJwtToken)

                Nothing ->
                    ""

        requestAuthHeader =
            Http.header "Authorization" jwtToken
    in
        putWordsIdByWordId [ requestAuthHeader ] (.id word) word


putWordsIdByWordIdCmd : (Result Error Word -> msg) -> Session -> Word -> Cmd msg
putWordsIdByWordIdCmd msgType session word =
    Http.send msgType (putWordsIdByWordIdRequest session word)


postWordRequest : Session -> Word -> Http.Request NoContent
postWordRequest session word =
    let
        jwtToken =
            case session.authToken of
                Just responseJwtToken ->
                    (.token responseJwtToken)

                Nothing ->
                    ""

        requestAuthHeader =
            Http.header "Authorization" jwtToken
    in
        postWords [ requestAuthHeader ] word


postWordCmd : (Result Error NoContent -> msg) -> Session -> Word -> Cmd msg
postWordCmd msgType session word =
    Http.send msgType (postWordRequest session word)
