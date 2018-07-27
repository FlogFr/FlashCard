module Data.Session exposing (Session)

import API exposing (User)
import Util exposing ((=>))


type alias Session =
    { user : Maybe User }
