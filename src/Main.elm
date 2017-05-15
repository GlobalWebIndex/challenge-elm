module Main exposing (main)

import Html exposing (Html)
import Html.Attributes exposing (href)
import Tree exposing (Tree, Node(..), ParentId(..), insert, empty)
import Decoders.AudienceFolderDecoder as FD exposing (decodeAudienceFolders)
import Decoders.AudienceDecoder as AD exposing (decodeAudiences)


-- Import Modules

import Data.Audience exposing (Audience)
import Data.AudienceFolder exposing (AudienceFolder)


type TreeItem
    = AudienceItem Data.Audience.Audience
    | Folder Data.AudienceFolder.AudienceFolder


audiencesTree : Tree TreeItem
audiencesTree =
    let
        getParentNode parentId =
            case parentId of
                Nothing ->
                    Root

                Just id ->
                    NodeId id

        folderTree =
            FD.decodeAudienceFolders
                |> Result.withDefault []
                |> List.foldl
                    (\folder tree -> Tree.insert (getParentNode folder.parent) folder.id (Folder folder) tree)
                    Tree.empty

        audienceTree =
            AD.decodeAudiences
                |> Result.withDefault []
                |> List.foldl
                    (\audience tree -> Tree.insert (getParentNode audience.folder) audience.id (AudienceItem audience) tree)
                    folderTree
    in
        audienceTree


viewAudience audience children =
    if (List.length children) > 0 then
        Html.li [] [ Html.text ("|--- " ++ audience.name) ]
    else
        Html.li [] [ Html.text ("|--- " ++ audience.name) ]


viewFolder folder children =
    if (List.length children) > 0 then
        Html.li []
            [ Html.a [ href "http://seznam.cz" ]
                [ Html.text ("[" ++ folder.name ++ "]")
                ]
            ]
    else
        Html.li [] [ Html.text ("[]" ++ folder.name) ]


viewTree tree =
    Html.ul []
        (tree
            |> List.map
                (\(Node _ value children) ->
                    case value of
                        Folder folder ->
                            viewFolder folder children

                        AudienceItem audience ->
                            viewAudience audience children
                )
        )


{-| Main file of application
-}
main : Html msg
main =
    viewTree audiencesTree
