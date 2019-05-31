module Data.Focused.FileSystem exposing (FileSystemFocused, FolderWithHole(..), focus, stepDown, stepUp)

import Data.FileSystem exposing (..)
import Data.Focused.List exposing (ListWithHole(..), focusAt)


type FolderWithHole a
    = FolderWithHole FolderName (List (FileSystem a)) (List (FileSystem a))


type alias FileSystemFocused a =
    ( List (FolderWithHole a), FileSystem a )


focus : FileSystem a -> Maybe (FileSystemFocused a)
focus tree =
    case tree of
        File _ ->
            Just ( [], tree )

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
            focusAt n forest
                |> Maybe.map
                    (\focusedForest ->
                        case focusedForest of
                            ( ListWithHole left right, focusedTree ) ->
                                ( FolderWithHole name left right :: crumbs, focusedTree )
                    )
