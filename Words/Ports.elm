port module Ports exposing (storeSession)

import Json.Encode exposing (Value)


port storeSession : Maybe String -> Cmd msg
