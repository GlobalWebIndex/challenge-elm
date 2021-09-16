module Main exposing (main)

import Browser
import Data.Audience exposing (Audience, AudienceType(..), audiencesJSON)
import Data.AudienceFolder exposing (AudienceFolder, audienceFoldersJSON)
import Dict exposing (Dict)
import FontAwesome as FA
import Html exposing (..)
import Html.Attributes exposing (class, classList, id)
import Html.Events exposing (onClick)
import Json.Decode as Decode exposing (Decoder, decodeString, field, float, int, list, nullable, string)
import Json.Decode.Pipeline exposing (optional, required, requiredAt)
import Tree as Tree exposing (Tree)
import Tree.Zipper as Zipper


type Node
    = Dir Id AudienceFolder
    | File Id Audience
    | Root


type alias Id =
    Int



{--------------------------------------------------------------

This program mimics directory structure where there are files and folders.
Files are Audience and Folders and AudienceFolder. 
Once decoded from JSON, they are converted to List Node

List Node is then ordered in a Rose Tree using zwilias/elm-rosetree/1.5.0 library.

At first all nodes are entered into rose tree with flat architecture, see flatTree
Parent child relation is ignored.
The reason for this is, you cannot put a node into its parent when the parent itself is not yet traversed and is not in the tree yet!
Once you have all the nodes in a flat tree and information about { parent : Maybe Node, child : Node }, then 
1. you can pluck a node from the tree
2. find its parent in the tree
3. put it inside the parent, outputting updated tree

----------------------------------------------------------------}


directoryTree : Tree Node
directoryTree =
    let
        getParentChildNodes : Node -> { parent : Maybe Node, child : Node }
        getParentChildNodes node =
            case node of
                Dir id audienceFolder ->
                    case audienceFolder.parent of
                        Just parentId ->
                            { parent = getParentFromDict parentId, child = Dir id audienceFolder }

                        Nothing ->
                            { parent = Nothing, child = Dir id audienceFolder }

                File id audience ->
                    case audience.folder of
                        Just parentId ->
                            { parent = getParentFromDict parentId, child = File id audience }

                        Nothing ->
                            { parent = Nothing, child = File id audience }

                Root ->
                    -- This state would never be reached. Given just to make compiler happy
                    { parent = Nothing, child = File 0 defaultAudience }

        getParentFromDict : Id -> Maybe Node
        getParentFromDict parentId =
            Dict.get parentId allNodesInDict

        listOfParentChild : List { parent : Maybe Node, child : Node }
        listOfParentChild =
            allNodes
                |> List.map (\node -> getParentChildNodes node)

        -- This is flat tree with no parent-child relation yet
        flatTree : Tree Node
        flatTree =
            allNodes
                |> List.map Tree.singleton
                |> Tree.tree Root
    in
    flatTreeToParentChildTree listOfParentChild (Just flatTree)



-- This will order nodes in parent-child hierarchy


flatTreeToParentChildTree : List { parent : Maybe Node, child : Node } -> Maybe (Tree Node) -> Tree Node
flatTreeToParentChildTree listOfParentChild tree =
    case listOfParentChild of
        parentChild :: rest ->
            case parentChild.parent of
                Just parent ->
                    flatTreeToParentChildTree rest (reorderNode { parent = parent, child = parentChild.child } tree)

                Nothing ->
                    flatTreeToParentChildTree rest tree

        [] ->
            Maybe.withDefault defaultTree tree


reorderNode : { parent : Node, child : Node } -> Maybe (Tree Node) -> Maybe (Tree Node)
reorderNode parentChild tree =
    let
        -- subTree is the child node
        subTree : Maybe (Tree Node)
        subTree =
            findASubTree tree parentChild.child
    in
    -- tree is flat with no parent child hierarchy yet
    tree
        -- remove the child node from flat tree because we will insert it to parent soon
        |> removeASubTree parentChild.child
        -- and insert the subTree(child) to its parent tree
        |> appendASubTreeAsChild subTree parentChild


appendASubTreeAsChild : Maybe (Tree Node) -> { parent : Node, child : Node } -> Maybe (Tree Node) -> Maybe (Tree Node)
appendASubTreeAsChild subTree parentChild tree =
    let
        appendTreeToTree tree_ =
            Tree.appendChild (Maybe.withDefault defaultTree subTree) tree_
    in
    Zipper.fromTree (Maybe.withDefault defaultTree tree)
        -- Find the parent node
        |> Zipper.findFromRoot (\id -> id == parentChild.parent)
        -- Insert subTree to the parent node
        |> Maybe.map (Zipper.mapTree appendTreeToTree)
        |> Maybe.map Zipper.toTree


