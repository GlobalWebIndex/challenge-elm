module Data.AudienceFolder exposing (AudienceFolder, audienceFolders)

{-| Data.AudienceFolder module

This module implements everything related to audience folder resource.


# Interface

@docs AudienceFolder, audienceFolders

-}

import Json.Decode



-- Type definition


{-| Basic type of AudienceFolder record
-}
type alias AudienceFolder =
    { id : Int
    , name : String
    , parent : Maybe Int
    }



-- Decoders


{-| `Result` of the JSON parsing.
It returns `Ok ( List AudienceFolder )` if the decoding was successful.
It returns `Err ( ErrorCode, ErrorDesc )` if the decoding failed.
-}
audienceFolders : Result ( String, String ) (List AudienceFolder)
audienceFolders =
    Result.mapError
        (\decoderError -> ( "JSON-AF", "Parse audienceFoldersJSON says: " ++ Json.Decode.errorToString decoderError ))
        (Json.Decode.decodeString audienceFoldersDecoder audienceFoldersJSON)


audienceFoldersDecoder : Json.Decode.Decoder (List AudienceFolder)
audienceFoldersDecoder =
    Json.Decode.field "data" (Json.Decode.list audienceFolderDecoder)


audienceFolderDecoder : Json.Decode.Decoder AudienceFolder
audienceFolderDecoder =
    Json.Decode.map3 AudienceFolder
        (Json.Decode.field "id" Json.Decode.int)
        (Json.Decode.field "name" Json.Decode.string)
        (Json.Decode.field "parent" (Json.Decode.nullable Json.Decode.int))



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
