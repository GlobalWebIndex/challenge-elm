module Main exposing (main)

import Browser
import Html exposing (Html)


main : Program () () ()
main =
    Browser.document
        { init = \_ -> ( (), Cmd.none )
        , update = \_ _ -> ( (), Cmd.none )
        , subscriptions = \_ -> Sub.none
        , view =
            \_ ->
                Browser.Document "Hi"
                    [ Html.text "Hola"
                    ]
        }
