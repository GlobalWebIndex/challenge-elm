module Data.AudienceFolder exposing (AudienceFolder, audienceFoldersJSON, decodeAudienceFolders)

{-| Data.AudienceFolder module

This module implements everything related to audience folder resource.

# Interface
@docs AudienceFolder, audienceFoldersJSON
-}

import Json.Decode as Decode exposing (Decoder, decodeString, at, list, succeed, field, int, string, maybe)
import Json.Decode.Extra as Decode exposing ((|:))


-- Type definition


{-| Basic type of Audience record
-}
type alias AudienceFolder =
    { id : Int
    , name : String
    , parent : Maybe Int
    }



-- JSON Decoders


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



-- Fixtures


{-| Fixtures for audienceFolders
In real world something like this is returned by `GET /api/audience_folders`
-}
audienceFoldersJSON : String
audienceFoldersJSON =
    """
    {
        "data": [
            {
                "id": 357,
                "name": "Demographics",
                "curated": true,
                "parent": null
            },
            {
                "id": 358,
                "name": "Marketing Personas",
                "curated": true,
                "parent": null
            },
            {
                "id": 383,
                "name": "Reports",
                "curated": true,
                "parent": null
            },
            {
                "id": 3110,
                "name": "New Group",
                "curated": false,
                "parent": null
            },
            {
                "id": 3111,
                "name": "New Group 2",
                "curated": false,
                "parent": 3110
            }
        ]
    }
    """
