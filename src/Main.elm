module Main exposing (decodeAudiences, decodeFolders, decodeOneAudience, decodeOneFolder, main)

import Browser
import Data.Audience as A
import Data.AudienceFolder as F
import Html exposing (Html)
import Json.Decode as Jd


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


type Msg
    = FolderClick Int
    | AudienceClick Int
    | GoUpClick


type alias Model =
    { foldersInView : List Int
    , audiencesInView : List Int
    , folders : List F.AudienceFolder
    , audiences : List A.Audience
    , goodParse : Bool
    }


view : Model -> Html.Html Msg
view _ =
    Html.text "hi"


update : Msg -> Model -> Model
update _ model =
    model


zeroModel =
    { foldersInView = []
    , audiencesInView = []
    , folders = []
    , audiences = []
    , goodParse = False
    }


init : Model
init =
    case ( folderParseResult, audiencesParseResult ) of
        ( Err _, _ ) ->
            { zeroModel | goodParse = False }

        ( _, Err _ ) ->
            { zeroModel | goodParse = False }

        ( Ok folders, Ok audiences ) ->
            { zeroModel
                | foldersInView = orphanFolders folders
                , audiencesInView = orphanAudiences audiences
                , folders = folders
                , audiences = audiences
                , goodParse = True
            }


audiencesParseResult : Result Jd.Error (List A.Audience)
audiencesParseResult =
    Jd.decodeString decodeAudiences A.audiencesJSON


folderParseResult : Result Jd.Error (List F.AudienceFolder)
folderParseResult =
    Jd.decodeString decodeFolders F.audienceFoldersJSON


orphanFolders : List F.AudienceFolder -> List Int
orphanFolders folders =
    List.filterMap isOrphanFolder folders


isOrphanFolder : F.AudienceFolder -> Maybe Int
isOrphanFolder { parent, id } =
    if parent == Nothing then
        Just id

    else
        Nothing


orphanAudiences : List A.Audience -> List Int
orphanAudiences audiences =
    List.filterMap isOrphanAudience audiences


isOrphanAudience : A.Audience -> Maybe Int
isOrphanAudience { folder, id } =
    if folder == Nothing then
        Just id

    else
        Nothing


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


decodeAudiences : Jd.Decoder (List A.Audience)
decodeAudiences =
    Jd.field "data" decodeAudienceList


decodeAudienceList : Jd.Decoder (List A.Audience)
decodeAudienceList =
    Jd.list decodeOneAudience


decodeOneAudience : Jd.Decoder A.Audience
decodeOneAudience =
    Jd.map4 A.Audience
        (Jd.field "id" Jd.int)
        (Jd.field "name" Jd.string)
        (Jd.field "type" decodeAudienceType)
        (Jd.maybe <| Jd.field "folder" Jd.int)


decodeAudienceType : Jd.Decoder A.AudienceType
decodeAudienceType =
    Jd.andThen decodeAudienceTypeHelp Jd.string


decodeAudienceTypeHelp :
    String
    -> Jd.Decoder A.AudienceType
decodeAudienceTypeHelp raw =
    case raw of
        "curated" ->
            Jd.succeed A.Curated

        "shared" ->
            Jd.succeed A.Shared

        "user" ->
            Jd.succeed A.Authored

        _ ->
            Jd.fail <|
                String.concat
                    [ "expecting \"curated\", \"shared\" or "
                    , "\"authored\", but got \""
                    , raw
                    , "\""
                    ]
