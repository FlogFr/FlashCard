module Data.Session exposing (AuthUser, Session, storeSession, deleteSession, decodeAuthUserFromJson, decodeAuthSessionFromJson, retrieveSessionFromJson)

import Json.Encode as Encode exposing (Value)
import Json.Decode as Decode exposing (Decoder, nullable, string, int, list)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Maybe exposing (withDefault)
import Ports exposing (..)
import API exposing (..)
import Util exposing ((=>))


type alias AuthUser =
    { username : String
    , userpassword : String
    }


type alias Session =
    { authToken : Maybe JWTToken
    , user : Maybe AuthUser
    }


encodeAuthUser : AuthUser -> Encode.Value
encodeAuthUser x =
    Encode.object
        [ ( "username", Encode.string x.username )
        , ( "userpassword", Encode.string x.userpassword )
        ]


encodeSession : Session -> Encode.Value
encodeSession session =
    case ( session.user, session.authToken ) of
        ( Just authUser, Just authToken ) ->
            Encode.object
                [ ( "user", encodeAuthUser authUser )
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


decodeAuthUser : Decoder AuthUser
decodeAuthUser =
    decode AuthUser
        |> required "username" string
        |> required "userpassword" string


decodeAuthToken : Decoder JWTToken
decodeAuthToken =
    decode JWTToken
        |> required "token" string


decodeAuthSession : Decoder Session
decodeAuthSession =
    decode Session
        |> required "authToken" (nullable decodeAuthToken)
        |> required "user" (nullable decodeAuthUser)


decodeAuthUserFromJson : Encode.Value -> Maybe AuthUser
decodeAuthUserFromJson json =
    json
        |> Decode.decodeValue Decode.string
        |> Result.toMaybe
        |> Maybe.andThen (Decode.decodeString decodeAuthUser >> Result.toMaybe)


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
