module IziCss exposing (..)

import Css exposing (..)
import Css.Colors
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)


theme : { secondary : Css.Color, primary : Css.Color }
theme =
    { secondary = Css.Colors.teal
    , primary = Css.Colors.olive
    }


block : Attribute msg
block =
    css
        [ margin (px 0)
        , padding (px 0)
        ]



{- Structure of the page -}


bodyFrame : Attribute msg
bodyFrame =
    css
        [ property "display" "grid"
        , property "grid-template-columns" "2fr 5fr 2fr"
        , property "grid-template-rows" "1fr auto 100px"
        , property "grid-template-areas" "\"header     header header\"\"leftvoid   main   rightvoid\"\"leftbottom   leftbottom   bottom\""
        , property "grid-gap" "20px"
        ]


headerFrame : Attribute msg
headerFrame =
    css [ property "grid-area" "header" ]


mainFrame : Attribute msg
mainFrame =
    css [ property "grid-area" "main" ]


bottomFrame : Attribute msg
bottomFrame =
    css [ property "grid-area" "bottom" ]



{- Design of the components -}


logo : Attribute msg
logo =
    css
        [ width (px 25)
        , height (px 25)
        , margin (px 10)
        ]


backgroundColored : Attribute msg
backgroundColored =
    css [ backgroundColor theme.secondary ]


niceBoxed : Attribute msg
niceBoxed =
    css
        [ border3 (px 2) solid theme.primary
        , borderRadius (px 10)
        , backgroundColor (hex "ddddd")
        ]


titleCss : Attribute msg
titleCss =
    css [ margin (px 10) ]


inputCss : Attribute msg
inputCss =
    css
        [ width (px 100)
        , margin (px 10)
        ]


btn : List (Attribute msg) -> List (Html msg) -> Html msg
btn =
    styled button
        [ margin (px 20)
        , color (rgb 250 250 250)
        , backgroundColor theme.primary
        , hover
            [ backgroundColor theme.secondary
            , textDecoration underline
            ]
        ]
