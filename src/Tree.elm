module Tree exposing (Tree(..), buildTree, name)

import Data.Audience exposing (Audience)
import Data.AudienceFolder exposing (AudienceFolder)
import Dict
import Dict.Extra exposing (groupBy)


type Tree
    = Tree AudienceFolder (List Tree) (List Audience)


name (Tree f _ _) =
    f.name


makeBranch : AudienceFolder -> Dict.Dict Int (List AudienceFolder) -> Dict.Dict Int (List Audience) -> Tree
makeBranch folder subfoldersDict leafDict =
    let
        getCurrentFolderData dict =
            dict |> Dict.get folder.id |> Maybe.withDefault []

        subfolders =
            getCurrentFolderData subfoldersDict

        leafs =
            getCurrentFolderData leafDict
    in
        Tree folder (List.map (\f -> makeBranch f subfoldersDict leafDict) subfolders) leafs



{-
   buildTree - transforms lists into hierarchical structure

   audiences without folder and folders without parent are tied to
   artificial node with id == -1 that serves as root of the hiearchy
   (this assumes that IDs in data are positive)
-}


buildTree : List AudienceFolder -> List Audience -> Tree
buildTree folders audiences =
    let
        leafDict =
            groupBy (\a -> Maybe.withDefault -1 a.folder) audiences

        subfolderDict =
            groupBy (\b -> Maybe.withDefault -1 b.parent) folders
    in
        (makeBranch { id = -1, name = "TOP", parent = Nothing } subfolderDict leafDict)
