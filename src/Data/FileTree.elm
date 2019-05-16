module Data.FileTree exposing (FileTree(..), FolderId, FolderName, filterFiles, mapFolders, reverse, sortWith, toList)


type alias FolderName =
    String


type alias FolderId =
    Int


type FileTree file
    = File file
    | Folder FolderName (List (FileTree file))


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
