module Level exposing
    ( Level, build
    , goToRootFolder, goToParentFolder, goToFolder
    , parentFoldersFromRoot, currentFolder, children
    )

{-| This module represents the current selected level.

The opaque type hides the implementation details and allow to change the underlying structure.
A rosetree structure is created from the list of audience folders and the list of audiences.
A zipper is created from the rosetree to navigate through it.

This structure is perfect to represent nested folders. The zipper is very efficient to navigate.


# Constructor

@docs Level, build


# Navigation

@docs goToRootFolder, goToParentFolder, goToFolder


# Accessors

@docs parentFoldersFromRoot, currentFolder, children

-}

import Data.Audience exposing (Audience)
import Data.AudienceFolder exposing (AudienceFolder)
import Dict exposing (Dict)
import Tree exposing (Tree)
import Tree.Zipper as Zipper exposing (Zipper)
import Tree.Zipper.Extra as Zipper


{-| ID for root folder

We make the assumpton that there is no folder with the ID 0.
If this is the case, we can use a negative number or a string instead.

-}
rootId : Int
rootId =
    0


type Level
    = Level (Zipper LevelParams)


type alias LevelParams =
    { currentAudienceFolder : Maybe AudienceFolder
    , audiences : List Audience
    }



-- CONSTRUCTOR


build : List AudienceFolder -> List Audience -> Level
build audienceFolders audiences =
    let
        audienceFoldersDict =
            groupByFolder audienceFolders .parent

        audiencesDict =
            groupByFolder audiences .folder
    in
    buildTreeHelper audienceFoldersDict audiencesDict Nothing
        |> Zipper.fromTree
        |> Level



-- NAVIGATION


goToRootFolder : Level -> Level
goToRootFolder (Level zipper) =
    Level (Zipper.root zipper)


goToParentFolder : Int -> Level -> Level
goToParentFolder folderId (Level zipper) =
    goToParentFolderHelper folderId zipper zipper
        |> Level


goToFolder : Int -> Level -> Level
goToFolder folderId (Level zipper) =
    let
        newZipper =
            zipper
                -- We could use `Zipper.findNext` but it would traverse all the descendants of the first child
                -- which we are not interested in. We only need to look for the children.
                |> Zipper.findChild (\{ currentAudienceFolder } -> Maybe.map .id currentAudienceFolder == Just folderId)
                |> Maybe.withDefault zipper
    in
    Level newZipper



-- ACCESSORS


parentFoldersFromRoot : Level -> List AudienceFolder
parentFoldersFromRoot (Level zipper) =
    parentFoldersFromRootHelper zipper []


currentFolder : Level -> Maybe AudienceFolder
currentFolder (Level zipper) =
    Zipper.label zipper
        |> .currentAudienceFolder


children : Level -> ( List AudienceFolder, List Audience )
children (Level zipper) =
    let
        audienceFolders =
            Zipper.children zipper
                |> List.filterMap (Tree.label >> .currentAudienceFolder)

        { audiences } =
            Zipper.label zipper
    in
    ( audienceFolders, audiences )



-- INTERNAL HELPERS


groupByFolder : List a -> (a -> Maybe Int) -> Dict Int (List a)
groupByFolder list getFolder =
    list
        |> List.foldl
            (\item dict ->
                let
                    key =
                        item
                            |> getFolder
                            |> Maybe.withDefault rootId
                in
                Dict.update key
                    (\maybePrevious ->
                        case maybePrevious of
                            Nothing ->
                                Just [ item ]

                            Just previous ->
                                Just (item :: previous)
                    )
                    dict
            )
            Dict.empty


buildTreeHelper : Dict Int (List AudienceFolder) -> Dict Int (List Audience) -> Maybe AudienceFolder -> Tree LevelParams
buildTreeHelper audienceFoldersDict audiencesDict currentAudienceFolder =
    let
        key =
            currentAudienceFolder
                |> Maybe.map .id
                |> Maybe.withDefault rootId
    in
    Tree.tree
        { currentAudienceFolder = currentAudienceFolder
        , audiences =
            audiencesDict
                |> Dict.get key
                -- Sort at the leaves for better efficiency
                |> Maybe.map (List.sortBy .name)
                |> Maybe.withDefault []
        }
        (audienceFoldersDict
            |> Dict.get key
            -- Sort at the leaves for better efficiency
            |> Maybe.map (List.sortBy .name)
            |> Maybe.withDefault []
            |> List.map
                (\audienceFolder ->
                    buildTreeHelper audienceFoldersDict audiencesDict (Just audienceFolder)
                )
        )


goToParentFolderHelper : Int -> Zipper LevelParams -> Zipper LevelParams -> Zipper LevelParams
goToParentFolderHelper folderId currentZipper originalZipper =
    case Zipper.parent currentZipper of
        Nothing ->
            originalZipper

        Just parentZipper ->
            case Zipper.label parentZipper |> .currentAudienceFolder of
                Nothing ->
                    originalZipper

                Just parent ->
                    if parent.id == folderId then
                        parentZipper

                    else
                        goToParentFolderHelper folderId parentZipper originalZipper


parentFoldersFromRootHelper : Zipper LevelParams -> List AudienceFolder -> List AudienceFolder
parentFoldersFromRootHelper zipper acc =
    case Zipper.parent zipper of
        Nothing ->
            acc

        Just parentZipper ->
            case Zipper.label parentZipper |> .currentAudienceFolder of
                Nothing ->
                    acc

                Just parent ->
                    parentFoldersFromRootHelper parentZipper (parent :: acc)
