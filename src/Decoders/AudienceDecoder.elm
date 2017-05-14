module Decoders.AudienceDecoder exposing (decodeAudiences)

import Json.Decode as Decode exposing (Decoder, decodeString, at, list, succeed, fail, field, int, string, maybe, andThen)
import Json.Decode.Extra as Decode exposing ((|:))
import Data.Audience as AudienceData exposing (Audience, AudienceType(..), audiencesJSON)


audienceTypeDecoder : String -> Decoder AudienceType
audienceTypeDecoder typeValue =
    case typeValue of
        "curated" ->
            succeed Curated

        "shared" ->
            succeed Shared

        "user" ->
            succeed Authored

        _ ->
            fail ("Unknown type of audience - " ++ typeValue)


audienceDecoder : Decoder Audience
audienceDecoder =
    succeed Audience
        |: field "id" int
        |: field "name" string
        |: field "type" (string |> andThen audienceTypeDecoder)
        |: field "folder" (maybe int)


audienceDataDecoder : Decoder (List Audience)
audienceDataDecoder =
    at [ "data" ] <|
        list
            audienceDecoder


decodeAudiences : Result String (List Audience)
decodeAudiences =
    audiencesJSON
        |> decodeString audienceDataDecoder
