module FileSystem exposing (..)

{-| File system consist of files and folders.
In a file system you can open folders, go up to the parent folder, get the current folder and its folders, files
-}

import Zipper exposing (Zipper)


type alias FileSystem a b =
    Zipper (FSEntry a b)


{-| Representing the common type for a file system entry.
A file system entry can be the Root, a Folder or a File
-}
type FSEntry a b
    = Root
    | Folder Expanded a
    | File b


{-| As we navigate in the file system we save whether we have opened the folder already
-}
type Expanded
    = Expanded
    | NotExpanded


{-| Mapping from FSEntry to the type of the folder
-}
toFolder : FSEntry a b -> Maybe a
toFolder entry =
    case entry of
        Root ->
            Nothing

        Folder _ a ->
            Just a

        File _ ->
            Nothing


{-| Mapping from FSEntry to the type of the File
-}
toFile : FSEntry a b -> Maybe b
toFile entry =
    case entry of
        Root ->
            Nothing

        Folder _ _ ->
            Nothing

        File b ->
            Just b


{-| Create the filesystem from the root folders and the root files
-}
createRoot : List a -> List b -> FileSystem a b
createRoot rootFolders rootFiles =
    let
        zipper =
            Zipper.create Root
                |> Zipper.addChildren (List.map (Folder NotExpanded) rootFolders)
                |> Zipper.addChildren (List.map File rootFiles)
    in
    zipper


{-| Get the current folder where we hava navigated recently
-}
currentFolder : FileSystem a b -> Maybe a
currentFolder currentLevel =
    currentLevel
        |> Zipper.current
        |> toFolder


{-| Get the current folder sub folders
-}
subFolders : FileSystem a b -> List a
subFolders currentLevel =
    currentLevel
        |> Zipper.children
        |> List.filterMap toFolder


{-| Get the current folder sub files
-}
subFiles : FileSystem a b -> List b
subFiles currentLevel =
    currentLevel
        |> Zipper.children
        |> List.filterMap toFile


{-| Go up to the parent folder
-}
goUp : FileSystem a b -> FileSystem a b
goUp currentLevel =
    let
        maybeZipper =
            currentLevel |> Zipper.goUp
    in
    case maybeZipper of
        Just zipper ->
            zipper

        -- should not happen
        Nothing ->
            currentLevel


goRoot : FileSystem a b -> FileSystem a b
goRoot fs =
    fs |> Zipper.goRoot


{-| Go to the given folder
-}
goTo : a -> FileSystem a b -> FileSystem a b
goTo folder currentLevel =
    let
        folderToGo =
            Folder NotExpanded folder

        maybeZipper =
            currentLevel
                |> Zipper.goTo (isFsEntry folder)
    in
    case maybeZipper of
        Just zipper ->
            zipper

        -- should not happen
        Nothing ->
            currentLevel


isFsEntry : a -> FSEntry a b -> Bool
isFsEntry folder entry =
    case entry of
        Root ->
            False

        Folder _ f ->
            f == folder

        File file ->
            False


{-| Add new folders and files to the currently opened folder only if not added yet
-}
expandFolder : (() -> List a) -> (() -> List b) -> FileSystem a b -> FileSystem a b
expandFolder folders files fs =
    let
        currentEntry =
            Zipper.current fs
    in
    case currentEntry of
        Root ->
            fs

        Folder expanded _ ->
            case expanded of
                Expanded ->
                    fs

                NotExpanded ->
                    fs
                        |> Zipper.mapRoot setExpanded
                        |> Zipper.addChildren (List.map (Folder NotExpanded) (folders ()))
                        |> Zipper.addChildren (List.map File (files ()))

        File _ ->
            fs


setExpanded : FSEntry a b -> FSEntry a b
setExpanded entry =
    case entry of
        Root ->
            Root

        Folder _ folder ->
            Folder Expanded folder

        File x ->
            File x
