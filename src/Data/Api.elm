module Data.Api exposing
    ( getListOfAudienceFolders
    , getListOfAudiences
    )

import Data.Audience as Audience exposing (Audience)
import Data.AudienceFolder as AudienceFolder exposing (AudienceFolder)
import Http
import Json.Decode as Decode exposing (decodeString)
import Process
import Task exposing (Task)


getListOfAudiences : Task Http.Error (List Audience)
getListOfAudiences =
    Task.andThen
        (\_ ->
            case
                decodeString
                    (Decode.field "data" (Decode.list Audience.decoder))
                    Audience.audiencesJSON
            of
                Err error ->
                    Task.fail (Http.BadBody (Decode.errorToString error))

                Ok audiences ->
                    Task.succeed audiences
        )
        (Process.sleep 1000)


getListOfAudienceFolders : Task Http.Error (List AudienceFolder)
getListOfAudienceFolders =
    Task.andThen
        (\_ ->
            case
                decodeString
                    (Decode.field "data" (Decode.list AudienceFolder.decoder))
                    AudienceFolder.audienceFoldersJSON
            of
                Err error ->
                    Task.fail (Http.BadBody (Decode.errorToString error))

                Ok audiences ->
                    Task.succeed audiences
        )
        (Process.sleep 500)
