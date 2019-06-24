module Icons exposing
    ( list
    , share2
    , user
    )

import Html
import Svg
import Svg.Attributes


svgFeatherIcon : String -> List (Svg.Svg msg) -> Html.Html msg
svgFeatherIcon className =
    Svg.svg
        [ Svg.Attributes.class <| "feather feather-" ++ className
        , Svg.Attributes.fill "none"
        , Svg.Attributes.height "24"
        , Svg.Attributes.stroke "currentColor"
        , Svg.Attributes.strokeLinecap "round"
        , Svg.Attributes.strokeLinejoin "round"
        , Svg.Attributes.strokeWidth "2"
        , Svg.Attributes.viewBox "0 0 24 24"
        , Svg.Attributes.width "24"
        ]


list : Html.Html msg
list =
    svgFeatherIcon "list"
        [ Svg.line [ Svg.Attributes.x1 "8", Svg.Attributes.y1 "6", Svg.Attributes.x2 "21", Svg.Attributes.y2 "6" ] []
        , Svg.line [ Svg.Attributes.x1 "8", Svg.Attributes.y1 "12", Svg.Attributes.x2 "21", Svg.Attributes.y2 "12" ] []
        , Svg.line [ Svg.Attributes.x1 "8", Svg.Attributes.y1 "18", Svg.Attributes.x2 "21", Svg.Attributes.y2 "18" ] []
        , Svg.line [ Svg.Attributes.x1 "3", Svg.Attributes.y1 "6", Svg.Attributes.x2 "3", Svg.Attributes.y2 "6" ] []
        , Svg.line [ Svg.Attributes.x1 "3", Svg.Attributes.y1 "12", Svg.Attributes.x2 "3", Svg.Attributes.y2 "12" ] []
        , Svg.line [ Svg.Attributes.x1 "3", Svg.Attributes.y1 "18", Svg.Attributes.x2 "3", Svg.Attributes.y2 "18" ] []
        ]


share2 : Html.Html msg
share2 =
    svgFeatherIcon "share-2"
        [ Svg.circle [ Svg.Attributes.cx "18", Svg.Attributes.cy "5", Svg.Attributes.r "3" ] []
        , Svg.circle [ Svg.Attributes.cx "6", Svg.Attributes.cy "12", Svg.Attributes.r "3" ] []
        , Svg.circle [ Svg.Attributes.cx "18", Svg.Attributes.cy "19", Svg.Attributes.r "3" ] []
        , Svg.line [ Svg.Attributes.x1 "8.59", Svg.Attributes.y1 "13.51", Svg.Attributes.x2 "15.42", Svg.Attributes.y2 "17.49" ] []
        , Svg.line [ Svg.Attributes.x1 "15.41", Svg.Attributes.y1 "6.51", Svg.Attributes.x2 "8.59", Svg.Attributes.y2 "10.49" ] []
        ]


user : Html.Html msg
user =
    svgFeatherIcon "user"
        [ Svg.path [ Svg.Attributes.d "M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" ] []
        , Svg.circle [ Svg.Attributes.cx "12", Svg.Attributes.cy "7", Svg.Attributes.r "4" ] []
        ]
