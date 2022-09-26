module Decoder exposing (..)

import Data.Audience exposing (Audience, AudienceType(..))
import Data.AudienceFolder exposing (AudienceFolder)
import Json.Decode exposing (Decoder, andThen, fail, field, int, map3, map4, maybe, string, succeed)


audienceFolderDecoder : Decoder AudienceFolder
audienceFolderDecoder =
    map3 AudienceFolder
        (field "id" int)
        (field "name" string)
        (maybe (field "parent" int))


audienceTypeDecoder : String -> Decoder AudienceType
audienceTypeDecoder s =
    case s of
        "user" ->
            succeed Authored

        "shared" ->
            succeed Shared

        "curated" ->
            succeed Curated

        _ ->
            fail <| "AudienceType '" ++ s ++ "' does not exist."


audienceDecoder : Decoder Audience
audienceDecoder =
    map4 Audience
        (field "id" int)
        (field "name" string)
        (field "type" string |> andThen audienceTypeDecoder)
        (maybe (field "folder" int))
