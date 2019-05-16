module Main exposing (audienceFolders, audiences, main, mkFileTree, mkFileTreeHelper, splitFilter)

import Data.Audience exposing (Audience, audiencesDecoder, audiencesJSON)
import Data.AudienceFolder exposing (AudienceFolder, audienceFoldersDecoder, audienceFoldersJSON)
import Data.FileTree as FT exposing (FileTree(..))
import Html exposing (Html)
import Json.Decode exposing (decodeString)


audienceFolders =
    Result.withDefault [] <| decodeString audienceFoldersDecoder audienceFoldersJSON


audiences =
    Result.withDefault [] <| decodeString audiencesDecoder audiencesJSON


mkFileTree : List AudienceFolder -> List Audience -> FileTree Audience
mkFileTree folders files =
    mkFileTreeHelper
        folders
        (\af -> af.parent == Nothing)
        files
        (\a -> a.folder == Nothing)
        (Folder "ROOT" [])


mkFileTreeHelper :
    List AudienceFolder
    -> (AudienceFolder -> Bool)
    -> List Audience
    -> (Audience -> Bool)
    -> FileTree Audience
    -> FileTree Audience
mkFileTreeHelper folders folderFilter files fileFilter tree =
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
                            mkFileTreeHelper
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
