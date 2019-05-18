module Data.FileSystem exposing (FileForest, FileSystem(..), FileSystemFocused, FolderName, FolderWithHole(..), filterFiles, focus, mapFiles, mapFolders, reverse, sortFoldersAlphabetically, sortWith, stepDown, stepUp, toList)

---------------------
-- FileSystem data type
---------------------

import Data.Focused.List exposing (ListWithHole(..), focusIn)
import List.Extra exposing (uncons)


type alias FolderName =
    String


type FileSystem file
    = File file
    | Folder FolderName (FileForest file)


type alias FileForest a =
    List (FileSystem a)


toList : FileSystem file -> List file
toList tree =
    case tree of
        Folder name content ->
            List.concatMap toList content

        File file ->
            [ file ]


filterFiles : (a -> Bool) -> FileSystem a -> FileSystem a
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


mapFiles : (a -> b) -> FileSystem a -> FileSystem b
mapFiles f tree =
    case tree of
        File x ->
            File (f x)

        Folder name content ->
            Folder name (List.map (mapFiles f) content)


mapFolders : (List (FileSystem a) -> List (FileSystem a)) -> FileSystem a -> FileSystem a
mapFolders f tree =
    case tree of
        File file ->
            File file

        Folder name content ->
            Folder name <| f <| List.map (mapFolders f) content


reverse : FileSystem a -> FileSystem a
reverse =
    mapFolders List.reverse


sortWith : (FileSystem a -> FileSystem a -> Order) -> FileSystem a -> FileSystem a
sortWith sorter =
    mapFolders (List.sortWith sorter)


sortFoldersAlphabetically : FileSystem a -> FileSystem a
sortFoldersAlphabetically =
    sortWith <|
        \fs1 ->
            \fs2 ->
                case ( fs1, fs2 ) of
                    ( Folder _ _, File _ ) ->
                        GT

                    ( File _, Folder _ _ ) ->
                        LT

                    ( Folder name1 _, Folder name2 _ ) ->
                        compare name1 name2

                    ( File _, File _ ) ->
                        EQ



-----------------------------
-- Focused FileSystem data type
-----------------------------


type FolderWithHole a
    = FolderWithHole FolderName (FileForest a) (FileForest a)


type alias FileSystemFocused a =
    ( List (FolderWithHole a), FileSystem a )


focus : FileSystem a -> Maybe (FileSystemFocused a)
focus tree =
    case tree of
        File _ ->
            Nothing

        Folder _ _ ->
            Just ( [], tree )


stepUp : FileSystemFocused a -> Maybe (FileSystemFocused a)
stepUp focTree =
    case focTree of
        ( [], _ ) ->
            Nothing

        ( (FolderWithHole name leftOfHole rightOfHole) :: crumbs, tree ) ->
            Just ( crumbs, Folder name <| leftOfHole ++ [ tree ] ++ rightOfHole )


stepDown : Int -> FileSystemFocused a -> Maybe (FileSystemFocused a)
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
