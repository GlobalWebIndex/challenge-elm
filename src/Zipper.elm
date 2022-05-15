module Zipper exposing (zipper, kids, siblings)


import Tree.Zipper as Zipper exposing (Zipper)
import Tree

import Data.Audience exposing (Audience)
import Data.AudienceFolder exposing (AudienceFolder)
import Data.Decoded exposing (audiencesList, audienceFolderList)
import Label exposing (Label(..))


type alias Seed = ((List Audience, List AudienceFolder), (Maybe Int, String))


zipper = Tree.unfold unfolder seed |> Zipper.fromTree


seed : ((List Audience, List AudienceFolder), (Maybe Int, String))
seed =  ( ( audiencesList, audienceFolderList )
        , ( Nothing, "" )
        )


unfolder : Seed -> (Label, List Seed)
unfolder ((audiences, folders), (currentId, currentName)) =
    let
        (myAudiences, audiencesLeft) = List.partition (.folder >> ((==) currentId)) audiences
        (myFolders, foldersLeft) = List.partition (.parent >> ((==) currentId)) folders

        label = Label { audiences = myAudiences, name = currentName, id = currentId }
        seeds = List.map (\{ id, name } -> ((audiencesLeft, foldersLeft), (Just id, name))) myFolders
  in  (label, seeds)



kids : Zipper a -> List (Zipper a)
kids zipper_ =
    let
        maybeFirstChild = Zipper.firstChild zipper_
    in  case maybeFirstChild of
        Nothing -> []
        Just child -> child :: siblings child


siblings : Zipper a -> List (Zipper a)
siblings zipper_ =
    let
        maybeSibling = Zipper.nextSibling zipper_
    in  case maybeSibling of
        Nothing -> []
        Just sibling -> sibling :: siblings sibling
    
