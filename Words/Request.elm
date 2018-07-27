module Request exposing (getUserCmd, getWordsLastCmd, getWordsLastRequest)

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


getWordsLastRequest : User -> Http.Request (List Word)
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
