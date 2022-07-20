module Main exposing (main)

{-| Using elm-live for hot reloading to make development just a bit more comfortable. Overall prefer using create-elm-app because of it's debugging features,
but that usually requires to generate a brand new project.
-}

import Browser exposing (element)
import Data.Audience exposing (decodeDataAudience, audiencesJSON, Audience)
import Data.AudienceFolder exposing (audienceFoldersJSON, AudienceFolder, decodeDataAudienceFolder)
import Html exposing (..)
import Dict exposing (update)
import Json.Decode as Decode exposing (string)
import List exposing (sortBy)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)
import Material.Icons.Outlined as Outlined
import Material.Icons.Types exposing (Coloring(..))
import Color
import Set exposing (fromList)

--overall skeleton, will match based on ID in the view function
type alias Model =
    {
        
        --currentFolderId - Nothing means root, otherwise show folder and it's children
        currentFolderId: Maybe Int,
        folders: List AudienceFolder,
        audiences: List Audience,
        filter: List Data.Audience.AudienceType
    }

type Msg
    = NoOp
    | Select Int
    | GoUp (Maybe Int)


init : () -> ( Model, Cmd Msg )
init _ = 
    ({ 
        currentFolderId = Nothing,
        folders = 
            --decode audienceFolder json into AudienceFolder List
            case Decode.decodeString decodeDataAudienceFolder audienceFoldersJSON of
                Ok res ->
                    sortBy .id res
                _ ->
                    [],
        audiences = 
            --decode audience json into Audience List
            case Decode.decodeString decodeDataAudience audiencesJSON of
                Ok res ->
                    sortBy .id res
                _ ->
                    [],
        filter = [ Data.Audience.Authored ]
    }, Cmd.none)

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Select id ->
            ({ model | currentFolderId = Just id }, Cmd.none)
        GoUp id ->
            ({ model | currentFolderId = id }, Cmd.none)
        _ ->
            (model, Cmd.none)

view : Model -> Html Msg
view model =
    div [][
        -- text (Debug.toString model.currentFolderId),
        div[][
            button[][
                text "Authored"
            ],
            button[][
                text "Shared"
            ],
            button[][
                text "Curated"
            ]
        ],
        (
            List.map (\folder ->
                let
                    opened = 
                        case model.currentFolderId of
                        Just id ->
                            if folder.id == id then
                                True
                            else 
                                False
                        Nothing ->
                            False
                in
                span[  
                    if opened then
                        onClick (GoUp folder.parent)
                    else 
                        onClick (Select folder.id)
                , style "cursor" "pointer" ][
                     Data.AudienceFolder.view folder opened
                ]
            )( filterAudienceFolders model.folders model.currentFolderId)
        ) |> div[],
        div[][
            (
                List.map( \audience ->
                    Data.Audience.view audience   
                )(filterAudiences model.audiences model.currentFolderId)
            ) |> div[]
        ]
    ]

filterAudienceFolders: List AudienceFolder -> Maybe Int -> List AudienceFolder
filterAudienceFolders folders currentFolderId =
    {- | Filter all eligible folders that should be displayed for the current level.
    -}
    List.filter (\e ->
        case currentFolderId of
            Just val ->
                if e.id == val then
                    True
                else
                    case e.parent of
                        Just parentID ->
                            if parentID == val then
                                True
                            else
                                False
                        _ ->
                            False
            _ ->
                case e.parent of 
                    Nothing ->
                        True
                    _ ->
                        False
    ) folders


filterAudiences: List Audience -> Maybe Int -> List Audience
filterAudiences audiences currentFolderId =
    {- | Filter all eligible audiences that should be displayed for the current level.
    -}
    List.filter(\e -> 
        case currentFolderId of
        Just val ->
            if e.id == val then
                True
            else
                case e.folder of
                    Just folderID ->
                        if folderID == val then
                            True
                        else
                            False
                    _ ->
                        False
        _ ->
            if e.folder == Nothing then
                True
            else
                False
    ) audiences


subscriptions : Model -> Sub msg
subscriptions model =
    Sub.none

main : Program () Model Msg
main =
    Browser.element
    {
        init = init,
        view = view,
        update = update,
        subscriptions = subscriptions
    }
