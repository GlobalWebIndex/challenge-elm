module Data.AudienceFolder exposing (AudienceFolder, audFolders)

import Json.Decode as JD exposing (..)



-- type alias Folders =
--     List AudienceFolder

type alias AudienceFolder =
    { id : Int
    , name : String
    , parent : Int
    }

-- decoder
-- https://gist.github.com/joanllenas/60edc839742bb67227b4cbf21977859b

audFolders : List AudienceFolder
audFolders =
    (decodeString decodeJson audienceFoldersJSON) |> Result.withDefault []


decodeJson : JD.Decoder (List AudienceFolder)
decodeJson =
    JD.field "data" decodeData


decodeData : JD.Decoder (List AudienceFolder)
decodeData =
    JD.list decodeItem


decodeItem : JD.Decoder AudienceFolder
decodeItem =
    JD.map3 AudienceFolder
        (JD.field "id" JD.int)
        (JD.field "name" JD.string)
        (JD.field "parent" badInt)

badInt : Decoder Int
badInt =
      oneOf [ int, null 0 ]

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
