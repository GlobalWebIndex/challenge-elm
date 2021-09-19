module Main exposing (main)

import Browser
import Data.Audience exposing (Audience, AudienceType(..), audiencesJSON)
import Data.AudienceFolder exposing (AudienceFolder, audienceFoldersJSON)
import Dict.Any as AnyDict exposing (AnyDict)
import FontAwesome as FA
import Html exposing (..)
import Html.Attributes exposing (class, classList, id)
import Html.Events exposing (onClick)
import Json.Decode as Decode exposing (Decoder, decodeString, field, float, int, list, nullable, string)
import Json.Decode.Pipeline exposing (optional, required, requiredAt)
import Tree as Tree exposing (Tree)
import Tree.Zipper as Zipper exposing (Zipper)


type Node
    = Dir AudienceFolderId AudienceFolder
    | File AudienceId Audience
    | Root


type alias Id =
    Int


type AudienceId
    = AudienceId Id


type AudienceFolderId
    = AudienceFolderId Id


type RootId
    = RootId Id


type NodeId
    = NodeDir AudienceFolderId
    | NodeFile AudienceId
    | NodeRoot RootId


directoryTree : Tree Node
directoryTree =
    let
        {--
        retrieveAllChild : NodeId -> (Node, List NodeId)
        retrieveAllChild parentNodeId =
            parentChildNodesOnlyDict
                |> Maybe.andThen (AnyDict.get parentNodeId)
                -- Got all the children now
                |> Maybe.map (List.map nodeToNodeId)
                |> (\maybeNodeIds -> Maybe.map2 Tuple.pair (nodeIdToNode parentNodeId) maybeNodeIds)
                |> Maybe.withDefault ( Root, [] )
                --
                --}
        retrieveAllChild : NodeId -> ( Node, List NodeId )
        retrieveAllChild parentNodeId =
            parentChildNodesOnlyDict
                |> Maybe.andThen (AnyDict.get parentNodeId)
                |> Maybe.withDefault []
                -- Got all the children now
                |> List.map nodeToNodeId
                |> Tuple.pair (nodeIdToNode parentNodeId)
    in
    Tree.unfold retrieveAllChild (NodeRoot (RootId 0))



-- Node(s) in Dict and List


allNodes : Maybe (List Node)
allNodes =
    let
        audienceFolders : Maybe (List AudienceFolder)
        audienceFolders =
            decodeAudienceFolders

        audiences : Maybe (List Audience)
        audiences =
            decodeAudiences
    in
    Maybe.map2 List.append
        (Maybe.map (List.map (\audienceFolder -> Dir (AudienceFolderId audienceFolder.id) audienceFolder)) audienceFolders)
        (Maybe.map (List.map (\audience -> File (AudienceId audience.id) audience)) audiences)


allNodesInDict : Maybe (AnyDict ( String, Int ) NodeId Node)
allNodesInDict =
    allNodes
        |> Maybe.map (List.map (\node -> ( nodeToNodeId node, node )))
        |> Maybe.map (AnyDict.fromList comparableKey)


parentChildNodesOnlyDict : Maybe (AnyDict ( String, Int ) NodeId (List Node))
parentChildNodesOnlyDict =
    let
        insertChildIntoParent : Node -> AnyDict ( String, Int ) NodeId (List Node) -> AnyDict ( String, Int ) NodeId (List Node)
        insertChildIntoParent node dict =
            case node of
                Dir nodeId audienceFolder ->
                    case audienceFolder.parent of
                        Just parentId ->
                            saveToDict dict ( NodeDir (AudienceFolderId parentId), Dir nodeId audienceFolder )

                        Nothing ->
                            -- 0 represents Root id
                            saveToDict dict ( NodeRoot (RootId 0), Dir nodeId audienceFolder )

                File nodeId audience ->
                    case audience.folder of
                        Just parentId ->
                            saveToDict dict ( NodeDir (AudienceFolderId parentId), File nodeId audience )

                        Nothing ->
                            -- 0 represents Root id
                            saveToDict dict ( NodeRoot (RootId 0), File nodeId audience )

                Root ->
                    -- This state won't be reached as there are no Root node in allNodes
                    dict

        saveToDict : AnyDict ( String, Int ) NodeId (List Node) -> ( NodeId, Node ) -> AnyDict ( String, Int ) NodeId (List Node)
        saveToDict dict ( parentNode, node ) =
            case AnyDict.get parentNode dict of
                Just childNodes ->
                    AnyDict.insert parentNode (node :: childNodes) dict

                Nothing ->
                    AnyDict.insert parentNode (node :: []) dict
    in
    allNodes
        |> Maybe.map (List.foldr insertChildIntoParent (AnyDict.empty comparableKey))



-- Generic functions


