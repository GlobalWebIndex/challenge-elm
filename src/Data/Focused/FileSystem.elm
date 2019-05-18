module Data.Focused.FileSystem exposing (FileSystemFocused, FolderWithHole(..), focus, stepDown, stepUp)

import Data.FileSystem exposing (..)
import Data.Focused.List exposing (ListWithHole(..), focusIn)
import List.Extra exposing (uncons)


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
