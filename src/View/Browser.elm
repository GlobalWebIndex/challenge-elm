module View.Browser exposing (BrowserModel(..), sortFilesAndFoldersAlphabetically)

import Data.Audience exposing (Audience)
import Data.FileSystem exposing (FileSystem(..), sortWith)
import Data.Focused.FileSystem exposing (FileSystemFocused)


type BrowserModel
    = FileSystemFocused Audience


sortFilesAndFoldersAlphabetically : FileSystem Audience -> FileSystem Audience
sortFilesAndFoldersAlphabetically =
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

                    ( File file1, File file2 ) ->
                        compare file1.name file2.name