comparableKey : NodeId -> ( String, Int )
comparableKey nodeId =
    case nodeId of
        NodeFile (AudienceId id) ->
            ( "audience", id )

        NodeDir (AudienceFolderId id) ->
            ( "audience-folder", id )

        NodeRoot (RootId id) ->
            ( "root", id )



--nodeIdToNode : NodeId -> Maybe Node


nodeIdToNode : NodeId -> Node
nodeIdToNode nodeId =
    allNodesInDict
        |> Maybe.andThen (AnyDict.get nodeId)
        |> Maybe.withDefault Root


nodeToNodeId : Node -> NodeId
nodeToNodeId node =
    case node of
        Dir (AudienceFolderId id) audienceFolder ->
            NodeDir (AudienceFolderId id)

        File (AudienceId id) audience ->
            NodeFile (AudienceId id)

        Root ->
            NodeRoot (RootId 0)


nodeName : Node -> String
nodeName node =
    case node of
        Dir id audienceFolder ->
            audienceFolder.name

        File id audience ->
            audience.name

        Root ->
            "Home"



-- Utility functions for traversing a Tree
-- Finding a Tree with node
-- Get children Nodes of certain parent tree


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
    let
        focusOnSubTree : Maybe (Zipper Node) -> Node -> Maybe (Zipper Node)
        focusOnSubTree zipper goToNode =
            Maybe.andThen (Zipper.findFromRoot (\node -> node == goToNode)) zipper

        goToParent : Maybe (Zipper Node) -> Maybe (Zipper Node)
        goToParent zipper =
            Maybe.andThen Zipper.parent zipper
    in
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GoTo node ->
            ( focusOnSubTree model node, Cmd.none )

        GoUp ->
            ( goToParent model, Cmd.none )



-- VIEW


type alias Model =
    Maybe (Zipper.Zipper Node)


view : Model -> Html Msg
view model =
    case model of
        Just zipper ->
            let
                nodes : List Node
                nodes =
                    Zipper.tree zipper
                        |> getChildrenNodes
            in
            div [ class "w-screen h-screen bg-gray-50" ]
                [ div [ class "w-full h-auto" ]
                    [ viewBackButton zipper
                    , div []
                        (List.append
                            (viewNodes nodes ViewFolder)
                            (viewNodes nodes ViewFile)
                        )
                    ]
                ]

        Nothing ->
            div [] [ text "Error loading data" ]


viewBackButton : Zipper Node -> Html Msg
viewBackButton zipper =
    case Zipper.label zipper of
        Root ->
            div [] []

        node ->
            div [ class "w-full bg-gray-800 px-4 py-4 cursor-pointer", onClick GoUp ]
                [ span [ class "text-white " ] [ FA.icon FA.arrowAltLeft ]
                , span [ class "inline-block ml-2 text-white font-bold" ] [ text <| nodeName node ]
                ]


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
    in
    nodesToBeViewed
        |> List.map (\node -> viewNode node viewType (GoTo node))


type alias ViewConfig =
    { icon : Maybe FA.Icon
    , isDark : Bool
    , cursorPointerType : String
    }


viewNode : Node -> ViewType -> Msg -> Html Msg
viewNode node viewType toMsg =
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
            { icon = Just FA.folder
            , isDark = False
            , cursorPointerType = "cursor-pointer"
            }

        fileViewConfig : ViewConfig
        fileViewConfig =
            { icon = Nothing
            , isDark = True
            , cursorPointerType = "cursor-default"
            }

        attachOnClick : List (Attribute Msg)
        attachOnClick =
            case viewType of
                ViewFolder ->
                    [ onClick toMsg ]

                ViewFile ->
                    []

        viewIcon : Maybe FA.Icon -> List (Html Msg)
        viewIcon maybeIcon =
            case maybeIcon of
                Just icon ->
                    [ FA.icon icon ]

                Nothing ->
                    []
    in
    div
        [ class "h-12 bg-gray-100 border-b border-gray-200 hover:bg-gray-600"
        , classList
            [ ( "bg-gray-200", config.isDark )
            , ( "border-gray-300", config.isDark )
            , ( config.cursorPointerType, True )
            ]
        ]
        [ div ([ class "group w-5/6 h-full mx-auto flex items-center justify-between" ] ++ attachOnClick)
            [ span [ class "font-semibold text-gray-800 leading-loose group-hover:text-white" ] [ text (nodeName node) ]
            , span [ class "text-gray-400 group-hover:text-white" ] (viewIcon config.icon)
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

        val ->
            Decode.fail <| "\"type:\" is malformed. The value is " ++ val



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


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, Cmd.none )


initialModel : Model
initialModel =
    Just directoryTree
        |> Maybe.map Zipper.fromTree


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }
