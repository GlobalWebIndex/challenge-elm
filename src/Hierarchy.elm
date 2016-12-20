module Hierarchy
    exposing
        ( Node(..)
        , Hierarchy
        , empty
        , goup
        , godown
        , currentPath
        , currentNodes
        , registerFolder
        , registerFile
        )

import Dict exposing (Dict)
import Maybe.Extra as Maybe
import Data.Audience exposing (AudienceType(..), Audience)
import Data.AudienceFolder exposing (AudienceFolder)


{-|
A container that can hold either an Audience or AudienceFolder.

Folders are paired with its children count. (TODO only direct or all of them?)
-}
type Node
    = Folder Int AudienceFolder
    | File Audience


{-|
A data structure to store the audiences API results
and managing the state of a viewer of the hierarchy.
-}
type Hierarchy
    = Hierarchy
        { breadcrumb : List Int
        , rootNodes : List Int
        , childIndex :
            -- TODO: a value of Set Int makes more sense
            Dict Int (List Int)
        , nodeDB : Dict Int Node
        }


{-| Create an empty hierarchy
-}
empty : Hierarchy
empty =
    Hierarchy
        { breadcrumb = []
        , rootNodes = []
        , childIndex = Dict.empty
        , nodeDB = Dict.empty
        }


{-|
Navigates a given amount of levels up in the hierarchy.
-}
goup : Int -> Hierarchy -> Hierarchy
goup levels (Hierarchy h) =
    case h.breadcrumb of
        [] ->
            Hierarchy h

        _ :: rest ->
            if levels <= 0 then
                Hierarchy h
            else
                goup (levels - 1) (Hierarchy { h | breadcrumb = rest })


{-|
Navigates into some child of the currently displayed
node or a root node.

Returns:
  * Ok newHierarcy: when the navigation succeeded
  * Err msg: where msg explains the failure
-}
godown : Int -> Hierarchy -> Result String Hierarchy
godown id (Hierarchy h) =
    case h.breadcrumb of
        [] ->
            if List.member id h.rootNodes then
                Ok <| Hierarchy <| { h | breadcrumb = id :: h.breadcrumb }
            else
                Err ("Unknown root node with ID " ++ (toString id))

        current :: _ ->
            let
                okOrUnknownChild known =
                    if known then
                        Ok <| Hierarchy <| { h | breadcrumb = id :: h.breadcrumb }
                    else
                        Err ("Node with ID " ++ (toString current) ++ " has no child with ID " ++ (toString id))
            in
                h.childIndex
                    |> Dict.get current
                    |> Maybe.map (List.member id)
                    |> Maybe.map okOrUnknownChild
                    |> Maybe.withDefault (Err "Corrupted breadcrumb: current node does not exist")


{-|
Finds the path in the hierarchy to the currently displayed node.
-}
currentPath : Hierarchy -> Result String (List Node)
currentPath (Hierarchy h) =
    h.breadcrumb
        |> List.map (flip Dict.get h.nodeDB)
        |> Maybe.combine
        |> Result.fromMaybe "Corrupted breadcrumb: some visited node does not exist"


{-|
Gets a list of children of the currently displayed node or root nodes.
-}
currentNodes : Hierarchy -> Result String (List Node)
currentNodes (Hierarchy h) =
    case h.breadcrumb of
        [] ->
            h.rootNodes
                |> List.map (flip Dict.get h.nodeDB)
                |> Maybe.combine
                |> Maybe.map (List.sortWith nodeCompare)
                |> Result.fromMaybe "Currupted root nodes: some nodes registered as root node do not exist"

        current :: _ ->
            h.childIndex
                |> Dict.get current
                |> Maybe.map (List.map (flip Dict.get h.nodeDB))
                |> Maybe.map Maybe.combine
                |> Maybe.map (Maybe.map (List.sortWith nodeCompare))
                |> Maybe.map
                    (Result.fromMaybe "Currupted child index: contains inexistant nodes")
                |> Maybe.withDefault (Err "Corrupted breadcrumb: current node does not exist")


{-| Add a folder to the hierarchy
-}
registerFolder : AudienceFolder -> Hierarchy -> Result String Hierarchy
registerFolder folder (Hierarchy h) =
    if Dict.member folder.id h.nodeDB then
        Err <| "Node with ID " ++ (toString folder.id) ++ " has already been added"
    else
        let
            -- Finds out the number of nodes that we've already registered
            -- that claim to be our child.
            currentCount =
                h.childIndex
                    |> Dict.get folder.id
                    |> Maybe.map List.length
                    |> Maybe.withDefault 0

            nodeDBWithFolder =
                Dict.insert folder.id (Folder currentCount folder) h.nodeDB

            -- XXX If our current children count is 0, we add ourselves
            -- to the child index because it's possible no node will get
            -- registered as our child.
            childIndexWithFolder =
                if currentCount == 0 then
                    Dict.insert folder.id [] h.childIndex
                else
                    h.childIndex

            ( newRootNodes, newChildIndex, newNodeDB ) =
                case folder.parent of
                    Nothing ->
                        ( folder.id :: h.rootNodes, childIndexWithFolder, nodeDBWithFolder )

                    Just p ->
                        ( h.rootNodes
                        , Dict.update p (addChild folder.id) childIndexWithFolder
                        , incrementCounts p nodeDBWithFolder
                        )
        in
            Ok <|
                Hierarchy
                    { h
                        | nodeDB = newNodeDB
                        , childIndex = newChildIndex
                        , rootNodes = newRootNodes
                    }


{-| Add a file to the hierarchy
-}
registerFile : Audience -> Hierarchy -> Result String Hierarchy
registerFile file (Hierarchy h) =
    if Dict.member file.id h.nodeDB then
        Err <| "Node with ID " ++ (toString file.id) ++ " has already been added"
    else
        let
            nodeDBWithFile =
                Dict.insert file.id (File file) h.nodeDB

            ( newRootNodes, newChildIndex, newNodeDB ) =
                case file.folder of
                    Nothing ->
                        ( file.id :: h.rootNodes, h.childIndex, nodeDBWithFile )

                    Just p ->
                        ( h.rootNodes
                        , Dict.update p (addChild file.id) h.childIndex
                        , incrementCounts p nodeDBWithFile
                        )
        in
            Ok <|
                Hierarchy
                    { h
                        | nodeDB = newNodeDB
                        , childIndex = newChildIndex
                        , rootNodes = newRootNodes
                    }


{-| Adds a node ID to the list of node references
This is a helper function used in a `Dict.update` call applied to the
children index.
-}
addChild : Int -> Maybe (List Int) -> Maybe (List Int)
addChild id maybeList =
    maybeList
        |> Maybe.map ((::) id)
        |> Maybe.orElseLazy (\_ -> Just [ id ])


{-| We assume the count is computed as the amount of
   DIRECT children nodes.
-}
incrementCounts : Int -> Dict Int Node -> Dict Int Node
incrementCounts id nodeDB =
    let
        updateFolderCount mf =
            case mf of
                Just (Folder c af) ->
                    Just (Folder (c + 1) af)

                Nothing ->
                    mf

                Just file ->
                    -- TODO: better error handling
                    Debug.crash "uh, somebody claimed to be the child of a file"
    in
        Dict.update id updateFolderCount nodeDB


{-| Ordering for nodes
Alphabetical, but folders come first
-}
nodeCompare : Node -> Node -> Order
nodeCompare a b =
    case ( a, b ) of
        ( File x, File y ) ->
            compare x.name y.name

        ( Folder _ x, Folder _ y ) ->
            compare x.name y.name

        ( File _, Folder _ _ ) ->
            GT

        ( Folder _ _, File _ ) ->
            LT
