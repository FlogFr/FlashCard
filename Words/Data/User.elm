module Data.User exposing (storeSession)

import Util exposing ((=>))
import Json.Decode.Pipeline exposing (decode, required, optional)
import Json.Decode as Decode exposing (Decoder, string, int, list)
import Json.Encode as Encode exposing (Value)
import Ports as Ports exposing (..)
import API exposing (..)


storeSession : User -> Cmd msg
storeSession user =
    userEncode user
        |> Encode.encode 0
        |> Just
        |> Ports.storeSession


userEncode : User -> Value
userEncode user =
    Encode.object
        [ "userid" => Encode.int user.userid
        , "username" => Encode.string user.username
        , "userpassword" => Encode.string user.userpassword
        ]
