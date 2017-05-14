module Decoders.AudienceDecoder exposing (..)

import Json.Decode as Decode exposing (..)
import Json.Decode.Extra as Decode exposing (..)
import Data.AudienceFolder as Folder exposing (AudienceFolder, audienceFoldersJSON)
import Data.Audience as AudienceData exposing (Audience, AudienceType(..), audiencesJSON)


folderDecoder : Decoder AudienceFolder
folderDecoder =
    Decode.succeed AudienceFolder
        |: Decode.field "id" Decode.int
        |: Decode.field "name" Decode.string
        |: Decode.field "parent" (Decode.maybe Decode.int)


folderDataDecoder : Decoder (List AudienceFolder)
folderDataDecoder =
    Decode.at [ "data" ] <|
        Decode.list folderDecoder


decodeFolder : Result String (List AudienceFolder)
decodeFolder =
    audienceFoldersJSON
        |> Decode.decodeString folderDataDecoder


audienceTypeDecoder : String -> Decoder AudienceType
audienceTypeDecoder typeValue =
    case typeValue of
        "curated" ->
            Decode.succeed Curated

        "shared" ->
            Decode.succeed Shared

        "user" ->
            Decode.succeed Authored

        _ ->
            Decode.fail ("Unknown type of audience - " ++ typeValue)


audienceDecoder : Decoder Audience
audienceDecoder =
    Decode.succeed Audience
        |: Decode.field "id" Decode.int
        |: Decode.field "name" Decode.string
        |: Decode.field "type" (Decode.string |> andThen audienceTypeDecoder)
        |: Decode.field "folder" (Decode.maybe Decode.int)


audienceDataDecoder : Decoder (List Audience)
audienceDataDecoder =
    Decode.at [ "data" ] <|
        Decode.list
            audienceDecoder


decodeAudiences : Result String (List Audience)
decodeAudiences =
    audiencesJSON
        |> Decode.decodeString audienceDataDecoder
