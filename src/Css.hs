module Css where

import Protolude hiding (rotate, rem, div, (**), not)

import Control.Concurrent.STM.TMVar
import Data.HashMap.Strict
import Clay
import qualified Clay.Media as Q
import Clay.Stylesheet
import Data.Settings
import SharedEnv
import HandlerM


-- Colors
primaryColor :: Color
primaryColor = rgb 152 212 32

lightPrimaryColor :: Color
lightPrimaryColor = lighten 0.5 primaryColor

lightLightPrimaryColor :: Color
lightLightPrimaryColor = lighten 0.5 lightPrimaryColor

darkPrimaryColor :: Color
darkPrimaryColor = darken 0.5 primaryColor

darkDarkPrimaryColor :: Color
darkDarkPrimaryColor = darken 0.5 darkPrimaryColor

secondaryColor :: Color
secondaryColor = rgb 251 180 46

lightSecondaryColor :: Color
lightSecondaryColor = lighten 0.5 secondaryColor

lightLightSecondaryColor :: Color
lightLightSecondaryColor = lighten 0.5 lightSecondaryColor

darkSecondaryColor :: Color
darkSecondaryColor = darken 0.1 secondaryColor

darkDarkSecondaryColor :: Color
darkDarkSecondaryColor = darken 0.5 darkSecondaryColor

facebookBlueColor :: Color
facebookBlueColor = rgb 66 103 178

blackColor :: Color
blackColor = rgb 0 0 0

blackTransparentColor :: Color
blackTransparentColor = rgba 0 0 0 0

greyColor :: Color
greyColor = rgb 80 80 80

darkGreyColor :: Color
darkGreyColor = darken 0.5 greyColor

lightGreyColor :: Color
lightGreyColor = lighten 0.5 greyColor

lightLightGreyColor :: Color
lightLightGreyColor = lighten 0.5 lightGreyColor

whiteColor :: Color
whiteColor = rgb 255 255 255

textAlignLast :: TextAlign -> Css
textAlignLast = key "text-align-last"

gridArea :: Text -> Css
gridArea = key "grid-area"

gridTemplateColumns :: Text -> Css
gridTemplateColumns = key "grid-template-columns"

gridTemplateRows :: Text -> Css
gridTemplateRows = key "grid-template-rows"

gridTemplateAreas :: Text -> Css
gridTemplateAreas = key "grid-template-areas"

gridGap :: Size LengthUnit -> Css
gridGap = key "grid-gap"

fonts :: Css
fonts = do
  fontFace $ do
    fontFamily ["RobotoSlab"] []
    fontFaceSrc
      [ FontFaceSrcUrl "/static/fonts/RobotoSlab-Regular.ttf" (Just TrueType)
      ]
  fontFace $ do
    fontFamily ["Roboto"] []
    fontFaceSrc
      [ FontFaceSrcUrl "/static/fonts/Roboto-Regular.ttf" (Just TrueType)
      ]
  fontFace $ do
    fontFamily ["SansForgetica"] []
    fontFaceSrc
      [ FontFaceSrcUrl "/static/fonts/SansForgetica-Regular.otf" (Just OpenType)
      ]

resetCSS :: Css
resetCSS = do
  star ? do
    margin (rem 0) (rem 0) (rem 0) (rem 0)
    padding (rem 0) (rem 0) (rem 0) (rem 0)
  star # before ? do
    margin (rem 0) (rem 0) (rem 0) (rem 0)
    padding (rem 0) (rem 0) (rem 0) (rem 0)
  star # after ? do
    margin (rem 0) (rem 0) (rem 0) (rem 0)
    padding (rem 0) (rem 0) (rem 0) (rem 0)
  html ? do
    boxSizing inherit

iconCSS :: Css
iconCSS = do
  star # byClass "icon-email" ? do
    iconCSS'
  star # byClass "icon-home" ? do
    iconCSS'
  star # byClass "icon-power" ? do
    iconCSS'
  star # byClass "icon-quizz" ? do
    iconCSS'
  star # byClass "icon-add" ? do
    iconCSS'
  star # byClass "icon-save" ? do
    iconCSS'
  star # byClass "icon-edit" ? do
    iconCSS'
  star # byClass "icon-delete" ? do
    iconCSS'
  star # byClass "icon-user" ? do
    iconCSS'
  star # byClass "icon-postgresql" ? do
    iconCSS'
  star # byClass "icon-haskell" ? do
    iconCSS'
  star # byClass "icon-servant" ? do
    iconCSS'
  star # byClass "icon-debian" ? do
    iconCSS'
  star # byClass "icon-react" ? do
    iconCSS'
  star # byClass "icon-github" ? do
    iconCSS'
  star # byClass "icon-facebook-blue" ? do
    iconCSS'
  where iconCSS' :: Css
        iconCSS' = do
          position relative
          display inlineBlock
          backgroundImage (url "/static/images/icons.png")
          backgroundSize cover
          verticalAlign middle
          overflow hidden
          whiteSpace nowrap
          textIndent (indent (pct 1000))

