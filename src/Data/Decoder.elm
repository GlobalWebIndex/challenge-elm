module Data.Decoder exposing (..)

import Data.Audience            exposing (Audience, AudienceType(..))
import Data.AudienceFolder      exposing (AudienceFolder)
import Json.Decode as Decode    exposing (Decoder, int, string, nullable, list)
import Json.Decode.Pipeline     exposing (required, optional)


decodeAudienceType : Decoder AudienceType
decodeAudienceType =
    let
        parse s =
            case s of
                "user" ->
                    Decode.succeed Authored

                "curated" ->
                    Decode.succeed Curated

                "shared" ->
                    Decode.succeed Shared

                _ ->
                    Decode.fail <| "Invalid audienceType: " ++ s
    in
        string |> Decode.andThen parse


decodeAudience : Decoder Audience
decodeAudience =
    Decode.succeed Audience
        |> required "id" int
        |> required "name" string
        |> required "type" decodeAudienceType
        |> optional "folder" (nullable int) Nothing


decodeGetAudiences : Decoder (List Audience)
decodeGetAudiences =
    Decode.at ["data"] <| list decodeAudience


decodeAudienceFolder =
    Decode.succeed AudienceFolder
        |> required "id" int
        |> required "name" string
        |> optional "parent" (nullable int) Nothing


decodeGetAudienceFolders : Decoder (List AudienceFolder)
decodeGetAudienceFolders =
    Decode.at ["data"] <| list decodeAudienceFolder
