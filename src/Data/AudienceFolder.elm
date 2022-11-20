module Data.AudienceFolder exposing (AudienceFolder, audFolders)

import Json.Decode as JD exposing (decodeString, succeed, int, string, nullable, list, field)
import Json.Decode.Pipeline exposing (required)


type alias AudienceFolder =
    { id : Int
    , name : String
    , parent : Maybe Int
    }

-- decoder
-- https://gist.github.com/joanllenas/60edc839742bb67227b4cbf21977859b


audFolders : List AudienceFolder
audFolders =
    (decodeString folderDecoder audienceFoldersJSON) |> Result.withDefault []


folderDecoder : JD.Decoder (List AudienceFolder)
folderDecoder =
    JD.succeed AudienceFolder
        |> required "id" int
        |> required "name" string
        |> required "parent" (nullable int)
        |> list
        |> field "data"

-- Fixtures


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
