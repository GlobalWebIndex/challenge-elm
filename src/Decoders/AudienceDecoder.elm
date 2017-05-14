module Decoders.AudienceDecoder exposing (..)

import Json.Decode as Decode exposing (..)
import Json.Decode.Extra as Decode exposing (..)
import Data.AudienceFolder as Folder exposing (AudienceFolder, audienceFoldersJSON)


folderDecoder : Decoder AudienceFolder
folderDecoder =
    Decode.succeed AudienceFolder
        |: Decode.field "id" Decode.int
        |: Decode.field "name" Decode.string
        |: Decode.field "parent" (Decode.maybe Decode.int)


folderDataDecoder : Decoder (List AudienceFolder)
folderDataDecoder =
    Decode.at [ "data" ] <|
        Decode.list folderDecoder


decode : Result String (List AudienceFolder)
decode =
    audienceFoldersJSON
        |> Decode.decodeString folderDataDecoder
