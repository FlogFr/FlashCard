module Request exposing (getUserCmd, getWordsLastCmd, getWordsLastRequest, postWordCmd, postWordRequest, getWordByIdRequest, getWordByIdCmd)

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


getWordByIdRequest : AuthUser -> Int -> Http.Request Word
getWordByIdRequest user wordId =
    let
        base64Authorization =
            Base64.encode ((.username user) ++ ":" ++ (.userpassword user))

        requestAuthHeader =
            Http.header "Authorization" ("Basic " ++ base64Authorization)
    in
        getWordsIdByWordId [ requestAuthHeader ] wordId


getWordByIdCmd : (Result Error Word -> msg) -> AuthUser -> Int -> Cmd msg
getWordByIdCmd msgType authUser wordId =
    Http.send msgType (getWordByIdRequest authUser wordId)


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
