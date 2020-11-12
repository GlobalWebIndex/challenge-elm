
module Data.AudienceFolder exposing (AudienceFolder, audienceFoldersJSON, subfolders0, folders0 )

{-| Data.AudienceFolder module

This module implements everything related to audience folder resource.


# Interface

@docs AudienceFolder, audienceFoldersJSON

-}

import Json.Decode as D exposing ( Decoder )
import Dict exposing ( Dict )

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

maudienceFolders0 : Result D.Error (List AudienceFolder)
maudienceFolders0 = D.decodeString foldersDecoder audienceFoldersJSON

type alias Subfolders = Dict Int (List AudienceFolder)
type alias Folders = Dict Int AudienceFolder

-- Creates a key/value map where the keys are folder ids, and values are the folders themselves.
getFolders : List AudienceFolder -> Folders
getFolders folders =
  let initState = Dict.empty
      
      action folder state =
        Dict.insert folder.id folder state
  in List.foldr action initState folders -- TODO: explain why you chose foldr here instead of foldl

folders0 : Result D.Error Folders
folders0 = Result.map getFolders maudienceFolders0

-- Creates a key/value map where the keys are folder ids, and values are their list of subfolders
dictOfFolders : List AudienceFolder -> Subfolders
dictOfFolders folders =
  let initState = Dict.empty

      action folder state =
        case folder.parent of
          Just folderId ->
            Dict.update
              folderId
              (\mfolders ->
                case mfolders of
                  Just folders1 -> Just (folder :: folders1) -- The reason for 1 is Elm's policy on shadowing.
                  Nothing -> Just [folder]
                )
              state
          Nothing -> state
  in
    List.foldl action initState folders -- foldl is used here because I want to preserve the order of audiences from the list

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
