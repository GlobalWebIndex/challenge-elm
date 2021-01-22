module View.Icon exposing (arrowRight, folder)

import Html exposing (Html)
import Html.Attributes as Attr


icon : String -> Html msg
icon name =
    Html.span [ Attr.class "material-icons" ] [ Html.text name ]


folder : Html msg
folder =
    icon "folder"


arrowRight : Html msg
arrowRight =
    icon "keyboard_arrow_right"
