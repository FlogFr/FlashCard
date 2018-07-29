module Data.Session exposing (AuthUser, Session, decodeAuthUserFromJson)

import Json.Decode as Decode exposing (Value)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import API exposing (User)
import Util exposing ((=>))


type alias AuthUser =
    { userid : Int
    , username : String
    , userpassword : String
    }


type alias Session =
    { user : Maybe AuthUser }


decodeAuthUser : Decoder AuthUser
decodeAuthUser =
    decode AuthUser
        |> required "userid" int
        |> required "username" string
        |> required "userpassword" string


decodeAuthUserFromJson : Value -> Maybe AuthUser
decodeAuthUserFromJson json =
    json
        |> Decode.decodeValue Decode.string
        |> Result.toMaybe
        |> Maybe.andThen (Decode.decodeString decodeAuthUser >> Result.toMaybe)
