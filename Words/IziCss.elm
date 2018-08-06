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
        , property "grid-template-columns" "2fr 10fr 2fr"
        , property "grid-template-rows" "1fr auto 100px"
        , property "grid-template-areas" "\"header     header header\"\"leftvoid   main   rightvoid\"\"leftbottom   leftbottom   bottom\""
        , property "grid-gap" "20px"
        , backgroundImage (url "/ressources/waterfalls.jpg")
        , property "background-size" "cover"
        ]


headerFrame : Attribute msg
headerFrame =
    css
        [ property "display" "grid"
        , property "grid-area" "header"
        , property "grid-template-columns" "2fr 10fr 2fr"
        , property "grid-template-areas" "\"leftheader   centerheader rightheader\""
        , backgroundColor (rgba 0 0 0 0.7)
        ]


leftHeaderFrame : Attribute msg
leftHeaderFrame =
    css
        [ property "grid-area" "leftheader"
        ]


centerHeaderFrame : Attribute msg
centerHeaderFrame =
    css
        [ property "grid-area" "centerheader"
        ]


rightHeaderFrame : Attribute msg
rightHeaderFrame =
    css
        [ property "grid-area" "rightheader"
        ]


mainFrame : Attribute msg
mainFrame =
    css
        [ property "grid-area" "main"
        , backgroundColor (rgba 255 255 255 0.9)
        ]


bottomFrame : Attribute msg
bottomFrame =
    css [ property "grid-area" "bottom" ]



{- Design of the components -}


errorStyle : Attribute msg
errorStyle =
    css [ color Css.Colors.red ]


whiteLink : Attribute msg
whiteLink =
    css [ color Css.Colors.white ]


logo : Attribute msg
logo =
    css
        [ width (px 25)
        , height (px 25)
        ]


tdBorder : Attribute msg
tdBorder =
    css [ border3 (px 1) solid theme.secondary ]


backgroundColored : Attribute msg
backgroundColored =
    css [ backgroundColor theme.secondary ]


niceBoxed : Attribute msg
niceBoxed =
    css
        [ border3 (px 2) solid theme.primary
        , borderRadius (px 10)
        ]


titleCss : Attribute msg
titleCss =
    css
        [ margin (px 30)
        , color Css.Colors.white
        , fontFamilies [ "Lato", "sans-serif" ]
        ]


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
