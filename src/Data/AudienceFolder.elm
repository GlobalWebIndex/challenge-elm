module Data.AudienceFolder exposing
    ( AudienceFolder, fixtures
    , decoder
    )

{-| Data.AudienceFolder module

This module implements everything related to audience folder resource.


# Interface

@docs AudienceFolder, fixtures

-}

import Json.Decode exposing (Decoder)



-- Type definition


{-| Basic type of AudienceFolder record
-}
type alias AudienceFolder =
    { id : Int
    , name : String
    , parent : Maybe Int
    }



-- Decoders


decoder : Decoder AudienceFolder
decoder =
    Json.Decode.map3 AudienceFolder
        (Json.Decode.field "id" Json.Decode.int)
        (Json.Decode.field "name" Json.Decode.string)
        (Json.Decode.field "parent" (Json.Decode.nullable Json.Decode.int))



-- Fixtures


{-| Fixtures for audienceFolders
In real world something like this is returned by `GET /api/audience_folders`
-}
fixtures : String
fixtures =
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
            },
            {
                "id": 3111,
                "name": "New Group 2 - Duplicated",
                "curated": false,
                "parent": 3110
            },
            {
                "id": 12345,
                "name": "Parent doesn't exist",
                "curated": false,
                "parent": 42
            }
        ]
    }
    """