fromCarouselAppearIn :: Css
fromCarouselAppearIn = do
  left (pct (-110))
  visibility hidden

midCarouselAppearIn :: Css
midCarouselAppearIn = do
  left (pct 0)
  visibility visible

toCarouselAppearIn :: Css
toCarouselAppearIn = do
  left (pct 110)
  visibility hidden

visibleAnimations :: Css
visibleAnimations = do
  keyframes "carousel-appear-in" [
    (0 / nbElementInCarousel, fromCarouselAppearIn)
    , (15 / nbElementInCarousel, midCarouselAppearIn)
    , (85 / nbElementInCarousel, midCarouselAppearIn)
    , (100 / nbElementInCarousel, toCarouselAppearIn)
    , (100, toCarouselAppearIn)]
  keyframes "background-color-in" [
    (0, backgroundInvisible)
    , (100, backgroundVisible)]
  where nbElementInCarousel = 4
        backgroundVisible = do
          background (rgba 255 255 255 1)
        backgroundInvisible = do
          background (rgba 255 255 255 0)


carouselAnimations :: Css
carouselAnimations = do
  animations [
    ("carousel-appear-in", (sec 40), linear, (sec 0), infinite, normal, backwards)
    ]

defaultFonts :: Css
defaultFonts = do
  h1 ? do
    fontFamily ["Roboto"] [sansSerif]
    fontSize (rem 1.2)
    lineHeight (rem 4)
    color blackColor
  h2 ? do
    fontFamily ["Roboto"] [sansSerif]
    fontSize (rem 1.0)
    lineHeight (rem 4)
    color greyColor
  h3 ? do
    fontFamily ["Roboto"] [sansSerif]
    fontSize (rem 1.0)
    lineHeight (rem 4)
    color greyColor
  h4 ? do
    fontFamily ["Roboto"] [sansSerif]
    fontSize (rem 1.0)
    lineHeight (rem 4)
    color greyColor
  li ? do
    fontFamily ["Roboto"] [sansSerif]
    fontSize (rem 1)
    lineHeight (rem 1.5)
    color greyColor
  th ? do
    fontFamily ["Open Sans"] [sansSerif]
    fontSize (rem 1)
    lineHeight (rem 1.2)
    color greyColor
  td ? do
    fontFamily ["Open Sans"] [sansSerif]
    fontSize (rem 1)
    lineHeight (rem 1.2)
    color greyColor
  p ? do
    marginTop (rem 0.5)
    fontFamily ["Open Sans"] [sansSerif]
    fontSize (rem 1)
    lineHeight (rem 1.2)
    color greyColor
  label ? do
    fontFamily ["Open Sans"] [sansSerif]
    fontSize (rem 1)
    lineHeight (rem 1.2)
    color greyColor
  a ? do
    fontFamily ["Roboto"] [sansSerif]
    textDecoration none
    fontWeight bold

listCSS :: Css
listCSS = do
  ul ? do
    listStyleType none
    li ? do
      fontFamily ["Roboto"] [sansSerif]
      a ? do
        color black
        fontWeight bold

tableCSS :: Css
tableCSS = do
  table # byClass "table-form" ? do
    borderCollapse collapse
    tr |> td ? do
      padding (rem 0.3) (rem 0.3) (rem 0.3) (rem 0.3)
      margin (rem 0) (rem 0) (rem 0) (rem 0)
    tr |> td # nthChild "1" ? do
      textAlign end

  table # byClass "bordered" ? do
    borderCollapse collapse
    tr |> td ? do
      padding (rem 0.3) (rem 0.3) (rem 0.3) (rem 0.3)
      margin (rem 0) (rem 0) (rem 0) (rem 0)
      border solid (rem 0.1) lightGreyColor
    span # byClass "logo-delete" ? do
      height (rem 1.5)
      width (rem 1.5)
      backgroundPosition (positioned (rem (-27)) (rem 0))
    span # byClass "logo-locator" ? do
      height (rem 1.5)
      width (rem 1.5)
      backgroundPosition (positioned (rem (-28.5)) (rem 0))
    span # byClass "logo-document" ? do
      height (rem 1.5)
      width (rem 1.5)
      backgroundPosition (positioned (rem (-30)) (rem 0))
    span # byClass "logo-update" ? do
      height (rem 1.5)
      width (rem 1.5)
      backgroundPosition (positioned (rem (-31.5)) (rem 0))
    span # byClass "logo-sell" ? do
      height (rem 1.5)
      width (rem 1.5)
      backgroundPosition (positioned (rem (-33)) (rem 0))

defaultCSS :: Css
defaultCSS = do
  defaultFonts
  listCSS
  iconCSS
  tableCSS
  div ? do
    position relative
  ul ? do
    margin (rem 0) (rem 0) (rem 0) (rem 0)
    padding (rem 0) (rem 0) (rem 0) (rem 0)
  li ? do
    margin (rem 0) (rem 0) (rem 0) (rem 0)
    padding (rem 0) (rem 0) (rem 0) (rem 0)
  a # hover ? do
    cursor pointer
  button # hover ? do
    cursor pointer
  td ? do
    position relative
  a # byClass "anchor" ? do
    display block
    position relative
    top (rem (-3))
    visibility hidden

