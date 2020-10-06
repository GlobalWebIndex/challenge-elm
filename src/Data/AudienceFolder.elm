module Data.AudienceFolder exposing
    ( AudienceFolder, audienceFoldersJSON
    , decoder, fetch
    )

{-| Data.AudienceFolder module

This module implements everything related to audience folder resource.


# Interface

@docs AudienceFolder, audienceFoldersJSON

-}

import Json.Decode as D exposing (Decoder)
import MockFetch exposing (mockFetch)



-- Type definition


{-| Basic type of AudienceFolder record
-}
type alias AudienceFolder =
    { id : Int
    , name : String
    , parent : Maybe Int
    }


fetch : (Result D.Error a -> msg) -> Decoder a -> Cmd msg
fetch =
    mockFetch audienceFoldersJSON


decoder : Decoder AudienceFolder
decoder =
    D.map3 AudienceFolder
        (D.field "id" D.int)
        (D.field "name" D.string)
        (D.field "parent" <| D.nullable D.int)



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
