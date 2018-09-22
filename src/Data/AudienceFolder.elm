module Data.AudienceFolder exposing (AudienceFolder, audienceFoldersJSON, foldersDecoder)

{-| Data.AudienceFolder module

This module implements everything related to audience folder resource.


# Interface

@docs AudienceFolder, audienceFoldersJSON

-}

import Json.Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (..)


-- Type definition


{-| Basic type of Audience record
-}
type alias AudienceFolder =
    { id : Int
    , name : String
    , parent : Maybe Int
    }


folderDecoder : Decoder AudienceFolder
folderDecoder =
    decode AudienceFolder
        |> required "id" Json.Decode.int
        |> required "name" Json.Decode.string
        |> required "parent" (Json.Decode.nullable Json.Decode.int)


foldersDecoder =
    Json.Decode.at [ "data" ] (Json.Decode.list folderDecoder)



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
