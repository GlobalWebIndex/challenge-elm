module Data.Api.Endpoints exposing (audiences, audience_folders)

import Data.Json.Audience exposing (audienceDecoder)
import Data.Json.AudienceFolder exposing (audienceFolderDecoder)
import Data.Audience exposing (Audience, audiencesJSON)
import Data.AudienceFolder exposing (AudienceFolder, audienceFoldersJSON)
import Json.Decode as JD exposing ((:=))


{-| GET /api/audiences
-}
audiences : Result String (List Audience)
audiences =
    JD.decodeString ("data" := (JD.list audienceDecoder)) audiencesJSON


{-| GET /api/audience_folders
-}
audience_folders : Result String (List AudienceFolder)
audience_folders =
    JD.decodeString ("data" := (JD.list audienceFolderDecoder)) audienceFoldersJSON
