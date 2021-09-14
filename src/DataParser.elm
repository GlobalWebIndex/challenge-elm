module DataParser exposing
    ( decodeAudiences
    , decodeFolders
    , decodeOneAudience
    , decodeOneFolder
    , parse
    )

import Data.Audience as A
import Data.AudienceFolder as F
import Dict
import Json.Decode as Jd
import Set


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
            let
                folderMap : Dict.Dict Int String
                folderMap =
                    makeFolderMap folders
            in
            case foldFail (addFolder folderMap) zeroDataSet folders of
                Err err ->
                    Err err

                Ok ok ->
                    foldFail (addAudience folderMap) ok audiences


makeFolderMap : List F.AudienceFolder -> Dict.Dict Int String
makeFolderMap folders =
    List.foldl makeFolderMapHelp Dict.empty folders


makeFolderMapHelp :
    F.AudienceFolder
    -> Dict.Dict Int String
    -> Dict.Dict Int String
makeFolderMapHelp { id, name } old =
    Dict.insert id name old


foldFail : (a -> b -> Result err b) -> b -> List a -> Result err b
foldFail f accumulator list =
    case list of
        [] ->
            Ok accumulator

        l :: ist ->
            case f l accumulator of
                Err err ->
                    Err err

                Ok ok ->
                    foldFail f ok ist


addAudience :
    Dict.Dict Int String
    -> A.Audience
    -> Data
    -> Result String Data
addAudience folderMap { id, name, folder } old =
    case folder of
        Nothing ->
            Ok
                { old
                    | rootAudiences = Set.insert name old.rootAudiences
                }

        Just parentId ->
            case Dict.get parentId folderMap of
                Nothing ->
                    Err <|
                        String.concat
                            [ "audience with name "
                            , name
                            , " and ID "
                            , String.fromInt id
                            , " has non-existent parent with ID "
                            , String.fromInt parentId
                            ]

                Just parentName ->
                    Ok
                        { old
                            | subAudiences =
                                Set.insert
                                    ( name, ( parentId, parentName ) )
                                    old.subAudiences
                        }


addFolder :
    Dict.Dict Int String
    -> F.AudienceFolder
    -> Data
    -> Result String Data
addFolder folderMap { name, id, parent } old =
    case parent of
        Nothing ->
            Ok
                { old
                    | rootFolders =
                        Set.insert ( id, name ) old.rootFolders
                }

        Just parentId ->
            case Dict.get parentId folderMap of
                Nothing ->
                    Err <|
                        String.concat
                            [ "folder with ID "
                            , String.fromInt id
                            , " and name "
                            , name
                            , " has non-existent parent with ID "
                            , String.fromInt parentId
                            ]

                Just parentName ->
                    Ok
                        { old
                            | subFolders =
                                Dict.insert
                                    ( id, name )
                                    ( parentId, parentName )
                                    old.subFolders
                        }


zeroDataSet : Data
zeroDataSet =
    { rootAudiences = Set.empty
    , subAudiences = Set.empty
    , rootFolders = Set.empty
    , subFolders = Dict.empty
    }


type alias Data =
    { rootAudiences : Set.Set String
    , subAudiences : Set.Set ( String, ( Int, String ) )
    , rootFolders : Set.Set ( Int, String )
    , subFolders : Dict.Dict ( Int, String ) ( Int, String )
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
