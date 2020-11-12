module Data.AudienceFolder exposing (AudienceFolder, audienceFoldersJSON, audienceFolders)

{-| Data.AudienceFolder module

This module implements everything related to audience folder resource.


# Interface

@docs AudienceFolder, audienceFoldersJSON

-}

import Json.Decode as D exposing ( Decoder )

-- TODO: remove
import Debug exposing ( log, todo, toString )

-- Type definition


{-| Basic type of AudienceFolder record
-}
type alias AudienceFolder =
    { id : Int
    , name : String
    , parent : Maybe Int
    }



-- = BASIC FIELDS DECODERS =
idField = D.field "id" D.int
nameField = D.field "name" D.string
parentField = D.field "parent" (D.nullable D.int)

-- = AUDIENCE FOLDER DECODER --
folderDecoder : Decoder AudienceFolder
folderDecoder = D.map3 AudienceFolder idField nameField parentField

foldersDecoder : Decoder (List AudienceFolder)
foldersDecoder = D.field "data" (D.list folderDecoder)

audienceFolders : Result D.Error (List AudienceFolder)
audienceFolders = D.decodeString foldersDecoder audienceFoldersJSON

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