containerImgTagCSS :: Css
containerImgTagCSS = do
  div # byClass "container-img-tag" ? do
    display inlineBlock
    overflow hidden
    width (rem 5)
    height (rem 5)
    margin (rem 0.5) (rem 0.5) (rem 0.5) (rem 0.5)
    borderRadius (rem 5) (rem 5) (rem 5) (rem 5)
    border solid (rem 0.1) greyColor
    boxShadow . pure $ bsColor primaryColor $ shadowWithSpread (rem 0) (rem 0) (rem 0) (rem 0.2)
  div # byClass "container-img-tag" # hover ? do
    border solid (rem 0.1) primaryColor
    boxShadow . pure $ bsColor greyColor $ shadowWithSpread (rem 0) (rem 0) (rem 0) (rem 0.2)
  div # byClass "container-img-tag" |> img ? do
    width (pct 100)
    height (pct 100)

containerImgProfileCSS :: Css
containerImgProfileCSS = do
  div # byClass "container-img-profile" ? do
    display inlineBlock
    overflow hidden
    width (rem 3)
    height (rem 3)
    margin (rem 0.5) (rem 0.5) (rem 0.5) (rem 0.5)
    borderRadius (rem 3) (rem 3) (rem 3) (rem 3)
    border solid (rem 0.1) greyColor
    boxShadow . pure $ bsColor primaryColor $ shadowWithSpread (rem 0) (rem 0) (rem 0) (rem 0.2)
  div # byClass "container-img-profile" # hover ? do
    border solid (rem 0.1) primaryColor
    boxShadow . pure $ bsColor greyColor $ shadowWithSpread (rem 0) (rem 0) (rem 0) (rem 0.2)
  div # byClass "container-img-profile" |> img ? do
    width (pct 100)
    height (pct 100)

emailLinkCss :: Css
emailLinkCss = do
  div # byClass "container-email-link" ? do
    zIndex (-100)
    position fixed
    right (rem 1)
    bottom (rem (-2))
  div # byClass "container-email-link" # hover ? do
    -- left (rem 2)
    -- animation for the email link
    keyframes "email-link" [
      (    0, bottom (rem (-2)))
      , (100, bottom (rem 0))]
    animations [
      ("email-link", (ms 100), linear, (sec 0), iterationCount 1, normal, backwards)
      ]
    bottom (rem 0)
  div # byClass "container-email-link" |> a ? do
    span ? do
      height (rem 4)
      width (rem 4)
      backgroundPosition (positioned (rem 0) (rem 0))

navigationCSS :: Css
navigationCSS = do
  div # byClass "navigation" ? do
    zIndex 100
    gridArea "navigation"
    position relative
    div # byClass "container-side-text" ? do
      position absolute
      left (rem 3)
      top (rem 0)
      query Q.screen [Q.minWidth (px 640)] $ do
        transform $ rotate (deg (-90))
        height (rem 6)
        width (rem 36)
        top (rem 9)
        left (rem (-10))
      h1 ? do
        -- margin (rem 25) (rem 0) (rem 0) (rem 0)
        fontFamily ["Futura"] [sansSerif]
        fontSize (rem 3)
        color $ setA 0.7 primaryColor
        query Q.screen [Q.minWidth (px 640)] $ do
          fontSize (rem 6)
  emailLinkCss

structureCSS :: Css
structureCSS = do
  body ? do
    display grid
    background $ rgb 242 242 242
    gridTemplateColumns "1fr"
    gridTemplateRows "4rem auto 6rem"
    gridTemplateAreas "\"header\" \"main\" \"footer\""
    gridGap (px 0)

backgroundMainCSS :: Css
backgroundMainCSS = do
  div # byClass "background-main" ? do
    zIndex (-100)
    position absolute
    backgroundSize cover
    backgroundImage (url "/static/Background.Wood.Coffee.jpg")
    width (pct 100)
    height (rem 36)

maccaronCss :: Css
maccaronCss = do
  span # byClass "maccaron-pro" ? do
    fontSize (rem 0.8)
    fontColor black
    fontFamily ["Merriweather"] [sansSerif]
    fontWeight normal
    lineHeight (rem 1.2)
    textTransform none
    backgroundColor secondaryColor
    position absolute
    top (rem (-0.8))
    right (rem (-0.5))
    padding (rem 0.1) (rem 0.5) (rem 0.1) (rem 0.5)
    borderRadius (rem 0.3) (rem 0.3) (rem 0.3) (rem 0.3)
    transform $ rotate (deg (45))

wheelCss :: Css
wheelCss = do
  div # byId "the-wheel-of-foodtrucks" ? do
    position relative
    canvas ? do
      display inlineBlock
      overflow hidden
      fontSize (pct 100)
      lineHeight (pct 100)
    input # byClass "foodtruck-name-input" ? do
      position absolute
      top (px 300)
      left (px 400)
      width (px 200)
    button # byClass "foodtruck-name-button" ? do
      position absolute
      top (px 300)
      left (px 600)
    input # ("type" @= "submit") ? do
      position absolute
      top (px 200)
      left (px 500)

