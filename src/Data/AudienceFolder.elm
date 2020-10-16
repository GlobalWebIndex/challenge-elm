module Data.AudienceFolder exposing (AudienceFolder, audienceFoldersJSON, decodeAudienceFolders)

{-| Data.AudienceFolder module

This module implements everything related to audience folder resource.


# Interface

@docs AudienceFolder, audienceFoldersJSON

-}

import Json.Decode as JD

-- Type definition


{-| Basic type of AudienceFolder record
-}
type alias AudienceFolder =
    { id : Int
    , name : String
    , parent : Maybe Int
    }

decodeAudienceFolder : JD.Decoder AudienceFolder
decodeAudienceFolder =
    JD.map3 AudienceFolder
        (JD.field "id" JD.int) (JD.field "name" JD.string) (JD.field "parent" (JD.maybe JD.int))

decodeAudienceFolders : JD.Decoder (List AudienceFolder)
decodeAudienceFolders = JD.field "data" (JD.list decodeAudienceFolder)


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
