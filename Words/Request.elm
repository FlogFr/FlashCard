module Request exposing (..)

import Data.Session exposing (..)
import API exposing (..)
import Http exposing (..)
import Base64


getUserRequest : String -> String -> Http.Request User
getUserRequest username password =
    let
        base64Authorization =
            Base64.encode (username ++ ":" ++ password)

        requestAuthHeader =
            Http.header "Authorization" ("Basic " ++ base64Authorization)
    in
        getUser [ requestAuthHeader ]


getUserCmd : (Result Error User -> msg) -> String -> String -> Cmd msg
getUserCmd msgType username password =
    Http.send msgType (getUserRequest username password)


getWordsLastRequest : AuthUser -> Http.Request (List Word)
getWordsLastRequest user =
    let
        base64Authorization =
            Base64.encode ((.username user) ++ ":" ++ (.userpassword user))

        requestAuthHeader =
            Http.header "Authorization" ("Basic " ++ base64Authorization)
    in
        getWordsLast [ requestAuthHeader ]


getWordsLastCmd : (Result Error (List Word) -> msg) -> Session -> Cmd msg
getWordsLastCmd msgType session =
    case session.user of
        Nothing ->
            Cmd.none

        Just user ->
            Http.send msgType (getWordsLastRequest user)


getWordsSearchRequest : AuthUser -> String -> Http.Request (List Word)
getWordsSearchRequest user searchWord =
    let
        base64Authorization =
            Base64.encode ((.username user) ++ ":" ++ (.userpassword user))

        requestAuthHeader =
            Http.header "Authorization" ("Basic " ++ base64Authorization)
    in
        getWordsSearchBySearchWord [ requestAuthHeader ] searchWord


getWordsSearchCmd : (Result Error (List Word) -> msg) -> Session -> String -> Cmd msg
getWordsSearchCmd msgType session searchWord =
    case session.user of
        Nothing ->
            Cmd.none

        Just user ->
            Http.send msgType (getWordsSearchRequest user searchWord)


getWordByIdRequest : AuthUser -> Int -> Http.Request Word
getWordByIdRequest user wordId =
    let
        base64Authorization =
            Base64.encode ((.username user) ++ ":" ++ (.userpassword user))

        requestAuthHeader =
            Http.header "Authorization" ("Basic " ++ base64Authorization)
    in
        getWordsIdByWordId [ requestAuthHeader ] wordId


deleteWordByIdRequest : AuthUser -> Int -> Http.Request NoContent
deleteWordByIdRequest user wordId =
    let
        base64Authorization =
            Base64.encode ((.username user) ++ ":" ++ (.userpassword user))

        requestAuthHeader =
            Http.header "Authorization" ("Basic " ++ base64Authorization)
    in
        deleteWordsIdByWordId [ requestAuthHeader ] wordId


getWordByIdCmd : (Result Error Word -> msg) -> AuthUser -> Int -> Cmd msg
getWordByIdCmd msgType authUser wordId =
    Http.send msgType (getWordByIdRequest authUser wordId)


putWordsIdByWordIdRequest : String -> String -> Word -> Http.Request Word
putWordsIdByWordIdRequest username password word =
    let
        base64Authorization =
            Base64.encode (username ++ ":" ++ password)

        requestAuthHeader =
            Http.header "Authorization" ("Basic " ++ base64Authorization)
    in
        putWordsIdByWordId [ requestAuthHeader ] (.wordId word) word


putWordsIdByWordIdCmd : (Result Error Word -> msg) -> Session -> Word -> Cmd msg
putWordsIdByWordIdCmd msgType session word =
    case session.user of
        Just user ->
            Http.send msgType (putWordsIdByWordIdRequest (.username user) (.userpassword user) word)

        Nothing ->
            Cmd.none


postWordRequest : String -> String -> Word -> Http.Request NoContent
postWordRequest username password word =
    let
        base64Authorization =
            Base64.encode (username ++ ":" ++ password)

        requestAuthHeader =
            Http.header "Authorization" ("Basic " ++ base64Authorization)
    in
        postWords [ requestAuthHeader ] word


postWordCmd : (Result Error NoContent -> msg) -> Session -> Word -> Cmd msg
postWordCmd msgType session word =
    case session.user of
        Just user ->
            Http.send msgType (postWordRequest (.username user) (.userpassword user) word)

        Nothing ->
            Cmd.none