subMenuCSS :: Css
subMenuCSS = do
  div # byClass "submenu-container" ? do
    position relative
    marginTop (rem 5)
    nav |> ul ? do
      padding (rem 0) (rem 0) (rem 0) (rem 0)
      textAlign justify
      textAlignLast justify
      li ? do
        display inlineBlock
        position relative
      li |> a ? do
        fontWeight bold
        display inlineBlock
        fontFamily ["Roboto"] [sansSerif]
        fontSize (rem 1.5)
        lineHeight (rem 2)
        color primaryColor

popupCSS :: Css
popupCSS = do
  keyframes "popup-appear-in" [
      (0, display none)
    , (100, display block)]
  animations [
    ("popup-appear-in", (sec 5), linear, (sec 0), infinite, normal, backwards)
    ]
  div # byId "container-popup" ? do
    display none
    position absolute
    right (rem 0)
    width (pct 80)
    height (pct 100)
    zIndex 400
    background $ rgb 242 242 242
    a # byClass "close-icon" ? do
      width (rem 2)
      height (rem 2)
      top (rem 0.5)
      right (rem 0.5)
      display block
      position absolute
      zIndex 500
      borderRadius (rem 1) (rem 1) (rem 1) (rem 1)
      span ? do
        content $ stringContent " "
        position absolute
        width (pct 80)
        height (px 4)
        top (pct 45)
        left (pct 10)
        background darkPrimaryColor
        transform $ rotate (deg (-45))
      span # after ? do
        content $ stringContent " "
        position absolute
        width (pct 100)
        height (px 4)
        background darkPrimaryColor
        transform $ rotate (deg 90)

fullscreenMenuCSS :: Css
fullscreenMenuCSS = do
  div # byClass "fullscreen-menu" ? do
    position fixed
    visibility hidden
    zIndex 500
    width (pct 100)
    height (pct 100)
    background darkGreyColor
    span # byClass "icon-user" ? do
      height (rem 2)
      width (rem 2)
      backgroundPosition (positioned (rem (-42)) (rem 0))
    span # byClass "icon-home" ? do
      height (rem 2)
      width (rem 2)
      backgroundPosition (positioned (rem (-26)) (rem 0))
    span # byClass "icon-add" ? do
      height (rem 2)
      width (rem 2)
      backgroundPosition (positioned (rem (-48)) (rem 0))
    span # byClass "icon-quizz" ? do
      height (rem 2)
      width (rem 2)
      backgroundPosition (positioned (rem (-28)) (rem 0))
    span # byClass "icon-facebook-blue" ? do
      height (rem 2)
      width (rem 2)
      backgroundPosition (positioned (rem (-12)) (rem 0))
    query Q.screen [Q.minWidth (px 640)] $ do
      span # byClass "icon-user" ? do
        height (rem 4)
        width (rem 4)
        backgroundPosition (positioned (rem (-84)) (rem 0))
      span # byClass "icon-home" ? do
        height (rem 4)
        width (rem 4)
        backgroundPosition (positioned (rem (-52)) (rem 0))
      span # byClass "icon-add" ? do
        height (rem 4)
        width (rem 4)
        backgroundPosition (positioned (rem (-96)) (rem 0))
      span # byClass "icon-quizz" ? do
        height (rem 4)
        width (rem 4)
        backgroundPosition (positioned (rem (-56)) (rem 0))
      span # byClass "icon-facebook-blue" ? do
        height (rem 4)
        width (rem 4)
        backgroundPosition (positioned (rem (-24)) (rem 0))
    ul ? do
      margin (rem 5) (rem 0) (rem 0) (rem 0)
      padding (rem 0) (rem 0) (rem 0) (rem 0)
      listStyleType none
      a ? do
        textTransform capitalize
        color white
        fontFamily ["Roboto"] [sansSerif]
        lineHeight (rem 3)
        query Q.screen [Q.minWidth (px 640)] $ do
          lineHeight (rem 6)
        li ? do
          display block
          position relative
          width (pct 100)
          textAlign center
          fontSize (rem 1.5)
          color white
          lineHeight (rem 3)
          query Q.screen [Q.minWidth (px 640)] $ do
            fontSize (rem 2)
            lineHeight (rem 6)
        form ? do
          input # ("type" @= "submit") ? do
            key "background" (Value "none")
            key "border" (Value "none")
            color white
            fontSize (rem 2)
            lineHeight (rem 3)
            query Q.screen [Q.minWidth (px 640)] $ do
              fontSize (rem 3)
              lineHeight (rem 6)
            fontFamily ["Roboto"] [sansSerif]
          input # ("type" @= "submit") ? do
            cursor pointer
    a # byClass "container-close" ? do
      display block
      position absolute
      top (rem 1)
      right (rem 2)
      width (rem 2.5)
      height (rem 2)
      span # byClass "icon-close" ? do
        position absolute
        width (pct 100)
        height (px 4)
        top (pct 50)
        transform $ rotate (deg (-45))
        background white
      span # byClass "icon-close" # after ? do
        position absolute
        transform $ rotate (deg 90)
        content $ stringContent " "
        width (pct 100)
        height (px 4)
        background white
        top (pct 50)

