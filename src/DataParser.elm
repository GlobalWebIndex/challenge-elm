module DataParser exposing
    ( decodeAudiences
    , decodeFolders
    , decodeOneAudience
    , decodeOneFolder
    , parse
    )

import Array
import Data.Audience as A
import Data.AudienceFolder as F
import Dict
import Json.Decode as Jd


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
            processParsedJson folders audiences


processParsedJson folders audiences =
    let
        ( rootFolders, subFolders ) =
            partitionMap splitFolders folders

        newFolderIds : Dict.Dict Int Int
        newFolderIds =
            List.map .id subFolders
                ++ List.map .id rootFolders
                |> List.indexedMap (\new old -> ( old, new ))
                |> Dict.fromList

        ( rootAudiences, subAudiences ) =
            partitionMap splitAudiences audiences

        subAudienceIds : List Int
        subAudienceIds =
            List.map .parent subAudiences

        subFolderIds : List Int
        subFolderIds =
            List.map .parent subFolders
    in
    Result.map2
        (\audienceParents folderParents ->
            { audienceNames =
                List.map .name subAudiences
                    ++ rootAudiences
                    |> Array.fromList
            , audienceParents = audienceParents
            , folderNames =
                List.map .name subFolders
                    ++ List.map .name rootFolders
                    |> Array.fromList
            , folderParents = folderParents
            }
        )
        (updateParents newFolderIds subAudienceIds)
        (updateParents newFolderIds subFolderIds)


updateParents :
    Dict.Dict Int Int
    -> List Int
    -> Result String (Array.Array Int)
updateParents newFolderIds parents =
    badMap (updateParent newFolderIds) parents
        |> Result.map Array.fromList


updateParent :
    Dict.Dict Int Int
    -> Int
    -> Result String Int
updateParent newFolderIds oldParent =
    case Dict.get oldParent newFolderIds of
        Nothing ->
            [ "Audience or folder has non-existent parent with ID "
            , String.fromInt oldParent
            ]
                |> String.concat
                |> Err

        Just newFolderId ->
            Ok newFolderId


splitAudiences :
    A.Audience
    -> Either String { name : String, parent : Int }
splitAudiences { name, folder } =
    case folder of
        Nothing ->
            Left name

        Just parentId ->
            Right { name = name, parent = parentId }


splitFolders :
    F.AudienceFolder
    ->
        Either
            { id : Int, name : String }
            { id : Int, name : String, parent : Int }
splitFolders { id, name, parent } =
    case parent of
        Nothing ->
            Left { id = id, name = name }

        Just parentId ->
            Right { id = id, name = name, parent = parentId }


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


type Either a b
    = Left a
    | Right b


type alias Data =
    { audienceNames : Array.Array String
    , audienceParents : Array.Array Int
    , folderNames : Array.Array String
    , folderParents : Array.Array Int
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
