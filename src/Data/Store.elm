module Data.Store exposing
    ( AudienceFolderID
    , AudienceID
    , AudienceLevel
    , Selection(..)
    , Selector(..)
    , Store
    , getFolderByID
    , init
    , select
    )

import Data.Audience as Audience exposing (Audience, AudienceType)
import Data.AudienceFolder exposing (AudienceFolder)
import Dict exposing (Dict)


type alias AudienceFolderID =
    Int


type alias AudienceID =
    Int


type alias AudienceLevel =
    { folders : List AudienceFolder
    , audiences : List Audience
    }


type alias Level =
    { folders : List AudienceFolderID
    , curated : List AudienceID
    , authored : List AudienceID
    }


emptyLevel : Level
emptyLevel =
    Level [] [] []


insertFolderToLevel : AudienceFolderID -> Level -> Level
insertFolderToLevel folderID level =
    { level | folders = folderID :: level.folders }


insertAudienceToLevel : Audience -> List AudienceID -> Level -> ( List AudienceID, Level )
insertAudienceToLevel audience shared level =
    case audience.type_ of
        Audience.Authored ->
            ( shared, { level | authored = audience.id :: level.authored } )

        Audience.Shared ->
            ( audience.id :: shared, level )

        Audience.Curated ->
            ( shared, { level | curated = audience.id :: level.curated } )


type alias Levels =
    Dict AudienceFolderID Level


type alias Data =
    { folders : Dict AudienceFolderID AudienceFolder
    , audiences : Dict AudienceID Audience
    }


type alias Relations =
    { root : Level
    , levels : Levels
    , shared : List AudienceID
    }


type Store
    = Store Data Relations


initialData : Data
initialData =
    Data Dict.empty Dict.empty


initialRelations : Relations
initialRelations =
    Relations emptyLevel Dict.empty []


initEmptyLevels : List AudienceFolder -> ( Data, Relations ) -> ( Data, Relations )
initEmptyLevels listOfFolders ( data, relations ) =
    ( data
    , { relations | levels = Dict.fromList (List.map (\folder -> ( folder.id, emptyLevel )) listOfFolders) }
    )


buildFoldersDataAndRelations : List AudienceFolder -> ( Data, Relations ) -> ( Data, Relations )
buildFoldersDataAndRelations listOfFolders acc =
    List.foldr
        (\folder ( data, relations ) ->
            ( { data | folders = Dict.insert folder.id folder data.folders }
            , case folder.parent of
                Nothing ->
                    { relations | root = insertFolderToLevel folder.id relations.root }

                Just parentID ->
                    let
                        nextLevel =
                            Dict.get parentID relations.levels
                                |> Maybe.withDefault emptyLevel
                                |> insertFolderToLevel folder.id
                    in
                    { relations | levels = Dict.insert parentID nextLevel relations.levels }
            )
        )
        acc
        listOfFolders


buildAudiencesDataAndRelations : List Audience -> ( Data, Relations ) -> ( Data, Relations )
buildAudiencesDataAndRelations listOfAudiences acc =
    List.foldr
        (\audience ( data, relations ) ->
            ( { data | audiences = Dict.insert audience.id audience data.audiences }
            , case audience.folder of
                Nothing ->
                    let
                        ( nextShared, nextRoot ) =
                            insertAudienceToLevel audience relations.shared relations.root
                    in
                    { relations
                        | root = nextRoot
                        , shared = nextShared
                    }

                Just folderID ->
                    let
                        ( nextShared, nextLevel ) =
                            Dict.get folderID relations.levels
                                |> Maybe.withDefault emptyLevel
                                |> insertAudienceToLevel audience relations.shared
                    in
                    { relations
                        | levels = Dict.insert folderID nextLevel relations.levels
                        , shared = nextShared
                    }
            )
        )
        acc
        listOfAudiences


init : List AudienceFolder -> List Audience -> Store
init listOfFolders listOfAudiences =
    let
        ( data, relations ) =
            ( initialData, initialRelations )
                |> initEmptyLevels listOfFolders
                |> buildFoldersDataAndRelations listOfFolders
                |> buildAudiencesDataAndRelations listOfAudiences
    in
    Store data relations


extractListFromData : List comparable -> Dict comparable { a | id : comparable } -> List { a | id : comparable }
extractListFromData ids entities =
    List.filterMap (\id -> Dict.get id entities) ids


type Selector
    = OnlyShared
    | OnlyCurated
    | OnlyCuratedIn AudienceFolderID
    | OnlyAuthored
    | OnlyAuthoredIn AudienceFolderID


type Selection
    = NotFound AudienceFolderID
    | Root AudienceLevel
    | Folder AudienceFolder AudienceLevel


select : Selector -> Store -> Selection
select selector (Store data { root, levels, shared }) =
    case selector of
        OnlyShared ->
            AudienceLevel
                []
                (extractListFromData shared data.audiences)
                |> Root

        OnlyCurated ->
            AudienceLevel
                (extractListFromData root.folders data.folders)
                (extractListFromData root.curated data.audiences)
                |> Root

        OnlyCuratedIn folderID ->
            case ( Dict.get folderID data.folders, Dict.get folderID levels ) of
                ( Just folder, Just level ) ->
                    AudienceLevel
                        (extractListFromData level.folders data.folders)
                        (extractListFromData level.curated data.audiences)
                        |> Folder folder

                _ ->
                    NotFound folderID

        OnlyAuthored ->
            AudienceLevel
                (extractListFromData root.folders data.folders)
                (extractListFromData root.authored data.audiences)
                |> Root

        OnlyAuthoredIn folderID ->
            case ( Dict.get folderID data.folders, Dict.get folderID levels ) of
                ( Just folder, Just level ) ->
                    AudienceLevel
                        (extractListFromData level.folders data.folders)
                        (extractListFromData level.authored data.audiences)
                        |> Folder folder

                _ ->
                    NotFound folderID


getFolderByID : AudienceFolderID -> Store -> Maybe AudienceFolder
getFolderByID folderID (Store data _) =
    Dict.get folderID data.folders
