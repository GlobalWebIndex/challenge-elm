module Main exposing (..)

import Browser
import Data.Audience as Audience
import Data.AudienceFolder as AudienceFolder
import Html exposing (Html, button, div, footer, img, li, span, text, ul)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Http
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
    , clickedFooterOption : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { audienceFolders = RemoteData.NotAsked
      , audiences = RemoteData.NotAsked
      , currentFolderId = Nothing
      , previousFolderIds = []
      , clickedFooterOption = "Authored"
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
    | SetCategory String


fetchAudienceFolders : Cmd Msg
fetchAudienceFolders =
    Http.get
        { url = urlGetAudienceFolders
        , expect = Http.expectJson GotAudienceFolders AudienceFolder.decodeAudienceFolders
        }


fetchAudiences : Cmd Msg
fetchAudiences =
    Http.get
        { url = urlGetAudiences
        , expect = Http.expectJson GotAudiences Audience.decodeAudiences
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
                updatedPreviousFolderIds =
                    case model.previousFolderIds of
                        _ :: rest ->
                            rest

                        _ ->
                            []

                newCurrentFolderId =
                    List.head updatedPreviousFolderIds
            in
            ( { model
                | currentFolderId = newCurrentFolderId
                , previousFolderIds = updatedPreviousFolderIds
              }
            , Cmd.none
            )

        SetCategory newPage ->
            ( { model
                | clickedFooterOption = newPage
                , previousFolderIds = []
                , currentFolderId = Nothing
              }
              -- Reset info to go to root level
            , Cmd.none
            )


view : Model -> Browser.Document Msg
view model =
    { title = "GWI Elm Challenge"
    , body =
        [ viewBody model ]
    }


viewBody : Model -> Html Msg
viewBody model =
    div []
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
                                viewFolders audienceFolders audiences model.currentFolderId model.clickedFooterOption

                            else
                                let
                                    audiencesContent =
                                        List.filter (\item -> item.folder == model.currentFolderId) audiences

                                    audiencesFoldersContent =
                                        List.filter (\item -> item.parent == model.currentFolderId) audienceFolders
                                in
                                viewFolders audiencesFoldersContent audiencesContent model.currentFolderId model.clickedFooterOption

                        RemoteData.Failure _ ->
                            text "Something went wrong"

                RemoteData.Failure _ ->
                    text "Something went wrong"
            ]
        , viewFooter model.clickedFooterOption
        ]


viewFooter : String -> Html Msg
viewFooter footerOptionSelected =
    footer []
        [ viewFooterOptions footerOptionSelected ]


viewFooterOptions : String -> Html Msg
viewFooterOptions footerOptionSelected =
    div [ class "footer-container" ]
        [ viewSingleFooterOption "/assets/authored.svg" "Authored" footerOptionSelected
        , viewSingleFooterOption "/assets/shared.svg" "Shared" footerOptionSelected
        , viewSingleFooterOption "/assets/curated.svg" "Curated" footerOptionSelected
        ]


viewSingleFooterOption : String -> String -> String -> Html Msg
viewSingleFooterOption imageSrc optionName footerOptionSelected =
    div [ class "footer-option" ]
        [ img
            [ src imageSrc
            , class "footer-option-icon"
            , onClick (SetCategory optionName)
            , class
                (if footerOptionSelected == optionName then
                    "clicked"

                 else
                    ""
                )
            ]
            []
        , span [] [ text optionName ]
        ]


viewFolders : List AudienceFolder.AudienceFolder -> List Audience.Audience -> Maybe Int -> String -> Html Msg
viewFolders audienceFolders audiences currentFolderId footerClickedOption =
    let
        audiencesAvailable =
            if currentFolderId == Nothing then
                {- Root files -}
                List.filter (\item -> item.folder == Nothing && (ListE.count ((==) item.id) <| List.map .id audiences) == 1) audiences

            else
                {- Children files -}
                List.filter (\item -> item.folder == currentFolderId && (ListE.count ((==) item.id) <| List.map .id audiences) == 1) audiences
    in
    div []
        [ ul [] [ viewButtonGoBack currentFolderId ]
        , ul []
            (if footerClickedOption == "Shared" then
                []

             else
                List.map (\folder -> viewAudienceFolders folder currentFolderId) audienceFolders
            )
        , ul []
            (audiencesAvailable
                |> List.filter
                    (\audience ->
                        case footerClickedOption of
                            "Authored" ->
                                audience.type_ == Audience.Authored

                            "Shared" ->
                                audience.type_ == Audience.Shared

                            "Curated" ->
                                audience.type_ == Audience.Curated

                            _ ->
                                False
                    )
                |> List.map viewAudiences
            )
        ]


viewAudienceFolders : AudienceFolder.AudienceFolder -> Maybe Int -> Html Msg
viewAudienceFolders folder currentFolderId =
    let
        {-
           Why of this validation? Because with this logic, there are to options available:
               - Audiences in the root directory, witch are gonna be the first ones to be displayed
               - Audiences that are children of the current folder. This is gonna be displayed when
                 the user clicks on a folder
        -}
        validFolder =
            folder.parent == Nothing || folder.parent == currentFolderId
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
    div [ class "audience" ]
        [ li []
            [ button [ class "audience-button" ]
                [ img [ src "/assets/file.svg", class "button-icon" ] []
                , text audience.name
                ]
            ]
        ]


viewButtonGoBack : Maybe Int -> Html Msg
viewButtonGoBack currentFolderId =
    case currentFolderId of
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


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
