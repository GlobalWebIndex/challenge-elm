module Data.AudienceFolder exposing (AudienceFolder, audienceFoldersDecoder, audienceFoldersJSON)

{-| Data.AudienceFolder module

This module implements everything related to audience folder resource.


# Interface

@docs AudienceFolder, audienceFoldersJSON

-}

import Data.DecoderUtils exposing (fromResultRecord, partialDecodeField)
import Json.Decode exposing (..)
import Json.Decode.Extra exposing ((|:))


-- Type definition


{-| Basic type of Audience record
-}
type alias AudienceFolder =
    { id : Int
    , name : String
    , curated : Bool
    , parent : Maybe Int
    }


defaultAudienceFolder : AudienceFolder
defaultAudienceFolder =
    AudienceFolder -1 "" False Nothing


feedNameL : (String -> AudienceFolder -> Decoder AudienceFolder) -> List ( String, Value ) -> AudienceFolder
feedNameL decoder elements =
    List.foldl (fromResultRecord decoder) defaultAudienceFolder elements


audienceFolderDecoder : Decoder AudienceFolder
audienceFolderDecoder =
    map (feedNameL decodeField) partialDecodeField


decodeField : String -> AudienceFolder -> Decoder AudienceFolder
decodeField name record =
    case name of
        "id" ->
            succeed (\value -> { record | id = value }) |: int

        "name" ->
            succeed (\value -> { record | name = value }) |: string

        "curated" ->
            succeed (\value -> { record | curated = value }) |: bool

        "parent" ->
            succeed (\value -> { record | parent = value }) |: nullable int

        _ ->
            fail <| "Unhandled field"


audienceFoldersDecoder : Decoder (List AudienceFolder)
audienceFoldersDecoder =
    field "data" (list audienceFolderDecoder)



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
