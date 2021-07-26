module Main exposing (decodeAudiences, decodeFolders, decodeOneAudience, decodeOneFolder, main)

import Data.Audience
import Data.AudienceFolder as F
import Html exposing (Html)
import Json.Decode as Jd


main : Html msg
main =
    Html.text "There will be app soon!"


decodeFolders : Jd.Decoder (List F.AudienceFolder)
decodeFolders =
    Jd.field "data" decodeFolderList


decodeFolderList : Jd.Decoder (List F.AudienceFolder)
decodeFolderList =
    Jd.list decodeOneFolder


decodeOneFolder : Jd.Decoder F.AudienceFolder
decodeOneFolder =
    Jd.map3 F.AudienceFolder
        (Jd.field "id" Jd.int)
        (Jd.field "name" Jd.string)
        (Jd.field "parent" (Jd.nullable Jd.int))


decodeAudiences : Jd.Decoder (List Data.Audience.Audience)
decodeAudiences =
    Jd.field "data" decodeAudienceList


decodeAudienceList : Jd.Decoder (List Data.Audience.Audience)
decodeAudienceList =
    Jd.list decodeOneAudience


decodeOneAudience : Jd.Decoder Data.Audience.Audience
decodeOneAudience =
    Jd.map4 Data.Audience.Audience
        (Jd.field "id" Jd.int)
        (Jd.field "name" Jd.string)
        (Jd.field "type" decodeAudienceType)
        (Jd.maybe <| Jd.field "folder" Jd.int)


decodeAudienceType : Jd.Decoder Data.Audience.AudienceType
decodeAudienceType =
    Jd.andThen decodeAudienceTypeHelp Jd.string


decodeAudienceTypeHelp :
    String
    -> Jd.Decoder Data.Audience.AudienceType
decodeAudienceTypeHelp raw =
    case raw of
        "curated" ->
            Jd.succeed Data.Audience.Curated

        "shared" ->
            Jd.succeed Data.Audience.Shared

        "user" ->
            Jd.succeed Data.Audience.Authored

        _ ->
            Jd.fail <|
                String.concat
                    [ "expecting \"curated\", \"shared\" or "
                    , "\"authored\", but got \""
                    , raw
                    , "\""
                    ]
