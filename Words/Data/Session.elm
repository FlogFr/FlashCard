module Data.Session exposing (Session, storeSession, deleteSession, decodeAuthSessionFromJson, retrieveSessionFromJson)

import Json.Encode as E
import Json.Decode as D
import Maybe exposing (withDefault)
import Ports exposing (..)
import API exposing (..)


type alias Session =
    { authToken : Maybe JWTToken
    , user : Maybe User
    }


encodeSession : Session -> E.Value
encodeSession session =
    case ( session.user, session.authToken ) of
        ( Just user, Just authToken ) ->
            E.object
                [ ( "user", encodeUser user )
                , ( "authToken", encodeJWTToken authToken )
                ]

        ( _, _ ) ->
            E.object
                []


storeSession : Session -> Cmd msg
storeSession session =
    encodeSession session
        |> E.encode 0
        |> Just
        |> Ports.storeSession


deleteSession : Cmd msg
deleteSession =
    Ports.deleteLocalStorage ()


decodeAuthToken : D.Decoder JWTToken
decodeAuthToken =
    D.map JWTToken
        (D.field "token" D.string)


decodeAuthSession : D.Decoder Session
decodeAuthSession =
    D.map2 Session
        (D.field "authToken" (D.nullable decodeAuthToken))
        (D.field "user" (D.nullable decodeUser))


decodeAuthSessionFromJson : E.Value -> Maybe Session
decodeAuthSessionFromJson json =
    json
        |> D.decodeValue D.string
        |> Result.toMaybe
        |> Maybe.andThen (D.decodeString decodeAuthSession >> Result.toMaybe)


retrieveSessionFromJson : E.Value -> Session
retrieveSessionFromJson json =
    decodeAuthSessionFromJson json
        |> withDefault (Session Nothing Nothing)
