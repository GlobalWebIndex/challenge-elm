module Data.FileSystem exposing (FileForest, FileSystem(..), FolderName, filterFiles, mapFiles, mapFolders, reverse, sortFoldersAlphabetically, sortWith, toList)


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
