module Data.Store exposing (AudienceFolderID, AudienceID, Store)

import Data.Audience exposing (Audience)
import Data.AudienceFolder exposing (AudienceFolder)
import Dict exposing (Dict)
import Set exposing (Set)


type alias AudienceFolderID =
    Int


type alias AudienceID =
    Int


type alias AudienceLevel =
    { folders : Set AudienceFolderID
    , audiences : Set AudienceID
    }


emptyLevel : AudienceLevel
emptyLevel =
    AudienceLevel Set.empty Set.empty


insertFolderToLevel : AudienceFolderID -> AudienceLevel -> AudienceLevel
insertFolderToLevel folderID level =
    { level | folders = Set.insert folderID level.folders }


insertAudienceToLevel : AudienceID -> AudienceLevel -> AudienceLevel
insertAudienceToLevel audienceID level =
    { level | audiences = Set.insert audienceID level.audiences }


type alias Levels =
    Dict AudienceFolderID AudienceLevel


updateOnLevels : AudienceFolderID -> (AudienceLevel -> AudienceLevel) -> Levels -> Levels
updateOnLevels folderID tagger levels =
    Dict.update folderID (Just << tagger << Maybe.withDefault emptyLevel) levels


type Store
    = Store
        { folders : Dict AudienceFolderID AudienceFolder
        , audiences : Dict AudienceID Audience
        }
        { root : AudienceLevel
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



-- getLevelByFolderID : Maybe AudienceFolderID -> Store -> AudienceLevel
-- getLevelByFolderID targetFolderID (Store { folders, audiences }) =
--     { folders =
--         folders
--             |> Dict.filter (\_ folder -> targetFolderID == folder.parent)
--             |> Dict.values
--     , audiences =
--         audiences
--             |> Dict.filter (\_ audience -> targetFolderID == audience.folder)
--             |> Dict.values
--     }
-- getRoot : Store -> AudienceLevel
-- getRoot =
--     getLevelByFolderID Nothing
