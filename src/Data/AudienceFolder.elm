module Data.AudienceFolder exposing (AudienceFolder, list)

{-| Data.AudienceFolder module

This module implements everything related to audience folder resource.


# Interface

@docs AudienceFolder, list

-}

import Error exposing (Error)
import HttpMock
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra as Decode
import Task exposing (Task)



-- Type definition


{-| Basic type of AudienceFolder record
-}
type alias AudienceFolder =
    { id : Int
    , name : String
    , parent : Maybe Int
    }



-- JSON Decoder


decoder : Decoder AudienceFolder
decoder =
    Decode.succeed AudienceFolder
        |> Decode.andMap (Decode.field "id" Decode.int)
        |> Decode.andMap (Decode.field "name" Decode.string)
        |> Decode.andMap (Decode.field "parent" (Decode.nullable Decode.int))



-- API


list : Task Error (List AudienceFolder)
list =
    let
        listDecoder =
            Decode.field "data" (Decode.list decoder)
    in
    HttpMock.task audienceFoldersJSON listDecoder



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
