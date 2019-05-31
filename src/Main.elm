module Main exposing (audienceFolders, audiences, main)

import Data.Audience exposing (Audience, audiencesDecoder, audiencesJSON)
import Data.AudienceFolder exposing (AudienceFolder, audienceFoldersDecoder, audienceFoldersJSON)
import Html exposing (Html)
import Json.Decode exposing (decodeString)


audienceFolders =
    Result.withDefault [] <| decodeString audienceFoldersDecoder audienceFoldersJSON


audiences =
    Result.withDefault [] <| decodeString audiencesDecoder audiencesJSON


main : Html msg
main =
    Html.text "There will be app soon!"
