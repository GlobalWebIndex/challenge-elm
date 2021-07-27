module Parser exposing
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
                clean =
                    cleanUpData folders audiences
            in
            case checkData clean of
                Nothing ->
                    Ok clean

                Just err ->
                    Err err


checkData : Data -> Maybe String
checkData data =
    maybeChain
        [ allParentsAreFolders data
        , allParentsExist data.all (Dict.toList data.parents)
        ]


allParentsExist : Dict.Dict Int String -> List ( Int, Int ) -> Maybe String
allParentsExist all parents =
    case parents of
        [] ->
            Nothing

        ( child, parent ) :: arents ->
            case Dict.get parent all of
                Nothing ->
                    Just <|
                        String.concat
                            [ "parent with ID "
                            , String.fromInt parent
                            , " and child "
                            , String.fromInt child
                            , " does not exist"
                            ]

                Just _ ->
                    allParentsExist all arents


allParentsAreFolders : Data -> Maybe String
allParentsAreFolders { parents, audiences } =
    allParentsAreFoldersHelp audiences (Dict.toList parents)


allParentsAreFoldersHelp :
    Dict.Dict Int A.AudienceType
    -> List ( Int, Int )
    -> Maybe String
allParentsAreFoldersHelp audiences parents =
    case parents of
        [] ->
            Nothing

        ( child, parent ) :: arents ->
            case Dict.get parent audiences of
                Nothing ->
                    allParentsAreFoldersHelp audiences arents

                Just _ ->
                    Just <|
                        String.concat
                            [ "parent with ID "
                            , String.fromInt parent
                            , " and child "
                            , String.fromInt child
                            , " is not a folder"
                            ]


maybeChain : List (Maybe a) -> Maybe a
maybeChain maybes =
    case maybes of
        [] ->
            Nothing

        Nothing :: aybes ->
            maybeChain aybes

        (Just m) :: _ ->
            Just m


cleanUpData : List F.AudienceFolder -> List A.Audience -> Data
cleanUpData folders audiences =
    makeModel
        { folders = folders
        , audiences = audiences
        , model = zeroDataSet
        , unique = 0
        , folderIds = Dict.empty
        , audienceIds = Dict.empty
        }


type alias MakeModel =
    { folders : List F.AudienceFolder
    , audiences : List A.Audience
    , model : Data
    , unique : Int
    , folderIds : Dict.Dict Int Int
    , audienceIds : Dict.Dict Int Int
    }


zeroDataSet : Data
zeroDataSet =
    { parents = Dict.empty
    , audiences = Dict.empty
    , all = Dict.empty
    }


type alias Data =
    { parents : Dict.Dict Int Int
    , audiences : Dict.Dict Int A.AudienceType
    , all : Dict.Dict Int String
    }


makeModel : MakeModel -> Data
makeModel m =
    case m.folders of
        [] ->
            case m.audiences of
                [] ->
                    m.model

                a :: udiences ->
                    addAudience { m | audiences = udiences } a

        f :: olders ->
            addFolder { m | folders = olders } f


addAudience : MakeModel -> A.Audience -> Data
addAudience m a =
    case a.folder of
        Nothing ->
            addRootAudience m a

        Just parentId ->
            addSubAudience m a parentId


addFolder : MakeModel -> F.AudienceFolder -> Data
addFolder m f =
    case f.parent of
        Nothing ->
            addRootFolder m f

        Just parentId ->
            addSubFolder m f parentId


addSubFolder : MakeModel -> F.AudienceFolder -> Int -> Data
addSubFolder m f parentId =
    let
        newId =
            m.unique

        ( newParentId, newUnique ) =
            case Dict.get parentId m.folderIds of
                Nothing ->
                    ( m.unique + 1, m.unique + 2 )

                Just exists ->
                    ( exists, m.unique + 1 )

        model =
            m.model

        newModel =
            { model
                | parents = Dict.insert newId newParentId model.parents
                , all = Dict.insert newId f.name model.all
            }
    in
    makeModel
        { m
            | model = newModel
            , unique = newUnique
            , folderIds =
                Dict.insert
                    f.id
                    newId
                    (Dict.insert parentId newParentId m.folderIds)
        }


addSubAudience : MakeModel -> A.Audience -> Int -> Data
addSubAudience m a parentId =
    let
        newId =
            m.unique

        ( newParentId, newUnique ) =
            case Dict.get parentId m.folderIds of
                Nothing ->
                    ( m.unique + 1, m.unique + 2 )

                Just exists ->
                    ( exists, m.unique + 1 )

        model =
            m.model

        newModel =
            { model
                | parents = Dict.insert newId newParentId model.parents
                , audiences = Dict.insert newId a.type_ model.audiences
                , all = Dict.insert newId a.name model.all
            }
    in
    makeModel
        { m
            | model = newModel
            , unique = newUnique
            , folderIds =
                Dict.insert parentId newParentId m.folderIds
            , audienceIds =
                Dict.insert a.id newId m.audienceIds
        }


addRootFolder : MakeModel -> F.AudienceFolder -> Data
addRootFolder m f =
    let
        model =
            m.model

        newModel =
            { model
                | all = Dict.insert m.unique f.name model.all
            }
    in
    makeModel
        { m
            | model = newModel
            , unique = m.unique + 1
            , folderIds = Dict.insert f.id m.unique m.folderIds
        }


addRootAudience : MakeModel -> A.Audience -> Data
addRootAudience m a =
    let
        model =
            m.model

        newModel =
            { model
                | audiences =
                    Dict.insert m.unique a.type_ model.audiences
                , all = Dict.insert m.unique a.name model.all
            }
    in
    makeModel
        { m
            | model = newModel
            , unique = m.unique + 1
            , audienceIds = Dict.insert a.id m.unique m.audienceIds
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
