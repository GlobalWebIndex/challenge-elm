module Data.Mocked exposing (..)

import Data.Audience exposing (Audience, audiencesJSON)
import Data.AudienceFolder exposing (AudienceFolder, audienceFoldersJSON)
import Decoder exposing (audienceDecoder, audienceFolderDecoder)
import Json.Decode exposing (at, decodeString, list)


type DirElem
    = File Audience
    | Folder AudienceFolder


type alias Directory =
    List DirElem


parsedAudienceFolders : Directory
parsedAudienceFolders =
    case decodeString (at [ "data" ] <| list audienceFolderDecoder) audienceFoldersJSON of
        Ok l ->
            List.map Folder l

        _ ->
            []


parsedAudiences : Directory
parsedAudiences =
    case decodeString (at [ "data" ] <| list audienceDecoder) audiencesJSON of
        Ok l ->
            List.map File l

        _ ->
            []


parsedDirectory : Directory
parsedDirectory =
    parsedAudienceFolders ++ parsedAudiences
