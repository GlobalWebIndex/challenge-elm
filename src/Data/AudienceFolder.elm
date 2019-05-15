module Data.AudienceFolder exposing
    ( AudienceFolder, audienceFoldersJSON
    , audienceFoldersDecoder
    )

{-| Data.AudienceFolder module

This module implements everything related to audience folder resource.


# Interface

@docs AudienceFolder, audienceFoldersJSON

-}

import Json.Decode as D exposing (Decoder, field, maybe, nullable, succeed)
import Json.Decode.Applicative exposing (with)



-- Type definition


{-| Basic type of AudienceFolder record
-}
type alias AudienceFolder =
    { id : Int
    , name : String
    , parent : Maybe Int
    }


audienceFolderDecoder : Decoder AudienceFolder
audienceFolderDecoder =
    succeed AudienceFolder
        |> with (field "id" D.int)
        |> with (field "name" D.string)
        |> with (field "parent" (nullable D.int))


audienceFoldersDecoder : Decoder (List AudienceFolder)
audienceFoldersDecoder =
    field "data" <| D.list audienceFolderDecoder



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
