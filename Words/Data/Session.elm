module Data.Session exposing (AuthUser, Session, storeSession, deleteSession, decodeAuthUserFromJson)

import Json.Encode as Encode exposing (Value)
import Json.Decode as Decode exposing (Decoder, string, int, list)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Ports exposing (..)
import API exposing (User)
import Util exposing ((=>))


type alias AuthUser =
    { userid : Int
    , username : String
    , userpassword : String
    }


type alias Session =
    { user : Maybe AuthUser }


encodeAuthUser : AuthUser -> Encode.Value
encodeAuthUser x =
    Encode.object
        [ ( "userid", Encode.int x.userid )
        , ( "username", Encode.string x.username )
        , ( "userpassword", Encode.string x.userpassword )
        ]


storeSession : AuthUser -> Cmd msg
storeSession authUser =
    encodeAuthUser authUser
        |> Encode.encode 0
        |> Just
        |> Ports.storeSession


deleteSession : Cmd msg
deleteSession =
    Ports.deleteLocalStorage ()


decodeAuthUser : Decoder AuthUser
decodeAuthUser =
    decode AuthUser
        |> required "userid" int
        |> required "username" string
        |> required "userpassword" string


decodeAuthUserFromJson : Encode.Value -> Maybe AuthUser
decodeAuthUserFromJson json =
    json
        |> Decode.decodeValue Decode.string
        |> Result.toMaybe
        |> Maybe.andThen (Decode.decodeString decodeAuthUser >> Result.toMaybe)
