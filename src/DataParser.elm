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
            Result.map2
                repackData
                (badMap (audienceNameParent folderMap) audiences)
                (badMap (folderNameParent folderMap) folders)


repackData : List AudienceNamedParent -> List FolderNamedParent -> Data
repackData audiences folders =
    let
        ( rootAudiences, subAudiences ) =
            partitionMap splitAudiences audiences

        ( rootFolders, subFolders ) =
            partitionMap splitFolders folders
    in
    { rootAudiences = Set.fromList rootAudiences
    , subAudiences = Set.fromList subAudiences
    , rootFolders = Set.fromList rootFolders
    , subFolders = Dict.fromList subFolders
    }


splitAudiences :
    AudienceNamedParent
    -> Either String ( String, ( Int, String ) )
splitAudiences { name, parent } =
    case parent of
        Nothing ->
            Left name

        Just parentId ->
            Right ( name, parentId )


splitFolders :
    FolderNamedParent
    -> Either ( Int, String ) ( ( Int, String ), ( Int, String ) )
splitFolders { id, name, parent } =
    case parent of
        Nothing ->
            Left ( id, name )

        Just parentId ->
            Right ( ( id, name ), parentId )


partitionMap : (a -> Either b c) -> List a -> ( List b, List c )
partitionMap splitter as_ =
    partitionMapHelp splitter as_ ( [], [] )


partitionMapHelp :
    (a -> Either b c)
    -> List a
    -> ( List b, List c )
    -> ( List b, List c )
partitionMapHelp splitter as_ ( bs, cs ) =
    case as_ of
        [] ->
            ( List.reverse bs, List.reverse cs )

        a :: s ->
            partitionMapHelp splitter s <|
                case splitter a of
                    Left b ->
                        ( b :: bs, cs )

                    Right c ->
                        ( bs, c :: cs )


badMap : (a -> Result b c) -> List a -> Result b (List c)
badMap f as_ =
    badMapHelp f as_ []


badMapHelp : (a -> Result b c) -> List a -> List c -> Result b (List c)
badMapHelp f as_ accum =
    case as_ of
        [] ->
            Ok (List.reverse accum)

        a :: s ->
            case f a of
                Err err ->
                    Err err

                Ok ok ->
                    badMapHelp f s (ok :: accum)


type alias FolderNamedParent =
    { id : Int
    , name : String
    , parent : Maybe ( Int, String )
    }


folderNameParent :
    Dict.Dict Int String
    -> F.AudienceFolder
    -> Result String FolderNamedParent
folderNameParent folderMap { id, name, parent } =
    case parent of
        Nothing ->
            Ok { id = id, name = name, parent = Nothing }

        Just folderId ->
            case Dict.get folderId folderMap of
                Nothing ->
                    Err <|
                        String.concat
                            [ "audience with ID "
                            , String.fromInt id
                            , " and name \""
                            , name
                            , "\" has a non-existent parent with ID "
                            , String.fromInt folderId
                            ]

                Just folderName ->
                    Ok
                        { id = id
                        , name = name
                        , parent = Just ( folderId, folderName )
                        }


type alias AudienceNamedParent =
    { name : String
    , parent : Maybe ( Int, String )
    }


audienceNameParent :
    Dict.Dict Int String
    -> A.Audience
    -> Result String AudienceNamedParent
audienceNameParent folderMap { id, name, folder } =
    case folder of
        Nothing ->
            Ok { name = name, parent = Nothing }

        Just parentId ->
            case Dict.get parentId folderMap of
                Nothing ->
                    Err <|
                        String.concat
                            [ "audience with ID "
                            , String.fromInt id
                            , " and name \""
                            , name
                            , "\" has a non-existent parent with ID "
                            , String.fromInt parentId
                            ]

                Just parentName ->
                    Ok
                        { name = name
                        , parent = Just ( parentId, parentName )
                        }


type Either a b
    = Left a
    | Right b


makeFolderMap : List F.AudienceFolder -> Dict.Dict Int String
makeFolderMap folders =
    List.foldl makeFolderMapHelp Dict.empty folders


makeFolderMapHelp :
    F.AudienceFolder
    -> Dict.Dict Int String
    -> Dict.Dict Int String
makeFolderMapHelp { id, name } old =
    Dict.insert id name old


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
