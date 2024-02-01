module Main exposing (..)

import Browser
import Data.Audience as Audience
import Data.AudienceFolder as AudienceFolder
import Html exposing (Html, button, div, img, li, text, ul)
import Html.Attributes exposing (class, src)
import Http exposing (..)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)
import List.Extra as ListE
import RemoteData


type alias Model =
    { audienceFolders : RemoteData.WebData (List AudienceFolder.AudienceFolder)
    , audiences : RemoteData.WebData (List Audience.Audience)
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { audienceFolders = RemoteData.NotAsked
      , audiences = RemoteData.NotAsked
      }
    , Cmd.batch [ fetchAudienceFolders, fetchAudiences ]
    )


type Msg
    = FetchAudienceFolders
    | GotAudienceFolders (Result Http.Error (List AudienceFolder.AudienceFolder))
    | FetchAudiences
    | GotAudiences (Result Http.Error (List Audience.Audience))


fetchAudienceFolders : Cmd Msg
fetchAudienceFolders =
    Http.get
        { url = "http://localhost:8000/jsons/audienceFolder.json"
        , expect = Http.expectJson GotAudienceFolders decodeAudienceFolders
        }


fetchAudiences : Cmd Msg
fetchAudiences =
    Http.get
        { url = "http://localhost:8000/jsons/audience.json"
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
            , fetchAudiences
            )

        GotAudiences (Ok audiences) ->
            ( { model | audiences = RemoteData.Success audiences }
            , Cmd.none
            )

        GotAudiences (Err err) ->
            ( { model | audiences = RemoteData.Failure err }, Cmd.none )


findFilesAtCurrentLevel : List Audience.Audience -> List Audience.Audience
findFilesAtCurrentLevel items =
    let
        uniqueItems =
            List.filter (\item -> item.folder == Nothing && (ListE.count ((==) item.id) <| List.map .id items) == 1) items
    in
    uniqueItems


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
                    -- viewFolders audiences
                    case model.audiences of
                        RemoteData.NotAsked ->
                            text "Not Asked"

                        RemoteData.Loading ->
                            text "Loading"

                        RemoteData.Success audiences ->
                            viewFolders audienceFolders audiences

                        RemoteData.Failure _ ->
                            text "Failure"

                RemoteData.Failure _ ->
                    text "Failure"
            ]
        ]
    }


viewFolders : List AudienceFolder.AudienceFolder -> List Audience.Audience -> Html Msg
viewFolders audienceFolders audiences =
    let
        {-
           Maybe a litle big complex, the idea of this function is to filter the items that are not
           in the list. Why? Because the items that has not folders and are not repeated int the list are the files
        -}
        uniqueItems =
            List.filter (\item -> item.folder == Nothing && (ListE.count ((==) item.id) <| List.map .id audiences) == 1) audiences

        filteredIds =
            List.map .id uniqueItems

        {-
           Same idea, but reversed. If the ids filtered above are not in the list, then they are folders
        -}
        itemsNotInList =
            List.filter (\item -> not (List.member item.id filteredIds)) audiences

        _ =
            Debug.log "" itemsNotInList
    in
    div []
        [ ul [] (List.map viewAudienceFolders audienceFolders)
        , ul [] (List.map viewAudiences itemsNotInList)
        , ul [] (List.map viewAudienceFiles uniqueItems)
        ]


viewAudienceFolders : AudienceFolder.AudienceFolder -> Html Msg
viewAudienceFolders folder =
    if folder.parent == Nothing then
        div [ class "folder" ]
            [ li []
                [ button [ class "folder-button" ]
                    [ img [ src "/assets/folder.svg", class "button-icon" ] []
                    , text folder.name
                    ]
                ]
            ]

    else
        div [] []


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
        div [] []


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



--else
-- div [] []


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
