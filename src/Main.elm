module Main exposing (..)

import Browser
import Data.Audience as A
import Data.AudienceFolder as F
import Dict
import Html
import Html.Attributes as Hat
import Html.Events as Hev
import Json.Decode as Jd
import Set


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


type Msg
    = FolderClick Int
    | GoUpClick


type Model
    = BadAudiences Jd.Error
    | BadFolders Jd.Error
    | AllGood GoodModel


type alias GoodModel =
    { parents : Dict.Dict Int Int
    , folders : Set.Set Int
    , audiences : Dict.Dict Int A.AudienceType
    , all : Dict.Dict Int String
    , current : Dict.Dict Int String
    }


type OneItem
    = OneFolder Int
    | OneAudience Int


getOneTopLevelFolderId : List F.AudienceFolder -> Maybe Int
getOneTopLevelFolderId folders =
    case folders of
        [] ->
            Nothing

        { parent } :: olders ->
            case parent of
                Nothing ->
                    getOneTopLevelFolderId olders

                Just id ->
                    Just id


getOneTopLevelAudienceId : List A.Audience -> Maybe Int
getOneTopLevelAudienceId audiences =
    case audiences of
        [] ->
            Nothing

        { folder } :: udiences ->
            case folder of
                Nothing ->
                    getOneTopLevelAudienceId udiences

                Just id ->
                    Just id


view : Model -> Html.Html Msg
view model =
    case model of
        BadAudiences err ->
            Html.text <|
                String.concat
                    [ "problem parsing audiences: "
                    , Jd.errorToString err
                    ]

        BadFolders err ->
            Html.text <|
                String.concat
                    [ "problem parsing folders: "
                    , Jd.errorToString err
                    ]

        AllGood good ->
            viewGood good


viewGood model =
    Html.div
        [ Hat.id "container" ]
    <|
        List.concat
            [ goUpView model
            , foldersView model
            , audiencesView model
            ]


goUpView : GoodModel -> List (Html.Html Msg)
goUpView model =
    case Dict.toList model.current of
        [] ->
            []

        ( id, _ ) :: _ ->
            case Dict.get id model.parents of
                Nothing ->
                    []

                Just _ ->
                    [ Html.button
                        [ Hev.onClick GoUpClick ]
                        [ Html.text "Go up" ]
                    ]


foldersView : GoodModel -> List (Html.Html Msg)
foldersView model =
    List.map oneFolderView <|
        Dict.toList <|
            Dict.filter (isFolder model.folders) model.current


isFolder : Set.Set Int -> Int -> String -> Bool
isFolder folders id _ =
    Set.member id folders


oneFolderView : ( Int, String ) -> Html.Html Msg
oneFolderView ( folderId, name ) =
    Html.button
        [ Hev.onClick <| FolderClick folderId ]
        [ Html.text name ]


audiencesView : GoodModel -> List (Html.Html Msg)
audiencesView model =
    List.map oneAudienceView <|
        Dict.toList <|
            Dict.filter (isAudience model.folders) model.current


isAudience : Set.Set Int -> Int -> String -> Bool
isAudience folders id _ =
    not <| Set.member id folders


oneAudienceView : ( Int, String ) -> Html.Html Msg
oneAudienceView ( _, name ) =
    Html.span [] [ Html.text name ]


update : Msg -> Model -> Model
update msg model =
    case model of
        BadAudiences _ ->
            model

        BadFolders _ ->
            model

        AllGood ok ->
            AllGood <| updateGood msg ok


updateGood : Msg -> GoodModel -> GoodModel
updateGood msg model =
    case msg of
        FolderClick id ->
            { model
                | current = getChildrenOf id model.all model.parents
            }

        GoUpClick ->
            case Dict.toList model.current of
                [] ->
                    model

                ( id, _ ) :: _ ->
                    case Dict.get id model.parents of
                        Nothing ->
                            model

                        Just parent ->
                            goUp model parent


goUp : GoodModel -> Int -> GoodModel
goUp model upperChild =
    case Dict.get upperChild model.parents of
        Nothing ->
            { model
                | current = getTopLevel model.all model.parents
            }

        Just upperParent ->
            { model
                | current = getChildrenOf upperParent model.all model.parents
            }


getTopLevel : Dict.Dict Int String -> Dict.Dict Int Int -> Dict.Dict Int String
getTopLevel all parents =
    Dict.filter (isRoot parents) all


