module Main exposing (main)

-- Import Modules

import Data.Audience exposing (audiences)
import Data.AudienceFolder exposing (audienceFolders)
import Html exposing (Attribute, Html, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Lazy.Tree.Zipper as Zipper exposing (Zipper)
import NavTree exposing (TreeItem, isFolderWithId)


{-| Main file of application
-}
main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }


model : Model
model =
    NavTree.build audienceFolders audiences
        |> Zipper.fromTree


type Msg
    = GoUp
    | OpenFolder Int


type alias Model =
    Zipper TreeItem


update : Msg -> Model -> Model
update msg zipper =
    case msg of
        GoUp ->
            Zipper.up zipper
                -- Nothing means we're already at the root, OK to stay there
                |> Maybe.withDefault zipper

        OpenFolder folderId ->
            Zipper.open (isFolderWithId folderId) zipper
                |> Maybe.withDefault zipper


view : Model -> Html Msg
view model =
    let
        openedFolderItems =
            NavTree.sortItems <| Zipper.children model

        perhapsEmptyFolder =
            if List.isEmpty openedFolderItems then
                [ navigationItem "This folder is empty" "lightgray" [] ]
            else
                []

        goUpButtonIfNotAtRoot =
            if Zipper.isRoot model then
                []
            else
                [ navigationItem "⇦ Go Up" "gray" [ onClick GoUp ] ]
    in
    Html.ul [ style [ ( "font-family", "sans-serif" ) ] ]
        (goUpButtonIfNotAtRoot
            ++ List.map viewItem openedFolderItems
            ++ perhapsEmptyFolder
        )


viewItem : TreeItem -> Html Msg
viewItem =
    NavTree.withTreeItem
        (\audienceFolder -> navigationItem ("🗀 " ++ audienceFolder.name) "#3a6187" [ onClick (OpenFolder audienceFolder.id) ])
        (\audience -> navigationItem audience.name "#1db6e5" [])


navigationItem : String -> String -> List (Attribute Msg) -> Html Msg
navigationItem label bgcolor additionalAttributes =
    Html.li
        (style
            -- Using inline style to make the implementation easy to run
            -- normally this would be factored out to external CSS file; alternatively elm-css could be used
            [ ( "background-color", bgcolor )
            , ( "color", "white" )
            , ( "margin", "5px" )
            , ( "width", "200px" )
            , ( "padding", "15px" )
            , ( "border-radius", "5px" )
            , ( "text-overflow", "ellipsis" )
            , ( "overflow", "hidden" )
            ]
            :: additionalAttributes
        )
        [ text label ]
