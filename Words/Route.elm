-- This exposes functions to translate URLs in the browser's Location bar to
-- logical "pages" in the application, as well as functions to effect Location bar
-- changes.
--
-- Similarly to how Request modules never expose raw API URL strings, this module
-- never exposes raw Location bar URL strings either. Instead it exposes a union
-- type called Route which callers use to specify which page they want.


module Route exposing (Route(..), route, fromUrl, href, modifyUrl, locationHrefToRoute)

import Html as Html exposing (Attribute)
import Html.Attributes as Attr
import Browser.Navigation
import String
import Ports
import Url exposing (Url, fromString)
import Url.Parser exposing (Parser, (</>), map, parse, oneOf, top, s, string, int)


-- ROUTING --


type Route
    = Login
    | Logout
    | Register
    | ProfileEdit
    | Home
    | WordEdit Int
    | WordDelete Int
    | Quizz String


route : Parser (Route -> a) a
route =
    oneOf
        [ map Login top
        , map Logout (s "logout")
        , map Register (s "register")
        , map ProfileEdit (s "profile")
        , map Home (s "home")
        , map WordEdit (s "wordEdit" </> int)
        , map WordDelete (s "wordDelete" </> int)
        , map Quizz (s "quizz" </> string)
        ]



-- INTERNAL --


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                Login ->
                    [ "" ]

                Logout ->
                    [ "logout" ]

                Register ->
                    [ "register" ]

                ProfileEdit ->
                    [ "profile" ]

                Home ->
                    [ "home" ]

                WordEdit wordId ->
                    [ "wordEdit", String.fromInt wordId ]

                WordDelete wordId ->
                    [ "wordDelete", String.fromInt wordId ]

                Quizz keywordQuizz ->
                    [ "quizz", keywordQuizz ]
    in
        String.join "/" pieces



-- PUBLIC HELPERS --


href : Route -> Attribute msg
href argRoute =
    Attr.href ("/" ++ (routeToString argRoute))


modifyUrl : Route -> Browser.Navigation.Key -> Cmd msg
modifyUrl theRoute key =
    routeToString theRoute
        |> Browser.Navigation.pushUrl key


fromUrl : Url -> Maybe Route
fromUrl url =
    parse route url



-- link : msg -> List (Attribute msg) -> List (Html msg) -> Html msg
-- link href attrs children =
--   a (preventDefaultOn "click" (D.succeed (href, True)) :: attrs) children


locationHrefToRoute : String -> Maybe Route
locationHrefToRoute locationHref =
    case fromString locationHref of
        Nothing ->
            Just Login

        Just url ->
            parse route url
