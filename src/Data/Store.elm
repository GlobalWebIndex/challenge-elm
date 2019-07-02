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


type Store
    = Store
        { folders : Dict AudienceFolderID AudienceFolder
        , audiences : Dict AudienceID Audience
        }
        { root : AudienceLevel
        , levels : Dict AudienceFolderID AudienceLevel
        }


listToDict : List { entity | id : comparable } -> Dict comparable { entity | id : comparable }
listToDict =
    List.foldr (\entity -> Dict.insert entity.id entity) Dict.empty


init : List AudienceFolder -> List Audience -> Store
init listOfFolders listOfAudiences =
    let
        data0 =
            { folders = Dict.empty
            , audiences = Dict.empty
            }

        relations0 =
            { root = AudienceLevel Set.empty Set.empty
            , levels = Dict.empty
            }

        ( data1, relations1 ) =
            List.foldr
                (\folder ( data, { root, levels } ) ->
                    ( { data | folders = Dict.insert folder.id folder data.folders }
                    , case folder.parent of
                        Nothing ->
                            { root = AudienceLevel (Set.insert folder.id root.folders) root.audiences
                            , levels = levels
                            }

                        Just parentID ->
                            { root = root
                            , levels =
                                Dict.update parentID
                                    (\mLevel ->
                                        case mLevel of
                                            Nothing ->
                                                Just (AudienceLevel (Set.singleton folder.id) Set.empty)

                                            Just level ->
                                                Just { level | folders = Set.insert folder.id level.folders }
                                    )
                                    levels
                            }
                    )
                )
                ( data0, relations0 )
                listOfFolders

        ( data2, relations2 ) =
            List.foldr
                (\audience ( data, { root, levels } ) ->
                    ( { data | audiences = Dict.insert audience.id audience data.audiences }
                    , case audience.folder of
                        Nothing ->
                            { root = AudienceLevel root.folders (Set.insert audience.id root.audiences)
                            , levels = levels
                            }

                        Just folderID ->
                            { root = root
                            , levels =
                                Dict.update folderID
                                    (\mLevel ->
                                        case mLevel of
                                            Nothing ->
                                                Just (AudienceLevel Set.empty (Set.singleton audience.id))

                                            Just level ->
                                                Just { level | audiences = Set.insert audience.id level.audiences }
                                    )
                                    levels
                            }
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
