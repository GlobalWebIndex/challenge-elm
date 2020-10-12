module Data.AudienceFolder exposing (AudienceFolder, audienceFoldersJSON, decoder, isParent, roots)

import Json.Decode as D
import Json.Decode.Extra as DX


{-| Data.AudienceFolder module

This module implements everything related to audience folder resource.


# Interface

@docs AudienceFolder, audienceFoldersJSON

-}



-- Type definition
--{-| Basic type of AudienceFolder record
---}


type alias AudienceFolder =
    { id : Int
    , name : String
    , parent : Maybe Int
    }


{-| Keep folders which does not have parent folder
-}
roots : List AudienceFolder -> List AudienceFolder
roots folders =
    List.filter isRoot folders


{-| Determines if the given folder does not have parent folder
-}
isRoot : AudienceFolder -> Bool
isRoot folder =
    case folder.parent of
        Just _ ->
            False

        Nothing ->
            True


{-| Determines if the given two folder is in parent - child relationship
-}
isParent : AudienceFolder -> AudienceFolder -> Bool
isParent parent child =
    case child.parent of
        Just id ->
            parent.id == id

        Nothing ->
            False



-- Decoders


decoder : D.Decoder (List AudienceFolder)
decoder =
    D.field "data" <| D.list audienceFolderDecoder


audienceFolderDecoder : D.Decoder AudienceFolder
audienceFolderDecoder =
    D.succeed AudienceFolder
        |> DX.andMap (D.field "id" D.int)
        |> DX.andMap (D.field "name" D.string)
        |> DX.andMap (D.field "parent" (D.nullable D.int))



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
