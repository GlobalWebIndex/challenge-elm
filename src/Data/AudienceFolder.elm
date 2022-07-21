module Data.AudienceFolder exposing (AudienceFolder, audienceFoldersJSON, decodeDataAudienceFolder, view)

import Color
import Helper exposing (trim)
import Html exposing (..)
import Html.Attributes exposing (class, style)
import Json.Decode as Decode exposing (..)
import Json.Decode.Pipeline as Pipeline exposing (hardcoded, optional, required)
import Material.Icons.Outlined as Outlined
import Material.Icons.Types exposing (Coloring(..))


{-| Data.AudienceFolder module

This module implements everything related to audience folder resource.


# Interface

@docs AudienceFolder, audienceFoldersJSON

-}



-- Type definition
-- Basic type of AudienceFolder record


type alias AudienceFolder =
    { id : Int
    , name : String
    , parent : Maybe Int
    }



-- View
{- | View for audienceFolder serves to simply visualize folder elements. This function could be located in Main, but for better code readability,
   it belongs in this file. Obtains bool value that indicates whether folder is currently opened or not.
-}


view : AudienceFolder -> Bool -> Html msg
view folder opened =
    div
        [ class "folder"
        ]
        [ if opened then
            span [ style "float" "left", style "margin-right" "10px" ]
                [ Outlined.drive_file_move_rtl 20 (Color <| Color.rgb 96 181 204)
                ]

          else
            span [ style "float" "left", style "margin-right" "10px" ]
                [ Outlined.folder 20 (Color <| Color.rgb 96 181 204)
                ]
        , text (trim folder.name 60)
        ]



-- Decoder


decodeDataAudienceFolder : Decode.Decoder (List AudienceFolder)
decodeDataAudienceFolder =
    Decode.at [ "data" ] (Decode.list decodeAudienceFolder)


decodeAudienceFolder : Decode.Decoder AudienceFolder
decodeAudienceFolder =
    Decode.succeed AudienceFolder
        |> required "id" Decode.int
        |> required "name" Decode.string
        |> required "parent" (Decode.nullable int)



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