isRoot : Dict.Dict Int Int -> Int -> String -> Bool
isRoot parents child _ =
    Dict.get child parents == Nothing


getChildrenOf : Int -> Dict.Dict Int String -> Dict.Dict Int Int -> Dict.Dict Int String
getChildrenOf parent all parents =
    Dict.filter (getChildrenHelp (getChildIds parent parents)) all


getChildrenHelp : Set.Set Int -> Int -> String -> Bool
getChildrenHelp childIds potentialChild _ =
    Set.member potentialChild childIds


getChildIds : Int -> Dict.Dict Int Int -> Set.Set Int
getChildIds parent parents =
    Set.fromList <|
        Dict.keys <|
            Dict.filter (parentIs parent) parents


parentIs : Int -> Int -> Int -> Bool
parentIs parent _ potentialParent =
    parent == potentialParent


getTopLevelHelp : Dict.Dict Int Int -> ( Int, String ) -> Bool
getTopLevelHelp parents ( id, _ ) =
    Dict.get id parents == Nothing


getFolderChildrenOf : Int -> Dict.Dict Int F.AudienceFolder -> Set.Set Int
getFolderChildrenOf id folders =
    Set.fromList <|
        Dict.keys <|
            Dict.filter (getFolderChildrenHelp id) folders


getFolderChildrenHelp id _ { parent } =
    case parent of
        Nothing ->
            False

        Just p ->
            p == id


getAudienceChildrenOf : Int -> Dict.Dict Int A.Audience -> Set.Set Int
getAudienceChildrenOf id audiences =
    Set.fromList <|
        Dict.keys <|
            Dict.filter (getAudienceChildrenHelp id) audiences


getAudienceChildrenHelp : Int -> Int -> A.Audience -> Bool
getAudienceChildrenHelp id _ { folder } =
    case folder of
        Nothing ->
            False

        Just f ->
            f == id


zeroModel : GoodModel
zeroModel =
    { parents = Dict.empty
    , folders = Set.empty
    , audiences = Dict.empty
    , all = Dict.empty
    , current = Dict.empty
    }


init : Model
init =
    case ( folderParseResult, audiencesParseResult ) of
        ( Err err, _ ) ->
            BadFolders err

        ( _, Err err ) ->
            BadAudiences err

        ( Ok folders, Ok audiences ) ->
            AllGood <| cleanUpData folders audiences


cleanUpData : List F.AudienceFolder -> List A.Audience -> GoodModel
cleanUpData folders audiences =
    makeModel
        { folders = folders
        , audiences = audiences
        , model = zeroModel
        , unique = 0
        , folderIds = Dict.empty
        , audienceIds = Dict.empty
        }


type alias MakeModel =
    { folders : List F.AudienceFolder
    , audiences : List A.Audience
    , model : GoodModel
    , unique : Int
    , folderIds : Dict.Dict Int Int
    , audienceIds : Dict.Dict Int Int
    }


makeModel : MakeModel -> GoodModel
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


addAudience : MakeModel -> A.Audience -> GoodModel
addAudience m a =
    case a.folder of
        Nothing ->
            addRootAudience m a

        Just parentId ->
            addSubAudience m a parentId


addFolder : MakeModel -> F.AudienceFolder -> GoodModel
addFolder m f =
    case f.parent of
        Nothing ->
            addRootFolder m f

        Just parentId ->
            addSubFolder m f parentId


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
                , folders = Set.insert newId model.folders
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


addRootFolder m f =
    let
        model =
            m.model

        newModel =
            { model
                | folders = Set.insert m.unique model.folders
                , all = Dict.insert m.unique f.name model.all
                , current = Dict.insert m.unique f.name model.current
            }
    in
    makeModel
        { m
            | model = newModel
            , unique = m.unique + 1
            , folderIds = Dict.insert f.id m.unique m.folderIds
        }


addRootAudience m a =
    let
        model =
            m.model

        newModel =
            { model
                | audiences =
                    Dict.insert m.unique a.type_ model.audiences
                , all = Dict.insert m.unique a.name model.all
                , current = Dict.insert m.unique a.name model.current
            }
    in
    makeModel
        { m
            | model = newModel
            , unique = m.unique + 1
            , audienceIds = Dict.insert a.id m.unique m.audienceIds
        }


toDict list =
    Dict.fromList <| List.map toDictHelp list


toDictHelp item =
    ( item.id, item )


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
