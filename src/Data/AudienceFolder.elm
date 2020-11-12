
module Data.AudienceFolder exposing (AudienceFolder, audienceFoldersJSON, subfolders0, folders0 )

{-| Data.AudienceFolder module

This module implements everything related to audience folder resource.


# Interface

@docs AudienceFolder, audienceFoldersJSON

-}

import Json.Decode as D exposing ( Decoder )
import Json.Decode.Extra as D

import Dict exposing ( Dict )
import Dict.Helpers exposing ( fromListBy, fromListAppendBy )

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
folderDecoder =
  D.succeed AudienceFolder
    |> D.andMap idField
    |> D.andMap nameField
    |> D.andMap parentField

foldersDecoder : Decoder (List AudienceFolder)
foldersDecoder = D.field "data" (D.list folderDecoder)

maudienceFolders0 : Result D.Error (List AudienceFolder)
maudienceFolders0 = D.decodeString foldersDecoder audienceFoldersJSON

-- === Folders ===
type alias Folders = Dict Int AudienceFolder

-- Creates a key/value map where the keys are folder ids, and values are the folders themselves.
getFolders : List AudienceFolder -> Folders
getFolders folders = fromListBy .id folders

folders0 : Result D.Error Folders
folders0 = Result.map getFolders maudienceFolders0

-- === Subfolders ===
type alias Subfolders = Dict Int (List AudienceFolder)

-- Creates a key/value map where the keys are folder ids, and values are their list of subfolders
dictOfFolders : List AudienceFolder -> Subfolders
dictOfFolders folders = fromListAppendBy .parent folders

subfolders0 : Result D.Error Subfolders
subfolders0 = Result.map dictOfFolders maudienceFolders0

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
