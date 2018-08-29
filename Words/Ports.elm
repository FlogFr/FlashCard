port module Ports exposing (storeSession, deleteLocalStorage)

import Json.Encode exposing (Value)


-- Session


port storeSession : Maybe String -> Cmd msg


port deleteLocalStorage : () -> Cmd msg
