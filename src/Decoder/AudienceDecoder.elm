module Decoder.AudienceDecoder exposing (..)

import Data.Audience exposing (Audience, AudienceType(..))
import Json.Decode as Decode exposing (Decoder)


decode : String -> Result Decode.Error (List Audience)
decode =
    Decode.decodeString <| Decode.field "data" decodeAudiences


decodeAudiences : Decoder (List Audience)
decodeAudiences =
    Decode.list decodeAudience


decodeAudience : Decoder Audience
decodeAudience =
    Decode.map4 Audience
        decodeId
        decodeName
        decodeType
        decodeFolder


decodeId : Decoder Int
decodeId =
    Decode.field "id" Decode.int


decodeName : Decoder String
decodeName =
    Decode.field "name" Decode.string


decodeType : Decoder AudienceType
decodeType =
    Decode.field "type" decodeAudienceType


decodeAudienceType : Decoder AudienceType
decodeAudienceType =
    Decode.string
        |> Decode.andThen
            (\str ->
                case str of
                    "user" ->
                        Decode.succeed Authored

                    "curated" ->
                        Decode.succeed Curated

                    "shared" ->
                        Decode.succeed Shared

                    tag ->
                        Decode.fail <| "Invalid Audience Type: '" ++ tag ++ "'"
            )


decodeFolder : Decoder (Maybe Int)
decodeFolder =
    Decode.field "folder" (Decode.maybe Decode.int)