facebookLoginP :: Css
facebookLoginP = do
  p # byClass "facebook-login" ? do
    a ? do
      lineHeight (rem 2)
      color facebookBlueColor
      span # byClass "logo-facebook-blue" ? do
        height (rem 2)
        width (rem 2)
        backgroundPosition (positioned (rem (-12)) (rem 0))

formCSS :: Css
formCSS = do
  label ? do
    display inlineBlock
    query Q.screen [Q.minWidth (px 640)] $ do
      width (rem 8)
    textAlign end
  input # ("type" @= "password") ? do
    width (rem 12)
  input # ("type" @= "text") ? do
    display inlineBlock
    border solid (rem 0) white
    borderBottom solid (rem 0.1) (setA 0.2 black)
    background (setA 0.3 white)
    width (rem 12)
    fontFamily ["Roboto"] [sansSerif]
    fontSize (rem 1)
  textarea ? do
    border solid (rem 0) white
    borderBottom solid (rem 0.1) (setA 0.2 black)
    background (setA 0.3 white)
    fontFamily ["Roboto"] [sansSerif]
    fontSize (rem 1)
  input # ("type" @= "submit") # hover ? do
    cursor pointer
  button # byId "btnAddMap" ? do
    width (pct 100)
    height (rem 5)

mainPartBlogCategoryListingCSS :: Css
mainPartBlogCategoryListingCSS = do
  padding (rem 2) (rem 0) (rem 0) (rem 0)

mainBreadcrumbCSS :: Css
mainBreadcrumbCSS = do
  div # byClass "breadcrumb-container" ? do
    margin (rem 0) (rem 0) (rem 2) (rem 0)
    ul ? do
      listStyleType none
      li # not (":last-child") ? do
        a # after ? do
          content $ stringContent ">"
      li ? do
        display inlineBlock
        fontFamily ["Roboto"] [sansSerif]
        fontSize (rem 1)
        a ? do
          img ? do
            width (rem 1)
            height (rem 1)
          span # byClass "logo-home" ? do
            height (rem 1.5)
            width (rem 1.5)
            backgroundPosition (positioned (rem (-4.5)) (rem 0))

mainPartCSS :: Css
mainPartCSS = do
  div # byClass "main-part-container" ?do
    display grid
    gridTemplateColumns "1fr 10fr 1fr"
    query Q.screen [Q.minWidth (px 640)] $ do
      gridTemplateColumns "1fr 3fr 1fr"
    gridTemplateRows "auto"
    gridTemplateAreas "\"leftvoid main-part rightvoid\""
    div # byClass "main-part" ? do
      gridArea "main-part"
  div # byClass "main-part-table" ? do
    backgroundSize cover
    backgroundRepeat noRepeat
    backgroundPosition (placed sideCenter sideBottom)
    backgroundImage (url "/static/images/Background.Wood.Coffee.jpg")
  div # byClass "main-part-top-concept" ? do
    height (rem 30)
    backgroundSize cover
    backgroundRepeat noRepeat
    backgroundPosition (placed sideCenter sideBottom)
    backgroundImage (url "/static/images/homepage-food-truck-background.png")

flashcardCss :: Css
flashcardCss = do
  div # byClass "main-part-flashcard-container" ? do
    display block
    textAlign center
  div # byClass "flashcard-quizz-submit" ? do
    position absolute
    top (rem 1)
    right (rem 1)
    query Q.screen [Q.minWidth (px 640)] $ do
      top (rem 8)
      left (rem 15)
    input # byClass "icon-save" ? do
      height (rem 1.5)
      width (rem 1.5)
      key "border" (Value "none")
      backgroundPosition (positioned (rem (-40.5)) (rem 0))
  div # byClass "flashcard-tags-container" ? do
    display inlineBlock
    div # byClass "flashcard-tag-container" ? do
      lineHeight (rem 2)
    span # byClass "icon-delete" ? do
      height (rem 1.5)
      width (rem 1.5)
      backgroundPosition (positioned (rem (-39)) (rem 0))
    span # byClass "icon-add" ? do
      height (rem 1.5)
      width (rem 1.5)
      backgroundPosition (positioned (rem (-42)) (rem 0))
  div # byClass "flashcard-container" ? do
    display inlineBlock
    verticalAlign vAlignTop
    border solid (rem 0.1) lightGreyColor
    borderRadius (rem 0.5) (rem 0.5) (rem 0.5) (rem 0.5)
    width (rem 13)
    height (rem 15)
    margin (rem 1) (rem 1) (rem 1) (rem 1)
    h3 ? do
      display block
      margin (rem 0.5) (rem 0.5) (rem 0.5) (rem 0.5)
      fontSize (rem 1.2)
      lineHeight (rem 1.4)
      fontFamily ["SansForgetica"] [sansSerif]
    textarea ? do
      margin (rem 0.5) (rem 0.5) (rem 0.5) (rem 0.5)
      fontSize (rem 1.2)
      lineHeight (rem 1.4)
      fontFamily ["SansForgetica"] [sansSerif]
      width (pct 90)
      height (pct 100)
    div # byClass "flashcard-icons" ? do
      position absolute
      top (rem (-1))
      right (rem (-1))
      width (rem 4)
      height (rem 2)
      span # byClass "icon-edit" ? do
        height (rem 1.5)
        width (rem 1.5)
        backgroundPosition (positioned (rem (-37.5)) (rem 0))
      span # byClass "icon-delete" ? do
        height (rem 1.5)
        width (rem 1.5)
        backgroundPosition (positioned (rem (-39)) (rem 0))
    div # byClass "flashcard-recto" ? do
      overflowY hidden
      width (pct 100)
      height (rem 7.5)
      borderBottom solid (rem 0.1) greyColor
    div # byClass "flashcard-verso" ? do
      overflowY hidden
      width (pct 100)
      height (rem 7.5)

squareActionCSS :: Css
squareActionCSS = do
  div # byClass "square-action-container" ? do
    display inlineBlock
    borderRadius (rem 0.5) (rem 0.5) (rem 0.5) (rem 0.5)
    background black
    width (rem 3)
    height (rem 3)
    textAlign center
    span # byClass "icon-quizz" ? do
      marginTop (rem 0.5)
      height (rem 2)
      width (rem 2)
      backgroundPosition (positioned (rem (-28)) (rem 0))
    span # byClass "icon-add" ? do
      marginTop (rem 0.5)
      height (rem 2)
      width (rem 2)
      backgroundPosition (positioned (rem (-48)) (rem 0))

mainCSS :: Css
mainCSS = do
  backgroundMainCSS
  fullscreenMenuCSS
  formCSS
  div # byClass "main" ? do
    overflow hidden
    display grid
    gridArea "main"
    gridTemplateColumns "1fr 3fr 1fr"
    gridTemplateRows "auto auto"
    gridTemplateAreas "\"main-part-header main-part-header main-part-header\" \"leftvoid main-part rightvoid\""
    width (pct 100)
    minHeight (rem 10)
    height (pct 100)
    zIndex 100
    popupCSS
    mainPartCSS
    subMenuCSS
    flashcardCss
    squareActionCSS
    div # byClass "main-part" ? do
      gridArea "main-part"
      marginBottom (rem 2)
    div # byClass "main-part-header" ? do
      h1 ? do
        position absolute
        bottom (rem 2)
        left (rem 2)
        color white
        textAlign center
        fontSize (rem 3)
        fontFamily ["RobotoSlab"] [serif]
    div # byClass "bg-memory" ? do
      gridArea "main-part-header"
      height (rem 20)
      backgroundImage (url "/static/images/memory.2.jpg")
      backgroundSize cover
      backgroundPosition (placed sideCenter sideCenter)
    div # byClass "bg-dashboard" ? do
      gridArea "main-part-header"
      height (rem 20)
      backgroundImage (url "/static/images/idea.1.jpg")
      backgroundSize cover
      backgroundPosition (placed sideCenter sideCenter)
    a # byId "aRefreshMapArea" ? do
      top (rem 1)
      right (rem 1)
      position absolute
      padding (rem 0) (rem 0) (rem 0) (rem 0)
      borderRadius (rem 1) (rem 1) (rem 1) (rem 1)
      zIndex 500
      background lightLightPrimaryColor
      span # byClass "logo-refresh" ? do
        height (rem 2)
        width (rem 2)
        backgroundPosition (positioned (rem (-4)) (rem 0))
      span ? do
        fontSize (rem 0.6)
    mainBreadcrumbCSS

mainBlogCSS :: Css
mainBlogCSS = do
  div # byClass "main-part-blog-category-listing" ? do
    mainPartBlogCategoryListingCSS

mapCSS :: Css
mapCSS = do
  div # byId "map-container" ? do
    zIndex 120
    div # byClass "top-description" ? do
      margin (rem 5) (rem 0) (rem 2) (rem 0)
      h1 ? do
        fontFamily ["Roboto"] [sansSerif]
        fontSize (rem 1.5)
        color white
        textShadow (rem (0.1)) (rem (0.1)) (rem (0.1)) black
        textAlign center
    div # byId "map" ? do
      width (pct 100)
      height (rem 23)
      margin (rem 0) (rem 0) (rem 2) (rem 0)
      div # byClass "leaflet-container" ? do
        position relative
        width (pct 100)
        height (pct 100)
      button ? do
        zIndex 500
        position absolute
        top (rem 0.5)
        right (rem 0.5)
        img ? do
          width (rem 1)
          height (rem 1)
      div # byClass "leaflet-popup-content" ? do
        h1 ? do
          fontFamily ["Roboto"] [sansSerif]
          fontSize (rem 0.6)
          color black
        p # lastChild ? do
          marginLeft (rem 0.1)
        p ? do
          display inlineBlock
          padding (rem 0) (rem 0) (rem 0) (rem 0)
          fontSize (rem 0.6)
          color greyColor
          a ? do
            display inlineBlock
            color darkPrimaryColor
            img ? do
              display inlineBlock
              height (rem 1)
        form ? do
          img ? do
            display inlineBlock
            height (rem 1)
          input # ("type" @= "submit") ? do
            key "background" (Value "none")
            key "border" (Value "none")
            fontFamily ["Roboto"] [sansSerif]
            fontSize (rem 0.6)
            color black
        span # byClass "logo-favorite" ? do
          height (rem 1)
          width (rem 1)
          backgroundPosition (positioned (rem (-9)) (rem 0))
        span # byClass "logo-glasses" ? do
          height (rem 1)
          width (rem 1)
          backgroundPosition (positioned (rem (-10)) (rem 0))


diaporamaCSS :: Css
diaporamaCSS = do
  div # byClass "container-diaporama" ? do
    textAlign justify

headerCSS :: Css
headerCSS = do
  header ? do
    position fixed
    width (pct 100)
    height (rem 4)
    zIndex 200
    background darkGreyColor
    div # byClass "header-logo-container" ? do
      display inlineBlock
      margin (rem 1) (rem 0) (rem 0) (rem 2)
      a ? do
        img ? do
          display inlineBlock
          width (rem 2)
          height (rem 2)
        h1 ? do
          display none
          query Q.screen [Q.minWidth (px 640)] $ do
            display inlineBlock
            fontFamily ["SansForgetica"] [sansSerif]
            color white
    nav # byClass "top-nav-login" ? do
      display inlineBlock
      position absolute
      right (rem 2)
      top (rem 1)
    ul # byClass "header-menu" ? do
      display inlineBlock
      margin (rem 0) (rem 0) (rem 0) (rem 2)
      li ? do
        a ? do
          color white

carouselCSS :: Css
carouselCSS = do
  div # byClass "container-carousel" ? do
    position relative
    height (rem 2)
  div # byClass "container-carousel-item" ? do
    display block
    position absolute
    width (pct 90)
    padding (rem 0) (rem 1) (rem 0) (rem 1)
  div # byClass "container-carousel-item" |> h3 ? do
    fontFamily ["Courgette"] [serif]
    display inlineBlock
    width (pct 80)
    paddingRight (rem 1)
    textAlign end
  div # byClass "container-carousel" |> div ? do
    left (pct (-110))
    carouselAnimations
  div # byClass "container-carousel" |> div # nthChild "1" ? do
    animationDelay (sec 0)
  div # byClass "container-carousel" |> div # nthChild "2" ? do
    animationDelay (sec 10)
  div # byClass "container-carousel" |> div # nthChild "3" ? do
    animationDelay (sec 20)
  div # byClass "container-carousel" |> div # nthChild "4" ? do
    animationDelay (sec 30)

footerCSS :: Css
footerCSS = do
  footer ? do
    gridArea  "footer"
    overflow hidden
    zIndex 100
    position relative
    background darkGreyColor
    h3 ? do
      display inlineBlock
      position absolute
      right (rem 0)
      bottom (rem 0)
      fontSize (rem 0.5)
      lineHeight (rem 1)
    ul ? do
      display inlineBlock
      span # byClass "icon-postgresql" ? do
        height (rem 1)
        width (rem 1)
        backgroundPosition (positioned (rem (-16)) (rem 0))
      span # byClass "icon-haskell" ? do
        height (rem 1)
        width (rem 1)
        backgroundPosition (positioned (rem (-20)) (rem 0))
      span # byClass "icon-servant" ? do
        height (rem 1)
        width (rem 1)
        backgroundPosition (positioned (rem (-18)) (rem 0))
      span # byClass "icon-debian" ? do
        height (rem 1)
        width (rem 1)
        backgroundPosition (positioned (rem (-17)) (rem 0))
      span # byClass "icon-react" ? do
        height (rem 1)
        width (rem 1)
        backgroundPosition (positioned (rem (-15)) (rem 0))
      span # byClass "icon-github" ? do
        height (rem 1)
        width (rem 1)
        backgroundPosition (positioned (rem (-19)) (rem 0))
      query Q.screen [Q.minWidth (px 640)] $ do
        span # byClass "icon-postgresql" ? do
          height (rem 2)
          width (rem 2)
          backgroundPosition (positioned (rem (-32)) (rem 0))
        span # byClass "icon-haskell" ? do
          height (rem 2)
          width (rem 2)
          backgroundPosition (positioned (rem (-40)) (rem 0))
        span # byClass "icon-servant" ? do
          height (rem 2)
          width (rem 2)
          backgroundPosition (positioned (rem (-36)) (rem 0))
        span # byClass "icon-debian" ? do
          height (rem 2)
          width (rem 2)
          backgroundPosition (positioned (rem (-34)) (rem 0))
        span # byClass "icon-react" ? do
          height (rem 2)
          width (rem 2)
          backgroundPosition (positioned (rem (-30)) (rem 0))
        span # byClass "icon-github" ? do
          height (rem 2)
          width (rem 2)
          backgroundPosition (positioned (rem (-38)) (rem 0))
      li ? do
        display inlineBlock
        lineHeight (rem 1)
        color white
        query Q.screen [Q.minWidth (px 640)] $ do
          lineHeight (rem 2)
        a ? do
          fontFamily ["Roboto"] [sansSerif]
          fontSize (rem 0.8)
          paddingLeft (rem 2)
          color white
          span ? do
            display none
            query Q.screen [Q.minWidth (px 640)] $ do
              display inlineBlock
          img ? do
            width (rem 1.5)
            height (rem 1.5)
            verticalAlign middle
          span # byClass "logo-world" ? do
            height (rem 2)
            width (rem 2)
            backgroundPosition (positioned (rem (-16)) (rem 0))
          span # byClass "logo-facebook" ? do
            height (rem 2)
            width (rem 2)
            backgroundPosition (positioned (rem (-14)) (rem 0))
          span # byClass "logo-instagram" ? do
            height (rem 2)
            width (rem 2)
            backgroundPosition (positioned (rem (-22)) (rem 0))
          span # byClass "logo-reddit" ? do
            height (rem 2)
            width (rem 2)
            backgroundPosition (positioned (rem (-2)) (rem 0))
          span # byClass "logo-email" ? do
            height (rem 2)
            width (rem 2)
            backgroundPosition (positioned (rem 0) (rem 0))

