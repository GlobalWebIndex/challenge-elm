module Decoders.AudienceFolderDecoder exposing (decodeAudienceFolders)

import Json.Decode as Decode exposing (Decoder, decodeString, at, list, succeed, field, int, string, maybe)
import Json.Decode.Extra as Decode exposing ((|:))
import Data.AudienceFolder as Folder exposing (AudienceFolder, audienceFoldersJSON)


folderDecoder : Decoder AudienceFolder
folderDecoder =
    succeed AudienceFolder
        |: field "id" int
        |: field "name" string
        |: field "parent" (maybe int)


folderDataDecoder : Decoder (List AudienceFolder)
folderDataDecoder =
    at [ "data" ] <|
        list
            folderDecoder


decodeAudienceFolders : Result String (List AudienceFolder)
decodeAudienceFolders =
    audienceFoldersJSON
        |> decodeString folderDataDecoder
