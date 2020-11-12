module Main exposing (main)

import Data.Audience exposing ( audiences )
import Data.AudienceFolder exposing ( audienceFolders )
import Html exposing (Html)

import Debug exposing ( log, todo, toString )

main : Html msg
main =
    Html.text (log (toString audienceFolders) "There will be app soon!")

