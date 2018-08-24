module Data.Session exposing (Session, storeSession, deleteSession, decodeAuthSessionFromJson, retrieveSessionFromJson)

import Json.Encode as Encode exposing (Value)
import Json.Decode as Decode exposing (Decoder, nullable, string, int, list)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Maybe exposing (withDefault)
import Ports exposing (..)
import API exposing (..)
import Util exposing ((=>))


type alias Session =
    { authToken : Maybe JWTToken
    , user : Maybe User
    }


encodeSession : Session -> Encode.Value
encodeSession session =
    case ( session.user, session.authToken ) of
        ( Just user, Just authToken ) ->
            Encode.object
                [ ( "user", encodeUser user )
                , ( "authToken", encodeJWTToken authToken )
                ]

        ( _, _ ) ->
            Encode.object
                []


storeSession : Session -> Cmd msg
storeSession session =
    encodeSession session
        |> Encode.encode 0
        |> Just
        |> Ports.storeSession


deleteSession : Cmd msg
deleteSession =
    Ports.deleteLocalStorage ()


decodeAuthToken : Decoder JWTToken
decodeAuthToken =
    decode JWTToken
        |> required "token" string


decodeAuthSession : Decoder Session
decodeAuthSession =
    decode Session
        |> required "authToken" (nullable decodeAuthToken)
        |> required "user" (nullable decodeUser)


decodeAuthSessionFromJson : Encode.Value -> Maybe Session
decodeAuthSessionFromJson json =
    json
        |> Decode.decodeValue Decode.string
        |> Result.toMaybe
        |> Maybe.andThen (Decode.decodeString decodeAuthSession >> Result.toMaybe)


retrieveSessionFromJson : Encode.Value -> Session
retrieveSessionFromJson json =
    decodeAuthSessionFromJson json
        |> withDefault (Session Nothing Nothing)
