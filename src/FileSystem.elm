module FileSystem exposing
    ( FileSystem
    , cd
    , currentFolder
    , files
    , folders
    , toFileSystem
    , up
    )

import Data.Audience exposing (Audience)
import Data.AudienceFolder exposing (AudienceFolder)
import Dict exposing (Dict)
import Tree exposing (Tree)
import Tree.Zipper as Zipper exposing (Zipper)


type FileSystem folder file
    = FileSystem
        (Zipper
            { folder : folder
            , files : List file
            }
        )


type alias FolderInfo =
    { folder : AudienceFolder
    , childFolders : List AudienceFolder
    , childAudiences : List Audience
    }


toFileSystem :
    List AudienceFolder
    -> List Audience
    -> FileSystem AudienceFolder Audience
toFileSystem folders_ audiences =
    let
        hierarchy : Dict Int FolderInfo
        hierarchy =
            -- make a dict entry for every folder
            List.foldr
                (\folder ->
                    Dict.insert folder.id
                        { folder = folder
                        , childFolders = []
                        , childAudiences = []
                        }
                )
                Dict.empty
                folders_
                -- fill in the child folders
                |> (\dict ->
                        List.foldr
                            (\folder acc ->
                                case folder.parent of
                                    Just id ->
                                        Dict.get id acc
                                            |> Maybe.map
                                                (\parent ->
                                                    Dict.insert id
                                                        { parent
                                                            | childFolders =
                                                                folder :: parent.childFolders
                                                        }
                                                        acc
                                                )
                                            |> Maybe.withDefault acc

                                    Nothing ->
                                        acc
                            )
                            dict
                            folders_
                   )
                -- fill in child audiences
                |> (\dict ->
                        List.foldr
                            (\audience acc ->
                                case audience.folder of
                                    Just id ->
                                        Dict.get id acc
                                            |> Maybe.map
                                                (\parent ->
                                                    Dict.insert id
                                                        { parent
                                                            | childAudiences =
                                                                audience :: parent.childAudiences
                                                        }
                                                        acc
                                                )
                                            |> Maybe.withDefault acc

                                    Nothing ->
                                        acc
                            )
                            dict
                            audiences
                   )

        topFiles : List Audience
        topFiles =
            List.filter ((==) Nothing << .folder) audiences

        topFolders : List FolderInfo
        topFolders =
            Dict.foldr
                (\_ folderInfo acc ->
                    if folderInfo.folder.parent == Nothing then
                        folderInfo :: acc

                    else
                        acc
                )
                []
                hierarchy

        unfolder :
            FolderInfo
            ->
                ( { folder : AudienceFolder
                  , files : List Audience
                  }
                , List FolderInfo
                )
        unfolder { folder, childFolders, childAudiences } =
            ( { folder = folder
              , files = childAudiences
              }
            , List.filterMap (\f -> Dict.get f.id hierarchy) childFolders
            )

        root : AudienceFolder
        root =
            { id = 0
            , name = "root"
            , parent = Nothing
            }
    in
    Tree.tree
        { folder = root
        , files = topFiles
        }
        (List.map (Tree.unfold unfolder) topFolders)
        -- sort the AudienceFolders by name
        |> Tree.mapChildren (List.sortBy (\tree -> (Tree.label tree).folder.name))
        -- sort the Aundiences by name
        |> Tree.mapLabel
            (\label ->
                { label | files = List.sortBy .name label.files }
            )
        |> Zipper.fromTree
        |> FileSystem


folders : FileSystem folder file -> List folder
folders (FileSystem zipper) =
    Zipper.children zipper
        |> List.map (Tree.label >> .folder)


files : FileSystem folder file -> List file
files (FileSystem zipper) =
    (Zipper.label zipper).files


currentFolder : FileSystem folder file -> Maybe folder
currentFolder (FileSystem zipper) =
    if atRoot zipper then
        Nothing

    else
        Just (Zipper.label zipper).folder


cd : Int -> FileSystem folder file -> FileSystem folder file
cd index (FileSystem zipper) =
    FileSystem <|
        case nthChild index zipper of
            Just z ->
                z

            Nothing ->
                zipper


up : FileSystem folder file -> FileSystem folder file
up (FileSystem zipper) =
    FileSystem <|
        case Zipper.parent zipper of
            Just z ->
                z

            Nothing ->
                zipper



-- Zipper Functions


atRoot : Zipper a -> Bool
atRoot zipper =
    if Zipper.parent zipper == Nothing then
        True

    else
        False


nthChild : Int -> Zipper a -> Maybe (Zipper a)
nthChild index zipper =
    Zipper.firstChild zipper
        |> Maybe.andThen (nthSibling index)


nthSibling : Int -> Zipper a -> Maybe (Zipper a)
nthSibling index zipper =
    if index == 0 then
        Just zipper

    else
        Zipper.nextSibling zipper
            |> Maybe.andThen (nthSibling <| index - 1)
