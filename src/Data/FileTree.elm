module Data.FileTree exposing (FileTree(..), FolderName, filterFiles, mapFolders, reverse, sortWith, toList)

---------------------
-- FileTree data type
---------------------

import Data.ListFocused exposing (ListWithHole(..), focusIn)
import List.Extra exposing (uncons)


type alias FolderName =
    String


type FileTree file
    = File file
    | Folder FolderName (FileForest file)


type alias FileForest a =
    List (FileTree a)


toList : FileTree file -> List file
toList tree =
    case tree of
        Folder name content ->
            List.concatMap toList content

        File file ->
            [ file ]


filterFiles : (a -> Bool) -> FileTree a -> FileTree a
filterFiles check =
    mapFolders <|
        List.filter
            (\ft ->
                case ft of
                    File a ->
                        check a

                    Folder _ _ ->
                        True
            )


mapFiles : (a -> b) -> FileTree a -> FileTree b
mapFiles f tree =
    case tree of
        File x ->
            File (f x)

        Folder name content ->
            Folder name (List.map (mapFiles f) content)


mapFolders : (List (FileTree a) -> List (FileTree a)) -> FileTree a -> FileTree a
mapFolders f tree =
    case tree of
        File file ->
            File file

        Folder name content ->
            Folder name <| f <| List.map (mapFolders f) content


reverse : FileTree a -> FileTree a
reverse =
    mapFolders List.reverse


sortWith : (FileTree a -> FileTree a -> Order) -> FileTree a -> FileTree a
sortWith sorter =
    mapFolders (List.sortWith sorter)



-----------------------------
-- Focused FileTree data type
-----------------------------


type FolderWithHole a
    = FolderWithHole FolderName (FileForest a) (FileForest a)


type alias FileTreeFocused a =
    ( List (FolderWithHole a), FileTree a )


focus : FileTree a -> Maybe (FileTreeFocused a)
focus tree =
    case tree of
        File _ ->
            Nothing

        Folder _ _ ->
            Just ( [], tree )


stepUp : FileTreeFocused a -> Maybe (FileTreeFocused a)
stepUp focTree =
    case focTree of
        ( [], _ ) ->
            Nothing

        ( (FolderWithHole name leftOfHole rightOfHole) :: crumbs, tree ) ->
            Just ( crumbs, Folder name <| leftOfHole ++ [ tree ] ++ rightOfHole )


stepDown : Int -> FileTreeFocused a -> Maybe (FileTreeFocused a)
stepDown n ( crumbs, tree ) =
    case tree of
        File _ ->
            Nothing

        Folder name forest ->
            let
                focusedForest =
                    focusIn n forest
            in
            case focusedForest of
                Nothing ->
                    Nothing

                Just ( ListWithHole left right, focusedTree ) ->
                    Just ( FolderWithHole name left right :: crumbs, focusedTree )
