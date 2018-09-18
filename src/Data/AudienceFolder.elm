module Data.AudienceFolder
    exposing
        ( AudienceFolder
        , audienceFolders
        , audienceFoldersDecoder
        , audienceFoldersJSON
        )

{-| Data.AudienceFolder module

This module implements everything related to audience folder resource.

# Interface
@docs AudienceFolder, audienceFoldersJSON
-}

import Json.Decode as Decode exposing (Decoder)


-- Type definition


{-| Basic type of Audience record
-}
type alias AudienceFolder =
    { id : Int
    , name : String
    , parent : Maybe Int
    }


audienceFolderDecoder : Decoder AudienceFolder
audienceFolderDecoder =
    Decode.map3 AudienceFolder
        (Decode.field "id" Decode.int)
        (Decode.field "name" Decode.string)
        (Decode.field "parent" <| Decode.nullable Decode.int)


audienceFoldersDecoder : Decoder (List AudienceFolder)
audienceFoldersDecoder =
    Decode.field "data" <| Decode.list audienceFolderDecoder


audienceFolders : List AudienceFolder
audienceFolders =
    Decode.decodeString audienceFoldersDecoder audienceFoldersJSON
        |> Result.withDefault []



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
