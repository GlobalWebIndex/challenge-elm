module Main exposing (main)

import Browser
import Data.Audience exposing (Audience, AudienceType(..))
import Data.AudienceFolder exposing (AudienceFolder)
import Data.Mocked exposing (DirElem(..), Directory, parsedDirectory)
import Html exposing (Attribute, Html, button, div, table, text, th, tr)
import Html.Attributes exposing (classList, disabled)
import Html.Events exposing (onClick)
import List exposing (any, drop, filter, head, length, map, member)
import Maybe.Extra exposing (join)
import Result exposing (Result(..))


type alias Model =
    { directory : Directory
    , parents : List (Maybe Int)
    , filterBy : AudienceType
    }


type Msg
    = OpenFolder AudienceFolder
    | GoUp
    | ChangeFilter AudienceType


parentIs : Maybe Int -> DirElem -> Bool
parentIs id de =
    case de of
        File audience ->
            audience.folder == id

        Folder audienceFolder ->
            audienceFolder.parent == id


typeIs : AudienceType -> DirElem -> Bool
typeIs at de =
    case ( de, at ) of
        ( File audience, _ ) ->
            audience.type_ == at

        ( _, Shared ) ->
            False

        _ ->
            True


parentAndTypeAre : Maybe Int -> AudienceType -> DirElem -> Bool
parentAndTypeAre id at de =
    case de of
        File audience ->
            typeIs at de && parentIs id de

        _ ->
            parentIs id de && True


init : Model
init =
    { directory = filter (parentAndTypeAre Nothing Authored) parsedDirectory
    , parents = []
    , filterBy = Authored
    }


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



{- Either uses the passed function to filter the directory or returns `typeIs Shared` to avoid
   tree structure for `Shared` audiences
-}


filterBySelectedFilter : (DirElem -> Bool) -> AudienceType -> (DirElem -> Bool)
filterBySelectedFilter f at =
    case at of
        Shared ->
            typeIs Shared

        _ ->
            f


update : Msg -> Model -> Model
update msg model =
    case msg of
        OpenFolder folder ->
            let
                filteredDir =
                    filter
                        (filterBySelectedFilter
                            (parentAndTypeAre (Just folder.id) model.filterBy)
                            model.filterBy
                        )
                        parsedDirectory
            in
            { model
                | directory = filteredDir
                , parents = folder.parent :: model.parents
            }

        GoUp ->
            let
                filteredDir =
                    filter
                        (filterBySelectedFilter
                            (parentAndTypeAre (join <| head model.parents) model.filterBy)
                            model.filterBy
                        )
                        parsedDirectory
            in
            { model
                | directory = filteredDir
                , parents = drop 1 model.parents
            }

        ChangeFilter at ->
            let
                filteredDir =
                    filter (filterBySelectedFilter (parentAndTypeAre Nothing at) at) parsedDirectory
            in
            { directory = filteredDir
            , parents = []
            , filterBy = at
            }


showAudienceType : AudienceType -> String
showAudienceType at =
    case at of
        Authored ->
            "Authored"

        Shared ->
            "Shared"

        Curated ->
            "Curated"


filterButtonView : AudienceType -> AudienceType -> Html Msg
filterButtonView at filter =
    button
        [ classList [ ( "selected", at == filter ) ]
        , disabled <| at == filter
        , onClick <| ChangeFilter at
        ]
        [ text <| showAudienceType at ]


filterPanelView : Model -> Html Msg
filterPanelView model =
    table []
        [ tr []
            [ th []
                [ filterButtonView Authored model.filterBy
                ]
            , th []
                [ filterButtonView Shared model.filterBy
                ]
            , th []
                [ filterButtonView Curated model.filterBy
                ]
            ]
        ]


audienceView : Audience -> Html Msg
audienceView a =
    div
        [ classList [ ( "dir-elem", True ), ( "file", True ) ]
        ]
        [ text <| a.name ++ " - [" ++ showAudienceType a.type_ ++ "]"
        ]


audienceFolderView : AudienceFolder -> Html Msg
audienceFolderView af =
    div
        [ onClick <| OpenFolder af
        , classList [ ( "dir-elem", True ), ( "folder", True ) ]
        ]
        [ text <| "🗀 Folder: " ++ af.name ]


dirElemView : DirElem -> Html Msg
dirElemView de =
    case de of
        File a ->
            audienceView a

        Folder af ->
            audienceFolderView af


goUpView : Model -> List (Html Msg)
goUpView model =
    if length model.parents > 0 then
        [ div
            [ onClick GoUp
            , classList [ ( "dir-elem", True ), ( "folder", True ) ]
            ]
            [ text ".." ]
        ]

    else
        []


view : Model -> Html Msg
view model =
    div [] <|
        [ filterPanelView model ]
            ++ (goUpView model
                    ++ map dirElemView model.directory
               )
