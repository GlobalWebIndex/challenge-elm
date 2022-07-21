module Main exposing (main)

{-| Using elm-live for hot reloading to make development just a bit more comfortable. Overall prefer using create-elm-app because of it's debugging features,
but that usually requires to generate a brand new project.
-}

import Browser exposing (element)
import Color
import Data.Audience exposing (Audience, allTypes, audiencesJSON, decodeDataAudience)
import Data.AudienceFolder exposing (AudienceFolder, audienceFoldersJSON, decodeDataAudienceFolder)
import Html exposing (..)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Json.Decode as Decode exposing (string)
import List exposing (sortBy)
import Material.Icons.Outlined as Outlined
import Material.Icons.Types exposing (Coloring(..))
import Set exposing (fromList)



{- |
   currentFolderId - Nothing means root, otherwise (Just folderID) show folder and it's children. The entire model represents the state of the folder tree. The approach I use
   uses maps and filters to display the folder tree component. It might be better to use Dict for Part 2, as it spares us from having to filter the folder and audience
   lists every time the category is changed (and only display values stored at a specific key). Classic dict can only use a comparable key though, so no using AudienceType
   there. Only way would be to match AudienceType to Int values and use this method to initially create the Dict structure. I think presented solution should be satisfactory,
   as the performance impact should in this case be hardly noticable and we have a guarantee that the view will always work with accurate data (if we dynamically obtained
   the data, view would always display it accurately - on the opposite site, the Dict would grow outdated and would therefore need to be updated too, which
   kind of defeats the purpose of creating it in the first place).
-}
{- | Use elm-live to launch the app. Install elm live and launch it with commands:

   npm i -g elm-live
   elm-live src/Main.elm --open -- --output elm.js

-}


type alias Model =
    { currentFolderId : Maybe Int
    , folders : List AudienceFolder
    , audiences : List Audience
    , filter : Data.Audience.AudienceType
    }


type Msg
    = Select Int
    | GoUp (Maybe Int)
    | Filter Data.Audience.AudienceType


init : () -> ( Model, Cmd Msg )
init _ =
    ( { currentFolderId = Nothing
      , folders =
            --decode audienceFolder json into AudienceFolder List
            case Decode.decodeString decodeDataAudienceFolder audienceFoldersJSON of
                Ok res ->
                    res

                _ ->
                    []
      , audiences =
            --decode audience json into Audience List
            case Decode.decodeString decodeDataAudience audiencesJSON of
                Ok res ->
                    res

                _ ->
                    []
      , filter = Data.Audience.Authored
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Select id ->
            ( { model | currentFolderId = Just id }, Cmd.none )

        GoUp id ->
            ( { model | currentFolderId = id }, Cmd.none )

        Filter type_ ->
            ( { model | filter = type_, currentFolderId = Nothing }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ -- display the buttons to filter by type_,
          List.map
            (\type_ ->
                button
                    [ onClick (Filter type_)
                    , class "button-group-button"
                    , if model.filter == type_ then
                        style "opacity" "0.5"

                      else
                        style "opacity" "1"
                    ]
                    [ text (Debug.toString type_) ]
            )
            allTypes
            |> div [ class "button-group" ]

        --folders are handled here
        , List.map
            (\folder ->
                let
                    --is the current folder opened? (only one folder can be opened at a time)
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
                div
                    []
                    [ Data.AudienceFolder.view folder opened (Select folder.id) (GoUp folder.parent)
                    ]
            )
            (case model.filter of
                Data.Audience.Shared ->
                    []

                _ ->
                    filterAudienceFolders model.folders model.currentFolderId
            )
            |> div []

        --audiences are handled here
        , div []
            [ List.map
                (\audience ->
                    Data.Audience.view audience
                )
                (case model.filter of
                    Data.Audience.Shared ->
                        filterAudienceCategory model.audiences Data.Audience.Shared

                    filterValue ->
                        filterAudiences (filterAudienceCategory model.audiences filterValue) model.currentFolderId
                )
                |> div []
            ]
        ]


filterAudienceCategory : List Audience -> Data.Audience.AudienceType -> List Audience
filterAudienceCategory audiences type_ =
    {- | Helper function to use with List.filter, separate audiences by type_ -}
    List.filter
        (\e ->
            if e.type_ == type_ then
                True

            else
                False
        )
        audiences


filterAudienceFolders : List AudienceFolder -> Maybe Int -> List AudienceFolder
filterAudienceFolders folders currentFolderId =
    {- | Filter all eligible folders that should be displayed for the current level. -}
    List.filter
        (\e ->
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
        )
        folders


filterAudiences : List Audience -> Maybe Int -> List Audience
filterAudiences audiences currentFolderId =
    {- | Filter all eligible audiences that should be displayed for the current level. -}
    List.filter
        (\e ->
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
        )
        audiences


subscriptions : Model -> Sub msg
subscriptions model =
    Sub.none


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
