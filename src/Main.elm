module Main exposing (audienceFolders, audiences, main, mkFileSystem, mkFileSystemHelper, splitFilter)

import Data.Audience exposing (Audience, audiencesDecoder, audiencesJSON)
import Data.AudienceFolder exposing (AudienceFolder, audienceFoldersDecoder, audienceFoldersJSON)
import Data.FileSystem as FT exposing (FileSystem(..), sortWith)
import Html exposing (Html)
import Json.Decode exposing (decodeString)


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


audienceFolders =
    Result.withDefault [] <| decodeString audienceFoldersDecoder audienceFoldersJSON


audiences =
    Result.withDefault [] <| decodeString audiencesDecoder audiencesJSON


mkFileSystem : List AudienceFolder -> List Audience -> FileSystem Audience
mkFileSystem folders files =
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


splitFilter : (a -> Bool) -> List a -> ( List a, List a )
splitFilter check =
    List.foldl
        (\x ->
            (if check x then
                Tuple.mapFirst

             else
                Tuple.mapSecond
            )
                (\xs -> x :: xs)
        )
        ( [], [] )


main : Html msg
main =
    Html.text "There will be app soon!"
