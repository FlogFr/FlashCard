-- This exposes functions to translate URLs in the browser's Location bar to
-- logical "pages" in the application, as well as functions to effect Location bar
-- changes.
--
-- Similarly to how Request modules never expose raw API URL strings, this module
-- never exposes raw Location bar URL strings either. Instead it exposes a union
-- type called Route which callers use to specify which page they want.


module Route exposing (Route(..), fromLocation, href, modifyUrl)

import Html.Styled as Html exposing (Attribute)
import Html.Styled.Attributes as Attr
import Navigation exposing (Location)
import UrlParser as Url exposing ((</>), Parser, oneOf, parseHash, s, string, int)
import Debug


-- ROUTING --


type Route
    = Login
    | Home
    | WordEdit Int
    | Quizz


route : Parser (Route -> a) a
route =
    oneOf
        [ Url.map Login (s "")
        , Url.map Home (s "home")
        , Url.map WordEdit (s "wordEdit" </> int)
        , Url.map Quizz (s "quizz")
        ]



-- INTERNAL --


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                Login ->
                    [ "" ]

                Home ->
                    [ "home" ]

                WordEdit wordId ->
                    [ "wordEdit", toString wordId ]

                Quizz ->
                    [ "quizz" ]
    in
        "#/" ++ String.join "/" pieces



-- PUBLIC HELPERS --


href : Route -> Attribute msg
href route =
    Attr.href (routeToString route)


modifyUrl : Route -> Cmd msg
modifyUrl =
    routeToString >> Navigation.modifyUrl


fromLocation : Location -> Maybe Route
fromLocation location =
    if String.isEmpty location.hash then
        Just Login
    else
        parseHash route location
