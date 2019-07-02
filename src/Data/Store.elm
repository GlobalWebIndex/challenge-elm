module Data.Store exposing
    ( AudienceFolderID
    , AudienceID
    , AudienceLevel
    , Store
    , getLevelByFolderID
    , getRootLevel
    , init
    )

import Data.Audience exposing (Audience)
import Data.AudienceFolder exposing (AudienceFolder)
import Dict exposing (Dict)
import Set exposing (Set)


type alias AudienceFolderID =
    Int


type alias AudienceID =
    Int


type alias AudienceLevel =
    { folders : List AudienceFolder
    , audiences : List Audience
    }


type alias Level =
    { folders : Set AudienceFolderID
    , audiences : Set AudienceID
    }


emptyLevel : Level
emptyLevel =
    Level Set.empty Set.empty


insertFolderToLevel : AudienceFolderID -> Level -> Level
insertFolderToLevel folderID level =
    { level | folders = Set.insert folderID level.folders }


insertAudienceToLevel : AudienceID -> Level -> Level
insertAudienceToLevel audienceID level =
    { level | audiences = Set.insert audienceID level.audiences }


type alias Levels =
    Dict AudienceFolderID Level


updateOnLevels : AudienceFolderID -> (Level -> Level) -> Levels -> Levels
updateOnLevels folderID tagger levels =
    Dict.update folderID (Just << tagger << Maybe.withDefault emptyLevel) levels


type Store
    = Store
        { folders : Dict AudienceFolderID AudienceFolder
        , audiences : Dict AudienceID Audience
        }
        { root : Level
        , levels : Levels
        }


init : List AudienceFolder -> List Audience -> Store
init listOfFolders listOfAudiences =
    let
        data0 =
            { folders = Dict.empty
            , audiences = Dict.empty
            }

        relations0 =
            { root = emptyLevel
            , levels = Dict.empty
            }

        ( data1, relations1 ) =
            List.foldr
                (\folder ( data, relations ) ->
                    ( { data | folders = Dict.insert folder.id folder data.folders }
                    , case folder.parent of
                        Nothing ->
                            { relations | root = insertFolderToLevel folder.id relations.root }

                        Just parentID ->
                            { relations | levels = updateOnLevels parentID (insertFolderToLevel folder.id) relations.levels }
                    )
                )
                ( data0, relations0 )
                listOfFolders

        ( data2, relations2 ) =
            List.foldr
                (\audience ( data, relations ) ->
                    ( { data | audiences = Dict.insert audience.id audience data.audiences }
                    , case audience.folder of
                        Nothing ->
                            { relations | root = insertAudienceToLevel audience.id relations.root }

                        Just folderID ->
                            { relations | levels = updateOnLevels folderID (insertAudienceToLevel audience.id) relations.levels }
                    )
                )
                ( data1, relations1 )
                listOfAudiences
    in
    Store data2 relations2


extractListFromData : Set comparable -> Dict comparable { a | id : comparable } -> List { a | id : comparable }
extractListFromData ids entities =
    Set.foldr
        (\id acc ->
            case Dict.get id entities of
                Nothing ->
                    acc

                Just entity ->
                    entity :: acc
        )
        []
        ids


extractLevelByParentID : Maybe AudienceFolderID -> Store -> Maybe AudienceLevel
extractLevelByParentID mFolderID (Store data { root, levels }) =
    Maybe.map
        (\{ folders, audiences } ->
            { folders = extractListFromData folders data.folders
            , audiences = extractListFromData audiences data.audiences
            }
        )
        (case mFolderID of
            Nothing ->
                Just root

            Just folderID ->
                Dict.get folderID levels
        )


getRootLevel : Store -> Maybe AudienceLevel
getRootLevel =
    extractLevelByParentID Nothing


getLevelByFolderID : AudienceFolderID -> Store -> Maybe AudienceLevel
getLevelByFolderID =
    extractLevelByParentID << Just
