module Decoder exposing (..)

import Data.Audience as Audience
import Data.AudienceFolder as AudienceFolder
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)



--DECODERS it put them in another class because we can rehuse

--AUDIENCE FOLDERS
decodeAudienceFolders : Decoder (List AudienceFolder.AudienceFolder)
decodeAudienceFolders =
    Decode.at [ "data" ] (Decode.list audienceFolderJsonDecoder)


audienceFolderJsonDecoder : Decoder AudienceFolder.AudienceFolder
audienceFolderJsonDecoder =
    Decode.succeed AudienceFolder.AudienceFolder
        |> required "id" Decode.int
        |> required "name" Decode.string
        |> required "parent" (Decode.maybe Decode.int)

--AUDIENCE

decodeAudiences : Decoder (List Audience.Audience)
decodeAudiences =
    Decode.at [ "data" ] (Decode.list audienceJsonDecoder)


audienceJsonDecoder : Decoder Audience.Audience
audienceJsonDecoder =
    Decode.succeed Audience.Audience
        |> required "id" Decode.int
        |> required "name" Decode.string
        |> required "type" audienceTypeDecoder
        |> required "folder" (Decode.maybe Decode.int)


audienceTypeDecoder : Decoder Audience.AudienceType
audienceTypeDecoder =
    Decode.string
        |> Decode.andThen
            (\str ->
                case str of
                    "user" ->
                        Decode.succeed Audience.Authored

                    "shared" ->
                        Decode.succeed Audience.Shared

                    "curated" ->
                        Decode.succeed Audience.Curated

                    _ ->
                        Decode.fail "Invalid audience type"
            )
