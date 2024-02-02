module Main exposing (..)

import Browser
import Data.Audience as Audience
import Data.AudienceFolder as AudienceFolder
import Html exposing (Html, button, div, img, li, text, ul)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Http exposing (..)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)
import List.Extra as ListE
import RemoteData


urlGetAudienceFolders : String
urlGetAudienceFolders =
    "http://localhost:8000/jsons/audienceFolder.json"


urlGetAudiences : String
urlGetAudiences =
    "http://localhost:8000/jsons/audience.json"


type alias Model =
    { audienceFolders : RemoteData.WebData (List AudienceFolder.AudienceFolder)
    , audiences : RemoteData.WebData (List Audience.Audience)
    , currentFolderId : Maybe Int
    , previousFolderIds : List Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { audienceFolders = RemoteData.NotAsked
      , audiences = RemoteData.NotAsked
      , currentFolderId = Nothing
      , previousFolderIds = []
      }
    , Cmd.batch [ fetchAudienceFolders, fetchAudiences ]
    )


type Msg
    = FetchAudienceFolders
    | GotAudienceFolders (Result Http.Error (List AudienceFolder.AudienceFolder))
    | FetchAudiences
    | GotAudiences (Result Http.Error (List Audience.Audience))
    | ChangeCurrentFolderIdAndAddItToPreviousList Int
    | RemoveCurrentFolderIdAndGoBack


fetchAudienceFolders : Cmd Msg
fetchAudienceFolders =
    Http.get
        { url = urlGetAudienceFolders
        , expect = Http.expectJson GotAudienceFolders decodeAudienceFolders
        }


