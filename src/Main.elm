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


defaultTree : Tree.Tree Node
defaultTree =
    Tree.singleton (File defaultAudience.id defaultAudience)


directoryTree : Tree Node
directoryTree =
    let
        buildTree : Id -> ( Node, List Id )
        buildTree parentId =
            parentChildNodesOnlyDict
                |> Dict.get parentId
                |> Maybe.withDefault []
                |> List.map nodeToId
                |> Tuple.pair (idToNode parentId)
    in
    Tree.unfold buildTree 0



-- Node(s) in Dict and List


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


allNodesInDict : Dict Id Node
allNodesInDict =
    allNodes
        |> List.map (\node -> ( nodeToId node, node ))
        |> Dict.fromList


parentChildNodesOnlyDict : Dict Id (List Node)
parentChildNodesOnlyDict =
    let
        insertChildIntoParent : Node -> Dict Id (List Node) -> Dict Id (List Node)
        insertChildIntoParent node dict =
            case node of
                Dir id audienceFolder ->
                    case audienceFolder.parent of
                        Just parentId ->
                            saveToDict dict ( parentId, Dir id audienceFolder )

                        Nothing ->
                            -- 0 represents Root id
                            saveToDict dict ( 0, Dir id audienceFolder )

                File id audience ->
                    case audience.folder of
                        Just parentId ->
                            saveToDict dict ( parentId, File id audience )

                        Nothing ->
                            -- 0 represents Root id
                            saveToDict dict ( 0, File id audience )

                Root ->
                    -- This state won't be reached as there are no Root node in allNodes
                    dict

        saveToDict : Dict Id (List Node) -> ( Id, Node ) -> Dict Id (List Node)
        saveToDict dict ( id, node ) =
            case Dict.get id dict of
                Just childNodes ->
                    Dict.insert id (node :: childNodes) dict

                Nothing ->
                    Dict.insert id (node :: []) dict
    in
    List.foldr insertChildIntoParent Dict.empty allNodes



-- Generic functions


idToNode : Id -> Node
idToNode id =
    allNodesInDict
        |> Dict.get id
        |> Maybe.withDefault Root


nodeToId : Node -> Id
nodeToId node =
    case node of
        Dir id audienceFolder ->
            id

        File id audience ->
            id

        Root ->
            0


nodeName : Node -> String
nodeName node =
    case node of
        Dir id audienceFolder ->
            audienceFolder.name

        File id audience ->
            audience.name

        Root ->
            ""



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
    in
    nodesToBeViewed
        |> List.map (\node -> viewNode node viewType (GoTo node))


type alias ViewConfig =
    { icon : Html Msg
    , isDark : Bool
    , cursorPointer : ( String, Bool )
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
            [ span [ class "font-semibold text-gray-800 leading-loose group-hover:text-white" ] [ text (nodeName node) ]
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