findASubTree : Maybe (Tree Node) -> Node -> Maybe (Tree Node)
findASubTree tree subTreeNode =
    Zipper.fromTree (Maybe.withDefault defaultTree tree)
        |> Zipper.findFromRoot (\id -> id == subTreeNode)
        |> Maybe.map Zipper.tree


removeASubTree : Node -> Maybe (Tree Node) -> Maybe (Tree Node)
removeASubTree node tree =
    Zipper.fromTree (Maybe.withDefault defaultTree tree)
        |> Zipper.findFromRoot (\id -> id == node)
        |> Maybe.andThen Zipper.removeTree
        |> Maybe.map Zipper.toTree


defaultTree : Tree.Tree Node
defaultTree =
    Tree.singleton (File defaultAudience.id defaultAudience)


allNodesInDict : Dict Id Node
allNodesInDict =
    let
        getId : Node -> Id
        getId node =
            case node of
                Dir id audienceFolder ->
                    id

                File id audience ->
                    id

                Root ->
                    0
    in
    allNodes
        |> List.map (\node -> ( getId node, node ))
        |> Dict.fromList


allNodes : List Node
allNodes =
    let
        audienceFolders : List AudienceFolder
        audienceFolders =
            Maybe.withDefault [ defaultAudienceFolder ] decodeAudienceFolders

        audiences : List Audience
        audiences =
            Maybe.withDefault [ defaultAudience ] decodeAudiences
    in
    List.append
        (List.map (\audienceFolder -> Dir audienceFolder.id audienceFolder) audienceFolders)
        (List.map (\audience -> File audience.id audience) audiences)



-- Utility functions for traversing a Tree
-- Finding a Tree with node
-- Get children Nodes of certain parent tree


findATree : Node -> Tree Node -> Maybe (Zipper.Zipper Node)
findATree node tree =
    Zipper.fromTree tree
        |> Zipper.findFromRoot (\id -> id == node)


getChildrenNodes : Tree Node -> List Node
getChildrenNodes tree =
    tree
        |> Tree.children
        |> List.map Tree.label



-- UPDATE


type Msg
    = NoOp
    | GoTo Node
    | GoUp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GoTo node ->
            let
                newZipperStep : Maybe (Zipper.Zipper Node)
                newZipperStep =
                    findATree node model.directory

                updatedTree : Maybe (Tree Node)
                updatedTree =
                    newZipperStep
                        |> Maybe.map Zipper.tree
            in
            ( { model | zipperStep = newZipperStep, currentTree = updatedTree }, Cmd.none )

        GoUp ->
            let
                newZipperStep : Maybe (Zipper.Zipper Node)
                newZipperStep =
                    model.zipperStep
                        |> Maybe.andThen Zipper.parent

                updatedTree : Maybe (Tree Node)
                updatedTree =
                    newZipperStep
                        |> Maybe.map Zipper.tree
            in
            ( { model | zipperStep = newZipperStep, currentTree = updatedTree }, Cmd.none )



-- VIEW


type alias Model =
    { directory : Tree Node
    , currentTree : Maybe (Tree Node)
    , zipperStep : Maybe (Zipper.Zipper Node)
    }


view : Model -> Html Msg
view model =
    let
        nodes : List Node
        nodes =
            case model.currentTree of
                Just tree ->
                    getChildrenNodes tree

                Nothing ->
                    []
    in
    div [ class "w-screen h-screen bg-gray-50" ]
        [ div [ class "w-full h-auto" ]
            [ viewBackButton model
            , div []
                (List.append
                    (viewNodes nodes ViewFolder)
                    (viewNodes nodes ViewFile)
                )
            ]
        ]


viewBackButton : Model -> Html Msg
viewBackButton model =
    let
        hasParent : String
        hasParent =
            case parentLabel of
                Just (Dir id audienceFolder) ->
                    audienceFolder.name

                Just Root ->
                    "Home"

                _ ->
                    ""

        parentLabel : Maybe Node
        parentLabel =
            model.zipperStep
                |> Maybe.andThen Zipper.parent
                |> Maybe.map Zipper.label
    in
    case String.length hasParent > 0 of
        True ->
            div [ class "w-full bg-gray-800 px-4 py-4 cursor-pointer", onClick GoUp ]
                [ span [ class "text-white " ] [ FA.icon FA.arrowAltLeft ]
                , span [ class "inline-block ml-2 text-white font-bold" ] [ text hasParent ]
                ]

        False ->
            text ""


type ViewType
    = ViewFolder
    | ViewFile