messagesCSS :: Css
messagesCSS = do
  div # byClass "messages-top" ? do
    display none
    zIndex 500
    position absolute
    top (rem 2)
    left (pct 30)
    width (pct 40)
    borderRadius (rem 1) (rem 1) (rem 1) (rem 1)
    background secondaryColor
    ul ? do
      li ? do
        listStyleType none
        color greyColor

containerLinesCSS :: Css
containerLinesCSS = do
  a # byClass "container-lines" ? do
    display inlineBlock
    position relative
    width (rem 2)
    height (rem 1.5)
    span # byClass "lines" ? do
      content $ stringContent " "
      display block
      position absolute
      width (pct 100)
      height (px 4)
      top (pct 50)
      background white
    span # byClass "lines" # after ? do
      position absolute
      content $ stringContent " "
      width (pct 100)
      height (px 4)
      background white
      top (px 10)
      left (px 0)
    span # byClass "lines" # before ? do
      position absolute
      content $ stringContent " "
      width (pct 100)
      height (px 4)
      background white
      top (px (-10))
      left (px 0)

containerMessagesCSS :: Css
containerMessagesCSS = do
  div # byClass "messages-container" ? do
    position absolute
    top (rem 1)
    right (rem 1)

izidictCSS :: Css
izidictCSS = do
  resetCSS
  element ":root" ? do
    fontSize (pct 125)
    h1 ? do
      margin (rem 0) (rem 0) (rem 0) (rem 0)
    h2 ? do
      margin (rem 0) (rem 0) (rem 0) (rem 0)
    h3 ? do
      margin (rem 0) (rem 0) (rem 0) (rem 0)
    h4 ? do
      margin (rem 0) (rem 0) (rem 0) (rem 0)
    p ? do
      margin (rem 0) (rem 0) (rem 0) (rem 0)
    span ? do
      margin (rem 0) (rem 0) (rem 0) (rem 0)
    defaultCSS
    containerMessagesCSS
    containerLinesCSS
    containerImgTagCSS
    containerImgProfileCSS
    structureCSS
    headerCSS
    navigationCSS
    messagesCSS
    mainCSS
    mapCSS
    diaporamaCSS
    carouselCSS
    maccaronCss
    wheelCss
    footerCSS

izidictCSSText :: HandlerM Text
izidictCSSText = do
  sharedEnv <- ask
  case production . settings $ sharedEnv of
    True -> do
      let tCache = cache sharedEnv

      cache' <- liftIO $ atomically $ readTMVar tCache

      let cacheKey = "CSS-main"

      let mCacheValue = lookup cacheKey cache'

      case mCacheValue of
        -- if the key exists in the cache', return it
        Just cacheValue -> return $ decodeUtf8 cacheValue
        -- if the key doesnt exists, "compile" the CSS
        -- save it in the cache, and return the content
        Nothing -> do
          let cssTxt = renderWith compact [] $ do
                         fonts
                         visibleAnimations
                         izidictCSS

          let newCache = insert cacheKey (encodeUtf8 . toStrict $ cssTxt) cache'
          _ <- liftIO $ atomically $ swapTMVar tCache newCache
          return $ (toStrict cssTxt)

    False -> return $ toStrict $ renderWith pretty [] $ do
                                   fonts
                                   visibleAnimations
                                   izidictCSS
