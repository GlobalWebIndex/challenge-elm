module NavTree
    exposing
        ( TreeItem
        , build
        , isFolderWithId
        , sortItems
        , withTreeItem
        )

import Data.Audience exposing (Audience)
import Data.AudienceFolder exposing (AudienceFolder)
import Lazy.Tree as LT exposing (Tree)


type alias NavigationTree =
    Tree TreeItem


{-| Opaque type to enable having folders and items in a single navigation tree
-}
type TreeItem
    = Folder AudienceFolder
    | Leaf Audience


{-| Catamorphism used to avoid exposing TreeItem constructors outside of this module.
-}
withTreeItem : (AudienceFolder -> r) -> (Audience -> r) -> TreeItem -> r
withTreeItem audienceFolderCallback audienceCallback treeItem =
    case treeItem of
        Folder audienceFolder ->
            audienceFolderCallback audienceFolder

        Leaf audience ->
            audienceCallback audience


parentId : TreeItem -> Maybe Int
parentId =
    withTreeItem .parent .folder


isFolderWithId : Int -> TreeItem -> Bool
isFolderWithId id =
    withTreeItem
        (\folder -> folder.id == id)
        (always False)


build : List AudienceFolder -> List Audience -> NavigationTree
build audienceFolders audiences =
    let
        folderItems =
            List.map Folder audienceFolders

        leafItems =
            List.map Leaf audiences

        isParent : Maybe TreeItem -> TreeItem -> Bool
        isParent maybeParent item =
            case maybeParent of
                Nothing ->
                    parentId item == Nothing

                Just (Leaf _) ->
                    -- Leaf can't be parent on ahother node. If this gets executed it means we're getting invalid data from the backend
                    -- and should follow up with the backend team :-)
                    Debug.log "Invalid Data received from the backend. There was an Audience which referenced another Audience as parent" False

                Just (Folder audienceFolder) ->
                    parentId item == Just audienceFolder.id
    in
    LT.Tree root <| LT.fromList isParent <| folderItems ++ leafItems



-- To construct a zipper for our model we need a Tree
-- But Lazy.Tree.fromList constructs a Forest, so use this dummy root to make complete tree


root : TreeItem
root =
    Folder
        -- ASSUMPTION: all nodes from the backend have positive IDs.
        -- If this wasn't the case (check with backend team)
        -- we could find a minimal ID in all the nodes and set the root ID to "min - 1"
        { id = -1
        , name = "ROOT"
        , parent = Nothing
        }


sortItems : List TreeItem -> List TreeItem
sortItems =
    List.sortWith itemComparator


{-| Sort all folders before leaves and within these groups use alphabetic order
-}
itemComparator : TreeItem -> TreeItem -> Order
itemComparator i1 i2 =
    case ( i1, i2 ) of
        ( Folder f1, Folder f2 ) ->
            compare f1.name f2.name

        ( Leaf l1, Leaf l2 ) ->
            compare l1.name l2.name

        ( Folder _, Leaf _ ) ->
            LT

        ( Leaf _, Folder _ ) ->
            GT
