module Data.AudienceFolder exposing 
    ( AudienceFolder
    , audienceFoldersJSON
    , audienceFolderDecoder
    )

import Json.Decode as JD
import Json.Decode.Pipeline as JDP

{-| Data.AudienceFolder module

This module implements everything related to audience folder resource.


# Interface

@docs AudienceFolder, audienceFoldersJSON

-}

-- Type definition


{- Basic type of AudienceFolder record
-}
type alias AudienceFolder =
    { id : Int
    , name : String
    , parent : Maybe Int
    }

audienceFolderDecoder : JD.Decoder AudienceFolder
audienceFolderDecoder =
    (JD.succeed AudienceFolder)
        |> JDP.required "id" JD.int
        |> JDP.required "name" JD.string
        |> JDP.required "parent" (JD.nullable JD.int)


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
