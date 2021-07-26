module Main exposing (decodeAudiences, decodeOneAudience, main)

import Data.Audience
import Data.AudienceFolder
import Html exposing (Html)
import Json.Decode as Jd


main : Html msg
main =
    Html.text "There will be app soon!"


decodeAudiences : Jd.Decoder (List Data.Audience.Audience)
decodeAudiences =
    Jd.map
        onlyJusts
        (Jd.field "data" decodeAudienceList)


onlyJusts : List (Maybe a) -> List a
onlyJusts maybes =
    onlyJustsHelp maybes []


onlyJustsHelp : List (Maybe a) -> List a -> List a
onlyJustsHelp maybes justs =
    case maybes of
        [] ->
            List.reverse justs

        Nothing :: aybes ->
            onlyJustsHelp aybes justs

        (Just m) :: aybes ->
            onlyJustsHelp aybes (m :: justs)


decodeAudienceList : Jd.Decoder (List (Maybe Data.Audience.Audience))
decodeAudienceList =
    Jd.list <| Jd.maybe decodeOneAudience


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

        "authored" ->
            Jd.succeed Data.Audience.Authored

        _ ->
            Jd.fail <|
                String.concat
                    [ "expecting \"curated\", \"shared\" or "
                    , "\"authored\", but got \""
                    , raw
                    , "\""
                    ]
