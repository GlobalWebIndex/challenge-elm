module Styles exposing
    ( audience
    , audienceFolder
    , breadcrumb
    , content
    , current
    , list
    , loader
    , parent
    , styles
    )

import Css
import Css.Animations as CssA
import Css.Global as CssG
import Html exposing (Html)
import Html.Styled


white : Css.Color
white =
    Css.rgb 255 255 255


lightGray : Css.Color
lightGray =
    Css.hex "f3f3f3"


darkPurple : Css.Color
darkPurple =
    Css.hex "283593"


lightPurple : Css.Color
lightPurple =
    Css.hex "7986CB"


materialIcons : String
materialIcons =
    "material-icons"


content : String
content =
    "content"


loader : String
loader =
    "loader"


list : String
list =
    "list"


breadcrumb : String
breadcrumb =
    "breadcrumb"


parent : String
parent =
    "parent"


current : String
current =
    "current"


audienceFolder : String
audienceFolder =
    "audience-folder"


audience : String
audience =
    "audience"


styles : Html Never
styles =
    CssG.global
        [ CssG.body
            [ Css.margin (Css.px 0)
            , Css.padding (Css.px 20)
            , Css.fontFamilies [ "Roboto", "sans-serif" ]
            ]
        , CssG.class content
            [ Css.maxWidth (Css.px 600)
            , Css.margin2 (Css.px 0) Css.auto
            ]
        , CssG.class loader
            [ Css.margin2 (Css.px 100) Css.auto
            , Css.border3 (Css.px 4) Css.solid lightGray
            , Css.borderTop3 (Css.px 4) Css.solid darkPurple
            , Css.borderRadius (Css.pct 50)
            , Css.width (Css.px 60)
            , Css.height (Css.px 60)
            , Css.animationName
                (CssA.keyframes
                    [ ( 0, [ CssA.transform [ Css.rotate (Css.deg 0) ] ] )
                    , ( 100, [ CssA.transform [ Css.rotate (Css.deg 360) ] ] )
                    ]
                )
            , Css.animationDuration (Css.sec 1.3)
            , Css.property "animation-iteration-count" "infinite"
            ]
        , CssG.class breadcrumb
            [ Css.marginBottom (Css.px 20)
            , Css.padding (Css.px 10)
            , Css.height (Css.px 30)
            , Css.displayFlex
            , Css.alignItems Css.center
            , CssG.descendants
                [ CssG.class parent
                    [ Css.cursor Css.pointer
                    , Css.color darkPurple
                    ]
                , CssG.class current
                    []
                ]
            ]
        , CssG.ul
            [ CssG.withClass list
                [ Css.listStyleType Css.none
                , Css.margin (Css.px 0)
                , Css.padding (Css.px 0)
                , CssG.descendants
                    [ CssG.li
                        [ Css.margin (Css.px 5)
                        , Css.padding (Css.px 20)
                        , Css.borderRadius (Css.px 4)
                        , Css.color white
                        , CssG.withClass audienceFolder
                            [ Css.backgroundColor darkPurple
                            , Css.displayFlex
                            , Css.alignItems Css.center
                            , Css.cursor Css.pointer
                            , CssG.descendants
                                [ CssG.class materialIcons
                                    [ Css.marginRight (Css.px 10)
                                    ]
                                ]
                            ]
                        , CssG.withClass audience
                            [ Css.backgroundColor lightPurple
                            , CssG.descendants
                                [ CssG.div
                                    [ Css.marginLeft (Css.px 34)
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
        |> Html.Styled.toUnstyled
