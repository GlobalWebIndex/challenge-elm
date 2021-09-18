module DataParser exposing
    ( decodeAudiences
    , decodeFolders
    , decodeOneAudience
    , decodeOneFolder
    , parse
    , rootId
    )

import Array
import Data.Audience as A
import Data.AudienceFolder as F
import Dict
import Json.Decode as Jd


rootId : Int
rootId =
    -1


parse : String -> String -> Result String Data
parse rawFolders rawAudiences =
    case ( parseFolders rawFolders, parseAudiences rawAudiences ) of
        ( Err err, _ ) ->
            Err <|
                String.concat
                    [ "error parsing folders JSON: "
                    , Jd.errorToString err
                    ]

        ( _, Err err ) ->
            Err <|
                String.concat
                    [ "error parsing audiences JSON: "
                    , Jd.errorToString err
                    ]

        ( Ok folders, Ok audiences ) ->
            Ok <| processParsedJson folders audiences


processParsedJson : List F.AudienceFolder -> List A.Audience -> Data
processParsedJson folders audiences =
    let
        newFolderIds : Dict.Dict Int Int
        newFolderIds =
            List.map .id folders
                |> List.indexedMap (\new old -> ( old, new ))
                |> Dict.fromList

        oldAudienceParentIds : List Int
        oldAudienceParentIds =
            List.map
                (\{ folder } ->
                    case folder of
                        Nothing ->
                            rootId

                        Just id ->
                            id
                )
                audiences

        oldFolderParentIds : List Int
        oldFolderParentIds =
            List.map
                (\{ parent } ->
                    case parent of
                        Nothing ->
                            rootId

                        Just id ->
                            id
                )
                folders
    in
    { names =
        Array.fromList <|
            List.map .name folders
                ++ List.map .name audiences
    , parents =
        updateParents newFolderIds
            (oldFolderParentIds ++ oldAudienceParentIds)
    , firstAudienceId = List.length folders
    }


updateParents :
    Dict.Dict Int Int
    -> List Int
    -> Array.Array Int
updateParents newFolderIds parents =
    Array.fromList <| List.map (updateParent newFolderIds) parents


updateParent : Dict.Dict Int Int -> Int -> Int
updateParent newFolderIds oldParent =
    case Dict.get oldParent newFolderIds of
        Nothing ->
            rootId

        Just newFolderId ->
            newFolderId


type alias Data =
    { names : Array.Array String
    , parents : Array.Array Int
    , firstAudienceId : Int
    }


parseAudiences : String -> Result Jd.Error (List A.Audience)
parseAudiences =
    Jd.decodeString decodeAudiences


parseFolders : String -> Result Jd.Error (List F.AudienceFolder)
parseFolders =
    Jd.decodeString decodeFolders


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
