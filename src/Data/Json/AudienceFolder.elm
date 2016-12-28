module Data.Json.AudienceFolder exposing (audienceFolderDecoder)

import Json.Decode as JD exposing ((:=))
import Data.AudienceFolder exposing (..)
import Data.Json.Utils exposing (ref)


{-| Json decoder for an AudienceFolder value
-}
audienceFolderDecoder : JD.Decoder AudienceFolder
audienceFolderDecoder =
    JD.object3 AudienceFolder
        ("id" := JD.int)
        ("name" := JD.string)
        ("parent" := ref)