fetchAudiences : Cmd Msg
fetchAudiences =
    Http.get
        { url = urlGetAudiences
        , expect = Http.expectJson GotAudiences decodeAudiences
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchAudienceFolders ->
            ( { model | audienceFolders = RemoteData.Loading }
            , Cmd.none
            )

        GotAudienceFolders (Ok audienceFolders) ->
            ( { model | audienceFolders = RemoteData.Success audienceFolders }
            , Cmd.none
            )

        GotAudienceFolders (Err err) ->
            ( { model | audienceFolders = RemoteData.Failure err }
            , Cmd.none
            )

        FetchAudiences ->
            ( { model | audiences = RemoteData.Loading }
            , Cmd.none
            )

        GotAudiences (Ok audiences) ->
            ( { model | audiences = RemoteData.Success audiences }
            , Cmd.none
            )

        GotAudiences (Err err) ->
            ( { model | audiences = RemoteData.Failure err }, Cmd.none )

        ChangeCurrentFolderIdAndAddItToPreviousList folderId ->
            let
                newModel =
                    { model
                        | currentFolderId = Just folderId
                        , previousFolderIds = folderId :: model.previousFolderIds
                    }
            in
            ( newModel, Cmd.none )

        RemoveCurrentFolderIdAndGoBack ->
            let
                newCurrentFolderId =
                    List.head (List.drop 1 model.previousFolderIds)

                updatedPreviousFolderIds =
                    case List.reverse model.previousFolderIds of
                        _ :: rest ->
                            List.reverse rest

                        _ ->
                            []
            in
            ( { model
                | currentFolderId = newCurrentFolderId
                , previousFolderIds = updatedPreviousFolderIds
              }
            , Cmd.none
            )


view : Model -> Browser.Document Msg
view model =
    { title = "GWI Elm Challenge"
    , body =
        [ div [ class "centered" ]
            [ case model.audienceFolders of
                RemoteData.NotAsked ->
                    text "Not Asked"

                RemoteData.Loading ->
                    text "Loading"

                RemoteData.Success audienceFolders ->
                    case model.audiences of
                        RemoteData.NotAsked ->
                            text "Not Asked"

                        RemoteData.Loading ->
                            text "Loading"

                        RemoteData.Success audiences ->
                            if model.currentFolderId == Nothing then
                                viewFolders audienceFolders audiences model

                            else
                                let
                                    sonContent =
                                        List.filter (\item -> item.folder == model.currentFolderId) audiences

                                    sonFoldersContent =
                                        List.filter (\item -> item.parent == model.currentFolderId) audienceFolders
                                in
                                viewFolders sonFoldersContent sonContent model

                        RemoteData.Failure _ ->
                            text "Something went wrong"

                RemoteData.Failure _ ->
                    text "Something went wrong"
            ]
        ]
    }


viewFolders : List AudienceFolder.AudienceFolder -> List Audience.Audience -> Model -> Html Msg
viewFolders audienceFolders audiences model =
    let
        {-
           Maybe a litle big complex, the idea of this function is to filter the items that are not
           in the list. Why? Because the items that has not folders and are not repeated int the list are the files
        -}
        uniqueItems =
            if model.currentFolderId == Nothing then
                List.filter (\item -> item.folder == Nothing && (ListE.count ((==) item.id) <| List.map .id audiences) == 1) audiences

            else
                List.filter (\item -> item.folder == model.currentFolderId && (ListE.count ((==) item.id) <| List.map .id audiences) == 1) audiences

        filteredIds =
            List.map .id uniqueItems

        {-
           Same idea, but reversed. If the ids filtered above are not in the list, then they are folders
        -}
        itemsNotInList =
            List.filter (\item -> not (List.member item.id filteredIds)) audiences
    in
    div []
        [ ul [] [ viewButtonGoBack model ]
        , ul [] (List.map (\folder -> viewAudienceFolders folder model) audienceFolders)
        , ul [] (List.map viewAudiences itemsNotInList)
        , ul [] (List.map viewAudienceFiles uniqueItems)
        ]


viewAudienceFolders : AudienceFolder.AudienceFolder -> Model -> Html Msg
viewAudienceFolders folder model =
    let
        {-
           Why of this validation? Because with this logic, there are to options available:
               - Folders in the root directory, witch are gonna be the first ones to be displayed
               - Folders that are children of the current folder. But if I only check if folder.parent
                 is Nothing, then the children folders never gonna be displayed.
        -}
        validFolder =
            folder.parent == Nothing || folder.parent /= Nothing && folder.parent == model.currentFolderId
    in
    if validFolder then
        div [ class "folder" ]
            [ li []
                [ button [ class "folder-button", onClick (ChangeCurrentFolderIdAndAddItToPreviousList folder.id) ]
                    [ img [ src "/assets/folder.svg", class "button-icon" ] []
                    , text folder.name
                    ]
                ]
            ]

    else
        Html.text ""


viewAudiences : Audience.Audience -> Html Msg
viewAudiences audience =
    if audience.folder == Nothing then
        div [ class "folder" ]
            [ li []
                [ button [ class "folder-button" ]
                    [ img [ src "/assets/folder.svg", class "button-icon" ] []
                    , text audience.name
                    ]
                ]
            ]

    else
        Html.text ""


viewAudienceFiles : Audience.Audience -> Html Msg
viewAudienceFiles audience =
    div [ class "audience" ]
        [ li []
            [ button [ class "audience-button" ]
                [ img [ src "/assets/file.svg", class "button-icon" ] []
                , text audience.name
                ]
            ]
        ]


viewButtonGoBack : Model -> Html Msg
viewButtonGoBack model =
    case model.currentFolderId of
        Just _ ->
            div [ class "folder" ]
                [ li []
                    [ button [ class "folder-button", onClick RemoveCurrentFolderIdAndGoBack ]
                        [ img [ src "/assets/back.svg", class "button-icon" ] []
                        , text "Go Back"
                        ]
                    ]
                ]

        Nothing ->
            Html.text ""


decodeAudienceFolders : Decoder (List AudienceFolder.AudienceFolder)
decodeAudienceFolders =
    Decode.at [ "data" ] (Decode.list decodeAudienceFolder)


decodeAudienceFolder : Decoder AudienceFolder.AudienceFolder
decodeAudienceFolder =
    Decode.succeed AudienceFolder.AudienceFolder
        |> required "id" Decode.int
        |> required "name" Decode.string
        |> required "parent" (Decode.maybe Decode.int)


decodeAudiences : Decoder (List Audience.Audience)
decodeAudiences =
    Decode.at [ "data" ] (Decode.list decodeAudience)


decodeAudience : Decoder Audience.Audience
decodeAudience =
    Decode.succeed Audience.Audience
        |> required "id" Decode.int
        |> required "name" Decode.string
        |> required "type" decodeAudienceType
        |> required "folder" (Decode.maybe Decode.int)


decodeAudienceType : Decoder Audience.AudienceType
decodeAudienceType =
    Decode.string
        |> Decode.andThen
            (\str ->
                case str of
                    "user" ->
                        Decode.succeed Audience.Authored

                    "shared" ->
                        Decode.succeed Audience.Shared

                    "curated" ->
                        Decode.succeed Audience.Curated

                    _ ->
                        Decode.fail "Invalid audience type"
            )


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
