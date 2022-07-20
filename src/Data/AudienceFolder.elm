module Data.AudienceFolder exposing (AudienceFolder, audienceFoldersJSON, view, decodeDataAudienceFolder)

import Html exposing (..)
import Html.Attributes exposing (style)
import Json.Decode as Decode exposing (..)
import Json.Decode.Pipeline as Pipeline exposing (required, optional, hardcoded)
import Material.Icons.Outlined as Outlined
import Material.Icons.Types exposing (Coloring(..))
import Color

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

view: AudienceFolder -> Bool -> Html msg
view folder opened =
    div[ 
        style "background-color" "#0275d8",
        style "color" "white",
        style "margin" "25px", 
        style "width" "25%",
        style "padding" "20px",
        style "border-radius" "5px",
        style "font-family" "monospace"
    ][
        if opened then
            span[ style "float" "left", style "margin-right" "10px" ][
                Outlined.drive_file_move_rtl 20 (Color <| Color.rgb 96 181 204)
            ]
        else 
            span[ style "float" "left", style "margin-right" "10px" ][
                Outlined.folder 20 (Color <| Color.rgb 96 181 204)
            ]
        , text folder.name
    ]

decodeDataAudienceFolder: Decode.Decoder (List AudienceFolder)
decodeDataAudienceFolder =
    Decode.at ["data"] (Decode.list decodeAudienceFolder)
-- Decoder

decodeAudienceFolder: Decode.Decoder AudienceFolder
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
