module Main exposing (main)

import Html exposing (Html)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)
import Tree exposing (Tree, Node(..), ParentId(..), insert, empty)
import Decoders.AudienceFolderDecoder as FD exposing (decodeAudienceFolders)
import Decoders.AudienceDecoder as AD exposing (decodeAudiences)


-- Import Modules

import Data.Audience exposing (Audience)
import Data.AudienceFolder exposing (AudienceFolder)


type TreeItem
    = AudienceItem Audience
    | Folder AudienceFolder


type alias Model =
    { visibleSubtree : Tree TreeItem
    }


model =
    { visibleSubtree = audiencesTree
    }


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
            [ Html.a [ href "#", onClick (ShowSubtree children) ]
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
main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = model
        , update = update
        , view = view
        }


type Msg
    = Noop
    | ShowSubtree (Tree TreeItem)


update : Msg -> Model -> Model
update msg model =
    case msg of
        Noop ->
            model

        ShowSubtree subtree ->
            { model | visibleSubtree = subtree }


view : Model -> Html Msg
view model =
    viewTree model.visibleSubtree
