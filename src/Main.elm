module Main exposing (main)

-- Import Modules

import Data.Audience exposing (Audience, decodeAudiences)
import Data.AudienceFolder exposing (AudienceFolder, decodeAudienceFolders)
import Html exposing (Html)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)
import Tree exposing (Tree, Id, Node(..), ParentId(..))


{-| Datatype for tree - it can contain folder or audience but we have Tree a - so
    there should be one union type for it
-}
type TreeItem
    = AudienceItem Audience
    | Folder AudienceFolder


type alias Model =
    { currentNodeId : ParentId
    }


model : Model
model =
    { currentNodeId = Root
    }


{-| Create data structure for folders and audiences.
    It builds folders first and than added audiences. There will be problem
    during build in some cases:
    - when there are any circular dependencies
      - this can be solved e.g. by failing when the insert alg. reaches some
        critical depth
    - when the folder or audience depends on parent that has not yet been added
      to structure
      - this can be solved with ordering the input data by parents id or maybe
        by some lazy loading

    Luckily the data are nicely ordered and we are adding audiences only to
    folders that are not so crazily nested

-}
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
            decodeAudienceFolders
                |> Result.withDefault []
                |> List.foldl
                    (\folder tree -> Tree.insert (getParentNode folder.parent) folder.id (Folder folder) tree)
                    Tree.empty
    in
        decodeAudiences
            |> Result.withDefault []
            |> List.foldl
                (\audience tree -> Tree.insert (getParentNode audience.folder) audience.id (AudienceItem audience) tree)
                folderTree


{-| Main file of application
-}
main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = model
        , update = update
        , view = view
        }


{-| Update part
-}
type Msg
    = ShowSubtree ParentId


update : Msg -> Model -> Model
update msg model =
    case msg of
        ShowSubtree subtree ->
            { model | currentNodeId = subtree }


{-| View part
    The view is made as simple as possible. I focused on tree data structure
    and parsing and also wanted to be able to run this demo with elm reactor.

    It just works - I know I can make it much mode nicer with Bootstrap or
    some other framework, but that was not the objective of this exercise ;)


-}
view : Model -> Html Msg
view model =
    Html.div []
        [ Html.h1 [] [ Html.text "GWT Challenge" ]
        , viewNavigation model
        , viewTree model.currentNodeId audiencesTree
        ]


viewNavigation : Model -> Html Msg
viewNavigation model =
    let
        getParentId currentId =
            case currentId of
                Root ->
                    Root

                NodeId id ->
                    Tree.getParentId id audiencesTree
    in
        if not (model.currentNodeId == Root) then
            Html.a
                [ href "#"
                , onClick (ShowSubtree <| getParentId model.currentNodeId)
                ]
                [ Html.text "^^ Go Up ^^" ]
        else
            Html.div [] []


viewTree : ParentId -> Tree TreeItem -> Html Msg
viewTree parentId tree =
    let
        viewNode (Node _ value children) =
            case value of
                Folder folder ->
                    viewFolder folder children

                AudienceItem audience ->
                    viewAudience audience
    in
        Html.ul []
            (Tree.getSubtree parentId tree
                |> List.map viewNode
            )


viewFolder : AudienceFolder -> List (Node a) -> Html Msg
viewFolder folder children =
    Html.li []
        [ Html.a [ href "#", onClick (ShowSubtree (NodeId folder.id)) ]
            [ Html.text ("[" ++ folder.name ++ "]")
            ]
        ]


viewAudience : Audience -> Html Msg
viewAudience audience =
    Html.li [] [ Html.text ("|--- " ++ audience.name) ]
