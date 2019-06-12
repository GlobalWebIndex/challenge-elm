module Data.FileSystem exposing
    ( FileSystem(..)
    , FolderName
    , filterFiles
    , flatten
    , mapFiles
    , mkFileSystem
    , reverse
    , sortAudienceFilesAndFoldersAlphabetically
    , sortFoldersAlphabetically
    , sortWith
    , toList
    )

import Data.Audience exposing (Audience)
import Data.AudienceFolder exposing (AudienceFolder)
import Data.List.Utility exposing (splitFilter)


type alias FolderName =
    String


type FileSystem file
    = File file
    | Folder FolderName (List (FileSystem file))


toList : FileSystem file -> List file
toList tree =
    case tree of
        Folder name content ->
            List.concatMap toList content

        File file ->
            [ file ]


{-| Data.FileSystem.flatten

merges all files into the root folder

-}
flatten : FileSystem file -> FileSystem file
flatten tree =
    case tree of
        File _ ->
            tree

        Folder name contents ->
            Folder name (List.map File <| toList tree)


filterFiles : (a -> Bool) -> FileSystem a -> FileSystem a
filterFiles check =
    updateFolders <|
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


updateFolders : (List (FileSystem a) -> List (FileSystem a)) -> FileSystem a -> FileSystem a
updateFolders f tree =
    case tree of
        File file ->
            File file

        Folder name content ->
            Folder name <| f <| List.map (updateFolders f) content


reverse : FileSystem a -> FileSystem a
reverse =
    updateFolders List.reverse


sortWith : (FileSystem a -> FileSystem a -> Order) -> FileSystem a -> FileSystem a
sortWith sorter =
    updateFolders (List.sortWith sorter)


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


{-| Interface with BE Audience & AudienceFolder

mkFileSystem transforms BE data into FileSystem of Audiences

-}
mkFileSystem : List AudienceFolder -> List Audience -> FileSystem Audience
mkFileSystem folders files =
    sortAudienceFilesAndFoldersAlphabetically <|
        mkFileSystemHelper
            folders
            (\af -> af.parent == Nothing)
            files
            (\a -> a.folder == Nothing)
            (Folder "ROOT" [])


mkFileSystemHelper :
    List AudienceFolder
    -> (AudienceFolder -> Bool)
    -> List Audience
    -> (Audience -> Bool)
    -> FileSystem Audience
    -> FileSystem Audience
mkFileSystemHelper folders folderFilter files fileFilter tree =
    case tree of
        File x ->
            File x

        Folder name content ->
            let
                ( subFolders, restFolders ) =
                    splitFilter folderFilter folders

                ( subFiles, restFiles ) =
                    splitFilter fileFilter files
            in
            Folder
                name
                (content
                    ++ List.map
                        (\subFolder ->
                            mkFileSystemHelper
                                restFolders
                                (\af -> af.parent == Just subFolder.id)
                                restFiles
                                (\a -> a.folder == Just subFolder.id)
                                (Folder subFolder.name [])
                        )
                        subFolders
                    ++ List.map File subFiles
                )


sortAudienceFilesAndFoldersAlphabetically : FileSystem Audience -> FileSystem Audience
sortAudienceFilesAndFoldersAlphabetically =
    sortWith <|
        \fs1 ->
            \fs2 ->
                case ( fs1, fs2 ) of
                    ( Folder _ _, File _ ) ->
                        LT

                    ( File _, Folder _ _ ) ->
                        GT

                    ( Folder name1 _, Folder name2 _ ) ->
                        compare name1 name2

                    ( File file1, File file2 ) ->
                        compare file1.name file2.name
