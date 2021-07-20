module Main exposing (main)

import Browser
import Data.Audience exposing (Audience, AudienceType(..), audiencesDecoder, audiencesJSON)
import Data.AudienceFolder exposing (AudienceFolder, audienceFoldersDecoder, audienceFoldersJSON)
import Html exposing (Html, div, text)
import Html.Attributes
import Html.Events exposing (onClick)
import Json.Decode exposing (decodeString, errorToString)
import Tree
import Tree.Zipper exposing (Zipper, findNext)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = constructAudienceTree audiencesJSON audienceFoldersJSON
        , update = update
        , view = view
        }


{-| Decode audiencec and folder jsons and create a rose tree with the first level items populated

    The grand children will be occupied when each folder is opened.
    One could argue that this might be unnecessary optimization, but it's also simpler to just
    populate single folder at a time.
    With this logic it would be pretty much the same to use List instead of the tree, but with
    the three we can remember the previously populated nodes.
    Although with this quantity of static example data it doesn't really make any difference, but
    if each folder would require it's own http-call then caching the results of previous calls would
    make for a snappier UX.

-}
constructAudienceTree : String -> String -> Model
constructAudienceTree audiencesJson foldersJson =
    let
        result =
            Result.map2
                (\audiences folders ->
                    let
                        sortedAudiences =
                            List.sortBy
                                (.name >> String.toUpper)
                                audiences

                        sortedFolders =
                            List.sortBy
                                (.name >> String.toUpper)
                                folders

                        treeNodes =
                            (sortedFolders
                                |> List.map UnOpenedFolderNode
                            )
                                ++ (sortedAudiences
                                        |> List.map AudienceNode
                                   )

                        rootNodes =
                            (List.filter (\f -> f.parent == Nothing) sortedFolders
                                |> List.map (\f -> UnOpenedFolderNode f)
                            )
                                ++ (List.filter (\a -> a.folder == Nothing) sortedAudiences
                                        |> List.map (\a -> AudienceNode a)
                                   )
                                |> List.map Tree.singleton

                        tree =
                            Tree.singleton Root
                                |> Tree.replaceChildren rootNodes
                    in
                    ( tree, treeNodes )
                )
                (decodeString audiencesDecoder audiencesJson)
                (decodeString audienceFoldersDecoder foldersJson)
    in
    case result of
        Ok ( tree, treeNodes ) ->
            Loaded
                { zipper = Tree.Zipper.fromTree tree
                , treeNodes = treeNodes
                }

        Err err ->
            Error (Just <| errorToString err)


type Msg
    = OpenFolder Int
    | GoUp


{-| Type to hold Audiences and AudienceFolders in the tree.

    Also keeps track of the unopened-opened status of folders.

-}
type TreeNode
    = Root
    | AudienceNode Audience
      -- Not sure if division to open and closed here is worth it in this case
      -- UnOpenedFolderNode has closed folder icon and does not yet have children
    | UnOpenedFolderNode AudienceFolder
      -- OpenedFolderNode has open folder icon and has the children populated
    | OpenFolderNode AudienceFolder


type Model
    = Loaded LoadedData
    | Error (Maybe String)


type alias LoadedData =
    { treeNodes : List TreeNode
    , zipper : Zipper TreeNode
    }


update : Msg -> Model -> Model
update msg model =
    case ( model, msg ) of
        ( Error _, _ ) ->
            model

        ( Loaded data, OpenFolder folderId ) ->
            openFolderAndPopulateChildren data folderId

        ( Loaded data, GoUp ) ->
            Loaded
                { data
                    | zipper =
                        Tree.Zipper.parent data.zipper
                            |> Maybe.withDefault data.zipper
                }


{-| Returns a new model with a zipper that has a focus on the given folder and
the children of that folder are populated in the tree.

    TODO: While writing this comment I realize that this function does more than one thing
    and maybe it should be split.

-}
openFolderAndPopulateChildren : LoadedData -> Int -> Model
openFolderAndPopulateChildren data folderId =
    let
        zipper =
            findNext (isFolderWithId folderId) data.zipper
                |> Maybe.withDefault data.zipper

        zipperWithChildren =
            case Tree.Zipper.label zipper of
                OpenFolderNode _ ->
                    zipper

                Root ->
                    zipper

                AudienceNode _ ->
                    zipper

                UnOpenedFolderNode node ->
                    List.filter (isChildOf folderId) data.treeNodes
                        |> List.map Tree.singleton
                        |> (\children2 ->
                                Tree.Zipper.mapTree
                                    (Tree.replaceChildren
                                        children2
                                    )
                                    zipper
                           )
                        |> Tree.Zipper.replaceLabel (OpenFolderNode node)
    in
    Loaded { data | zipper = zipperWithChildren }


isChildOf : Int -> TreeNode -> Bool
isChildOf folderId node =
    case node of
        AudienceNode audience ->
            audience.folder == Just folderId

        OpenFolderNode folder ->
            folder.parent == Just folderId

        UnOpenedFolderNode folder ->
            folder.parent == Just folderId

        Root ->
            False


isFolderWithId : Int -> TreeNode -> Bool
isFolderWithId id node =
    case node of
        OpenFolderNode folder ->
            folder.id == id

        UnOpenedFolderNode folder ->
            folder.id == id

        _ ->
            False


view : Model -> Html Msg
view model =
    case model of
        -- In real life situation there should be a better error handling
        Error err ->
            div [] [ text <| "Parsing data failed: " ++ Maybe.withDefault "" err ]

        Loaded { zipper } ->
            div
                [ class "wrapper"
                ]
                (renderTree zipper)


renderTree : Zipper TreeNode -> List (Html Msg)
renderTree zipper =
    renderGoUp (Tree.Zipper.label zipper)
        :: (renderTreeNode True <| Tree.label <| Tree.Zipper.tree zipper)
        :: (Tree.Zipper.children
                zipper
                |> List.map Tree.label
                |> List.map (renderTreeNode False)
           )


renderGoUp : TreeNode -> Html Msg
renderGoUp node =
    case node of
        Root ->
            text ""

        _ ->
            div
                [ onClick GoUp
                , style "cursor" "pointer"
                , style "padding" "20px"
                ]
                [ text "⬆ Go up" ]


class : String -> Html.Attribute msg
class =
    Html.Attributes.class


style : String -> String -> Html.Attribute msg
style =
    Html.Attributes.style


nbsp : String
nbsp =
    "\u{00A0}"


renderTreeNode : Bool -> TreeNode -> Html Msg
renderTreeNode current node =
    let
        classes =
            "node"
                ++ (if current then
                        " current"

                    else
                        ""
                   )
    in
    case node of
        AudienceNode audience ->
            div [ class classes ] [ text <| "👥" ++ nbsp ++ audience.name ]

        OpenFolderNode folder ->
            div [ onClick (OpenFolder folder.id), style "cursor" "pointer", class classes ] [ text <| "📂" ++ nbsp ++ folder.name ]

        UnOpenedFolderNode folder ->
            div [ onClick (OpenFolder folder.id), style "cursor" "pointer", class classes ] [ text <| "📁" ++ nbsp ++ folder.name ]

        Root ->
            div [ class "node current" ] [ text <| "√ Root" ]
