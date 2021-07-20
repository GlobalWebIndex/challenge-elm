module Data.AudienceFolder exposing
    ( AudienceFolder, audienceFoldersJSON
    , audienceFoldersDecoder
    )

{-| Data.AudienceFolder module

This module implements everything related to audience folder resource.


# Interface

@docs AudienceFolder, audienceFoldersJSON

-}

import Data.DecodeUtil exposing (dataListDecoder)
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (optional, required)



-- Type definition


{-| Basic type of AudienceFolder record
-}
type alias AudienceFolder =
    { id : Int
    , name : String
    , parent : Maybe Int
    }



-- Decoders


audienceFolderDecoder : Decode.Decoder AudienceFolder
audienceFolderDecoder =
    Decode.succeed AudienceFolder
        |> required "id" Decode.int
        |> required "name" Decode.string
        |> optional "parent" (Decode.maybe Decode.int) Nothing


audienceFoldersDecoder : Decode.Decoder (List AudienceFolder)
audienceFoldersDecoder =
    dataListDecoder audienceFolderDecoder



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
