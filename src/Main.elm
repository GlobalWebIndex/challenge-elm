module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
import Result.Extra as Result
import Hierarchy as H exposing (Hierarchy)
import Data.Api.Endpoints as Api


buildInitialHierarchy : Result String Hierarchy
buildInitialHierarchy =
    let
        folders =
            Api.audience_folders

        audiences =
            Api.audiences

        buildHierarchy folders audiences =
            let
                withFolders =
                    List.foldl
                        (\a b -> b `Result.andThen` (H.registerFolder a))
                        (Ok H.empty)
                        folders
            in
                List.foldl
                    (\a b -> b `Result.andThen` (H.registerFile a))
                    withFolders
                    audiences
    in
        folders `Result.andThen` \a -> audiences `Result.andThen` \b -> buildHierarchy a b


type Model
    = Error String
    | Loaded (Maybe H.Node) Hierarchy


init : Model
init =
    Result.unpack Error (Loaded Nothing) buildInitialHierarchy


view : Model -> Html msg
view model =
    case model of
        Error s ->
            Html.text s

        Loaded selected hierarchy ->
            viewHierarchyLayout selected hierarchy


viewHierarchyLayout : Maybe H.Node -> Hierarchy -> Html msg
viewHierarchyLayout selected hierachy =
    div
        [ class "container-fluid" ]
        [ div [ class "row" ]
            [ div [ class "col-xs-3" ]
                [ viewHierarchySideBar hierachy ]
            , div [ class "col-xs-9" ]
                [ viewHierarchyInfo selected hierachy ]
            ]
        ]


viewHierarchySideBar : Hierarchy -> Html msg
viewHierarchySideBar h =
    div [ class "row" ]
        [ div [ class "col-xs-12" ]
            (viewCurrentNodes h)
        ]


viewCurrentNodes : Hierarchy -> List (Html msg)
viewCurrentNodes h =
    let
        res =
            H.currentNodes h

        hasUp =
            h
                |> H.currentPath
                |> Result.map List.length
                |> Result.map ((>) 0)
                |> Result.withDefault False
    in
        case res of
            Ok nodes ->
                let
                    upEntry =
                        if hasUp then
                            [ viewUp ]
                        else
                            []
                in
                    List.append upEntry <| List.map viewNode nodes

            Err msg ->
                [ div [ class "alert alert-error" ] [ text msg ] ]


viewUp : Html msg
viewUp =
    viewFolderEntry "Go Up" "go-up"


viewNode : H.Node -> Html msg
viewNode node =
    case node of
        H.File f ->
            a [ href "#", class "audience" ]
                [ div [ class "panel panel-default" ]
                    [ text f.name ]
                ]

        H.Folder count f ->
            viewFolderEntry
                (f.name ++ " (" ++ (toString count) ++ ")")
                ""


viewFolderEntry : String -> String -> Html msg
viewFolderEntry label extraClasses =
    a [ href "#", class ("folder " ++ extraClasses) ]
        [ div [ class "panel panel-default" ]
            [ span
                [ class "glyphicon glyphicon-folder-close" ]
                []
            , text label
            ]
        ]


viewHierarchyInfo : Maybe H.Node -> Hierarchy -> Html msg
viewHierarchyInfo s h =
    div [ class "row" ]
        [ div [ class "col-xs-12" ]
            [ viewBreadcrumb h ]
        , div [ class "col-xs-12" ]
            [ pre [] [ text <| toString s ] ]
        ]


viewBreadcrumb : Hierarchy -> Html msg
viewBreadcrumb h =
    let
        history =
            H.currentPath h
    in
        case history of
            Ok path ->
                ol [ class "breadcrumb" ]
                    ((li [] [ a [ href "#" ] [ text "Root" ] ])
                        :: (List.map viewBreadcrumbItem path)
                    )

            Err s ->
                div [ class "alert alert-info", attribute "role" "alert" ]
                    [ text s ]


viewBreadcrumbItem : H.Node -> Html msg
viewBreadcrumbItem node =
    let
        name =
            case node of
                H.File f ->
                    f.name

                H.Folder _ f ->
                    f.name
    in
        li [] [ a [ href "#" ] [ text name ] ]


{-| Main file of application
-}
main : Program Never
main =
    Html.beginnerProgram
        { model = init
        , view = view
        , update = identity
        }
