module Zipper exposing (kids, siblings, tree)

import Data.Audience exposing (Audience)
import Data.AudienceFolder exposing (AudienceFolder)
import Data.Decoded exposing (audienceFolderList, audiencesList)
import FolderInfo exposing (FolderInfo(..))
import Tree
import Tree.Zipper as Zipper exposing (Zipper)


type alias Seed =
    ( ( List Audience, List AudienceFolder ), ( Maybe Int, String ) )


{-  NOTE:   Again, this contant would also be hidden in some effect handler in a real world app, but this is not a real world.  -}
tree =
    Tree.unfold unfolder seed |> Zipper.fromTree


seed : ( ( List Audience, List AudienceFolder ), ( Maybe Int, String ) )
seed =
    ( ( audiencesList, audienceFolderList )
    , ( Nothing, "" )
    )


{-  NOTE:   I don't find this function really interesting. Only small detail maybe worth mentioning is that this function tries a little bit to
            make the seeds smaller for each deeper level.
            Those items and folders which are found to be inside a current leve will not be part of the seed for the next level.
            Unfortunately this is not true for siblings - simply because List.map will not allow it.
            I could probably use List.foldl to make it even more efficient, but it might hurt readability.
 -}
unfolder : Seed -> ( FolderInfo, List Seed )
unfolder ( ( audiences, folders ), ( currentId, currentName ) ) =
    let
        ( myAudiences, audiencesLeft ) =
            List.partition (.folder >> (==) currentId) audiences

        ( myFolders, foldersLeft ) =
            List.partition (.parent >> (==) currentId) folders

        label =
            Info { audiences = myAudiences, name = currentName, id = currentId }

        seeds =
            List.map (\{ id, name } -> ( ( audiencesLeft, foldersLeft ), ( Just id, name ) )) myFolders
    in
    ( label, seeds )


{-  NOTE:   The reason why this function exists is following:
            Zipper.children returns a list of Trees.
            That is completely useless to me - I don't want to ever drop down to tree again, once the zipper is built.
            For that reason I wrot my own version of it, which starts with a first child and then iterates over all of its siblings.
            Each time I get a Zipper a
            thanks to that, I can build a list of Zippers easily. -}
kids : Zipper a -> List (Zipper a)
kids zipper =
    let
        maybeFirstChild =
            Zipper.firstChild zipper
    in
    case maybeFirstChild of
        Nothing ->
            []

        Just child ->
            child :: siblings child


-- explained above
siblings : Zipper a -> List (Zipper a)
siblings zipper =
    let
        maybeSibling =
            Zipper.nextSibling zipper
    in
    case maybeSibling of
        Nothing ->
            []

        Just sibling ->
            sibling :: siblings sibling