viewNodes : List Node -> ViewType -> List (Html Msg)
viewNodes nodes viewType =
    let
        nodesToBeViewed : List Node
        nodesToBeViewed =
            case viewType of
                ViewFolder ->
                    List.filter foldersOnly nodes

                ViewFile ->
                    List.filter filesOnly nodes

        name : Node -> String
        name node =
            case node of
                Dir id audienceFolder ->
                    audienceFolder.name

                File id audience ->
                    audience.name

                Root ->
                    ""
    in
    nodesToBeViewed
        |> List.map (\node -> viewNode (name node) viewType (GoTo node))


type alias ViewConfig =
    { icon : Html Msg
    , isDark : Bool
    , cursorPointer : ( String, Bool )
    }


viewNode : String -> ViewType -> Msg -> Html Msg
viewNode name viewType toMsg =
    let
        config : ViewConfig
        config =
            case viewType of
                ViewFolder ->
                    folderViewConfig

                ViewFile ->
                    fileViewConfig

        folderViewConfig : ViewConfig
        folderViewConfig =
            { icon = FA.icon FA.folder
            , isDark = False
            , cursorPointer = ( "cursor-pointer", True )
            }

        fileViewConfig : ViewConfig
        fileViewConfig =
            { icon = text ""
            , isDark = True
            , cursorPointer = ( "cursor-default", True )
            }

        attachOnClick : List (Attribute Msg)
        attachOnClick =
            case viewType of
                ViewFolder ->
                    [ onClick toMsg ]

                ViewFile ->
                    []
    in
    div
        [ class "h-12 bg-gray-100 border-b border-gray-200 hover:bg-gray-600"
        , classList
            [ ( "bg-gray-200", config.isDark )
            , ( "border-gray-300", config.isDark )
            , config.cursorPointer
            ]
        ]
        [ div ([ class "group w-5/6 h-full mx-auto flex items-center justify-between" ] ++ attachOnClick)
            [ span [ class "font-semibold text-gray-800 leading-loose group-hover:text-white" ] [ text name ]
            , span [ class "text-gray-400 group-hover:text-white" ] [ config.icon ]
            ]
        ]


foldersOnly : Node -> Bool
foldersOnly node =
    case node of
        Dir id audienceFolder ->
            True

        File id audience ->
            False

        Root ->
            True


filesOnly : Node -> Bool
filesOnly node =
    case node of
        Dir id audienceFolder ->
            False

        File id audience ->
            True

        Root ->
            True



{------------------------------
------------------------------
DECODE JSON 

Data Type : 
Data.Audience.Audience
Data.AudienceFolder.AudienceFolder

JSON strings fetched from
Data.Audience.audiencesJSON
Data.AudienceFolder.audienceFoldersJSON

Decoding JSON into two formats List Audience and List AudienceFolder 

------------------------------
------------------------------}
-- Decode Audience


decodeAudiences : Maybe (List Audience)
decodeAudiences =
    case decodeString audiencesDecoder audiencesJSON of
        Ok result ->
            Just result

        Err _ ->
            Nothing


audiencesDecoder : Decoder (List Audience)
audiencesDecoder =
    Decode.succeed Audience
        |> required "id" int
        |> required "name" string
        |> required "type" audienceTypeDecoder
        |> required "folder" (nullable int)
        |> list
        |> field "data"


audienceTypeDecoder : Decoder AudienceType
audienceTypeDecoder =
    string
        |> Decode.andThen strToAudienceType


strToAudienceType : String -> Decoder AudienceType
strToAudienceType name =
    case name of
        "curated" ->
            Decode.succeed Curated

        "shared" ->
            Decode.succeed Shared

        "user" ->
            Decode.succeed Authored

        _ ->
            Decode.fail "\"type\" is malformed"



-- Decode AudienceFolder


decodeAudienceFolders : Maybe (List AudienceFolder)
decodeAudienceFolders =
    case decodeString audienceFolderDecoder audienceFoldersJSON of
        Ok result ->
            Just result

        Err _ ->
            Nothing


audienceFolderDecoder : Decoder (List AudienceFolder)
audienceFolderDecoder =
    Decode.succeed AudienceFolder
        |> required "id" int
        |> required "name" string
        |> required "parent" (nullable int)
        |> list
        |> field "data"



-- Defaults to be used with Maybe


defaultAudienceFolder : AudienceFolder
defaultAudienceFolder =
    { id = 0
    , name = ""
    , parent = Nothing
    }


defaultAudience : Audience
defaultAudience =
    { id = 0
    , name = ""
    , type_ = Curated
    , folder = Nothing
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, Cmd.none )


initialModel : Model
initialModel =
    { directory = directoryTree
    , currentTree = Just directoryTree
    , zipperStep = Just (Zipper.fromTree directoryTree)
    }


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }
