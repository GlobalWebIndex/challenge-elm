module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App as Html
import Result.Extra as Result
import Hierarchy as H exposing (Hierarchy)
import Data.Api.Endpoints as Api


-- MODEL


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



-- UPDATE


type Msg
    = GoDown Int
    | GoUp Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        GoDown id ->
            updateGoDown id model

        GoUp levels ->
            updateGoUp levels model


updateGoUp : Int -> Model -> Model
updateGoUp levels model =
    case model of
        Error _ ->
            model

        Loaded s h ->
            Loaded s (H.goup levels h)


updateGoDown : Int -> Model -> Model
updateGoDown id model =
    case model of
        Error _ ->
            model

        Loaded s hierarchy ->
            hierarchy
                |> H.godown id
                |> Result.unpack Error (Loaded s)



-- VIEW


view : Model -> Html Msg
view model =
    case model of
        Error s ->
            Html.text s

        Loaded selected hierarchy ->
            viewHierarchyLayout selected hierarchy


viewHierarchyLayout : Maybe H.Node -> Hierarchy -> Html Msg
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


viewHierarchySideBar : Hierarchy -> Html Msg
viewHierarchySideBar h =
    div [ class "row" ]
        [ div [ class "col-xs-12" ]
            (viewCurrentNodes h)
        ]


viewCurrentNodes : Hierarchy -> List (Html Msg)
viewCurrentNodes h =
    let
        res =
            H.currentNodes h

        hasUp =
            h
                |> H.currentPath
                |> Result.map List.length
                |> Result.map (flip (>) 0)
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


viewUp : Html Msg
viewUp =
    viewFolderEntry "Go Up" "go-up" (GoUp 1)


viewNode : H.Node -> Html Msg
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
                (GoDown f.id)


viewFolderEntry : String -> String -> Msg -> Html Msg
viewFolderEntry label extraClasses onPickMsg =
    a
        [ href "#"
        , class ("folder " ++ extraClasses)
        , onClick onPickMsg
        ]
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
            [ h6 [] [ text "Selected Node" ] ]
        , div [ class "col-xs-12" ]
            [ pre [] [ text <| toString s ] ]
        , div [ class "col-xs-12" ]
            [ h6 [] [ text "Current path" ] ]
        , div [ class "col-xs-12" ]
            [ pre [] [ text <| toString <| H.currentPath h ] ]
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
        , update = update
        }
