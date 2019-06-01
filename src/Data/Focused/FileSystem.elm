module Data.Focused.FileSystem exposing (FileSystemFocused, FolderWithHole(..), defocus, focus, stepDown, stepUp)

import Data.FileSystem exposing (..)
import Data.Focused.List exposing (ListWithHole(..), focusAt)


type FolderWithHole a
    = FolderWithHole FolderName (List (FileSystem a)) (List (FileSystem a))


type alias FileSystemFocused a =
    ( List (FolderWithHole a), FileSystem a )


focus : FileSystem a -> FileSystemFocused a
focus tree =
    case tree of
        File _ ->
            ( [], tree )

        Folder _ _ ->
            ( [], tree )


defocus : FileSystemFocused a -> FileSystem a
defocus fsFocused =
    case fsFocused of
        ( [], tree ) ->
            tree

        ( (FolderWithHole name left right) :: fragments, tree ) ->
            defocus ( fragments, Folder name <| left ++ [ tree ] ++ right )


stepUp : FileSystemFocused a -> Maybe (FileSystemFocused a)
stepUp focTree =
    case focTree of
        ( [], _ ) ->
            Nothing

        ( (FolderWithHole name leftOfHole rightOfHole) :: fragments, tree ) ->
            Just ( fragments, Folder name <| leftOfHole ++ [ tree ] ++ rightOfHole )


stepDown : Int -> FileSystemFocused a -> Maybe (FileSystemFocused a)
stepDown n ( fragments, tree ) =
    case tree of
        File _ ->
            Nothing

        Folder name forest ->
            focusAt n forest
                |> Maybe.map
                    (\focusedForest ->
                        case focusedForest of
                            ( ListWithHole left right, focusedTree ) ->
                                ( FolderWithHole name left right :: fragments, focusedTree )
                    )
