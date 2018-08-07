module Data.Message exposing (..)


type Criticity
    = Debug
    | Warning
    | Error


type Message
    = Message Criticity String
