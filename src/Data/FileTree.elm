module FileTree exposing (FileTree(..), FolderId, FolderName, addFile, filterFiles, mapFolders, reverse, sortWith, toList)


type alias FolderName =
    String


type alias FolderId =
    Int


type FileTree file
    = File file
    | Folder
        { id : FolderId
        , name : FolderName
        , content : List (FileTree file)
        }


toList : FileTree file -> List file
toList tree =
    case tree of
        Folder { content } ->
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

                    Folder f ->
                        True
            )


mapFiles : (a -> b) -> FileTree a -> FileTree b
mapFiles f tree =
    case tree of
        File x ->
            File (f x)

        Folder { name, id, content } ->
            Folder { name = name, id = id, content = List.map (mapFiles f) content }


mapFolders : (List (FileTree a) -> List (FileTree a)) -> FileTree a -> FileTree a
mapFolders f tree =
    case tree of
        File file ->
            File file

        Folder folder ->
            Folder { folder | content = f (List.map (mapFolders f) folder.content) }


reverse : FileTree a -> FileTree a
reverse =
    mapFolders List.reverse


sortWith : (FileTree a -> FileTree a -> Order) -> FileTree a -> FileTree a
sortWith sorter =
    mapFolders (List.sortWith sorter)


addFile : file -> FolderId -> FileTree file -> FileTree file
addFile file folderId tree =
    case tree of
        File f ->
            File f

        -- We assume folderId is unique - hence no recursion in this branch
        -- (module for building the FileTree from API data will provide a function that checks it before building the tree)
        Folder folder ->
            if folder.id == folderId then
                Folder { folder | content = File file :: folder.content }

            else
                Folder { folder | content = List.map (addFile file folderId) folder.content }
