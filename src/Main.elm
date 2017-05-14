module Main exposing (main)

import Html exposing (Html)
import Decoders.AudienceDecoder as AD exposing (decode)


-- Import Modules

import Data.Audience
import Data.AudienceFolder


{-| Main file of application
-}
main : Html msg
main =
    Html.text
        (AD.decode
            |> toString
        )
