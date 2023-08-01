module Main exposing (main)

import Browser
import Data.Audience as Audience
import Data.AudienceFolder as AudienceFolder
import Html exposing (Html, button, div, li, text, ul)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http exposing (Error(..))
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)


type Msg
    = MsgGotResultsAudienceFolder (Result Http.Error (List AudienceFolder.AudienceFolder))
    | MsgGotResultsAudience (Result Http.Error (List Audience.Audience))
    | OpenFolder Int
    | GoBack


type alias Model =
    { audienceFolder : List AudienceFolder.AudienceFolder
    , audience : List Audience.Audience
    , urlAudienceFolder : String
    , urlAudience : String
    , errorMessage : Maybe String
    , currentFolderId : Maybe Int
    }


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



--VIEW


view : Model -> Html Msg
view model =
    div []
        (List.concat [ goBackView model, viewContent model ])



--VIEW OF THE GO BACK BUTTON


goBackView : Model -> List (Html Msg)
goBackView model =
    if model.currentFolderId /= Nothing then
        [ div
            [ class "audience-button", onClick GoBack ]
            [ text "Go Back" ]
        ]

    else
        []



--VIEW OF THE CONTENT


viewContent : Model -> List (Html Msg)
viewContent model =
    case model.currentFolderId of
        Just currentID ->
            let
                _ =
                    Debug.log "Current ID: " currentID

                listOfFolderSon =
                    model.audienceFolder
                        |> List.filter
                            (\folder ->
                                case folder.parent of
                                    Just parentId ->
                                        parentId == currentID

                                    Nothing ->
                                        False
                            )
                        |> List.map viewFolder

                folderSonView =
                    if List.isEmpty listOfFolderSon then
                        []
                    else
                        [ div []
                            [ ul [] listOfFolderSon
                            ]
                        ]
            in
            [ div []
                (List.append folderSonView
                    [ ul []
                        (model.audience
                            |> List.filter (\audience -> audience.folder == Just currentID)
                            |> List.map viewAudience
                        )
                    ]
                )
            ]
        --if the currentID is Nothing it will show us the first page
        Nothing ->
            [ div []
                [ ul []
                    (model.audienceFolder
                        --only show if parent == Nothing
                        |> List.filter (\folder -> folder.parent == Nothing)
                        |> List.map viewFolder
                    )
                ]
            ]



--VIEW OF THE COMPONENTS


viewFolder : AudienceFolder.AudienceFolder -> Html Msg
viewFolder audienceFolder =
    button
        [ class "audience-button"
        , onClick (OpenFolder audienceFolder.id)
        ]
        [ text audienceFolder.name ]


viewAudience : Audience.Audience -> Html Msg
viewAudience audience =
    button
        [ class "audience-button"
        ]
        [ text audience.name ]



--UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MsgGotResultsAudienceFolder result ->
            case result of
                Ok data ->
                    let
                        newModel =
                            { model | audienceFolder = data, errorMessage = Nothing }
                    in
                    ( newModel, Cmd.none )

                Err error ->
                    let
                        errorMessage =
                            case error of
                                NetworkError ->
                                    "Network Error"

                                BadUrl _ ->
                                    "Bad URL"

                                Timeout ->
                                    "Timeout"

                                BadStatus _ ->
                                    "Bad status"

                                BadBody reason ->
                                    let
                                        _ =
                                            Debug.log "Error Audience Folder: " reason
                                    in
                                    reason
                    in
                    ( { model | errorMessage = Just errorMessage }, Cmd.none )

        MsgGotResultsAudience result ->
            case result of
                Ok data ->
                    let
                        newModel =
                            { model | audience = data, errorMessage = Nothing }
                    in
                    --update MsgFilterPermition newModel
                    ( newModel, Cmd.none )

                Err error ->
                    let
                        errorMessage =
                            case error of
                                NetworkError ->
                                    "Network Error"

                                BadUrl _ ->
                                    "Bad URL"

                                Timeout ->
                                    "Timeout"

                                BadStatus _ ->
                                    "Bad status"

                                BadBody reason ->
                                    let
                                        _ =
                                            Debug.log "Error Audience: " reason
                                    in
                                    reason
                    in
                    ( { model | errorMessage = Just errorMessage }, Cmd.none )

        OpenFolder folderId ->
            let
                _ =
                    Debug.log "Folder ID: " folderId
            in
            ( { model | currentFolderId = Just folderId }, Cmd.none )

        GoBack ->
            case model.currentFolderId of
                Just folderId ->
                    let
                        newId =
                            getActualParent folderId model

                        _ =
                            Debug.log "Older ID: " newId
                    in
                    ( {model | currentFolderId=newId}, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )



--Get the parent of the folder, if there is no parent he put the currentFolderId to Nothing so he come back
--to the inicial screen
--TODO REVIEW 
getActualParent : Int -> Model -> Maybe Int
getActualParent folderId model =
    let
        actualFolder = getFolderById folderId model
    in
    case actualFolder of
        Just folder ->
            case folder.parent of
                Just parentId ->
                    let
                        folderData = { id = Just folder.id, name = folder.name, parent = folder.parent }
                        parentFolders = List.filter (\f -> f.id == Just parentId) (List.map toFolderData model.audienceFolder)
                    in
                    case parentFolders of
                        [] -> Just folder.id
                        parentFolder::_ -> parentFolder.id
                Nothing ->
                    Nothing
        Nothing ->
            Nothing

toFolderData : AudienceFolder.AudienceFolder -> { id : Maybe Int, name : String, parent : Maybe Int }
toFolderData folder =
    { id = Just folder.id, name = folder.name, parent = folder.parent }


getFolderById : Int -> Model -> Maybe AudienceFolder.AudienceFolder
getFolderById targetId model =
    List.filter (\folder -> folder.id == targetId) model.audienceFolder |> List.head



getParentFolderId : Int -> Model -> Model
getParentFolderId folderId model =
    case List.filter (\folder -> folder.parent == Just folderId) model.audienceFolder of
        [] ->
            { model | currentFolderId = Nothing }

        parentFolders ->
            let
                parentId =
                    List.head parentFolders |> Maybe.map .id
            in
            { model | currentFolderId = parentId }



--SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



--INIT


init : () -> ( Model, Cmd Msg )
init _ =
    ( initModel, Cmd.batch [ cmdSearchFolder initModel, cmdSearchAudience initModel ] )


initModel : Model
initModel =
    { audienceFolder = []
    , audience = []
    , urlAudienceFolder = "http://localhost:8000/server/Json/AudienceFolder.Json"
    , urlAudience = "http://localhost:8000/server/Json/Audience.Json"
    , errorMessage = Nothing
    , currentFolderId = Nothing
    }



--CMD


cmdSearchFolder : Model -> Cmd Msg
cmdSearchFolder model =
    Http.get
        { url = model.urlAudienceFolder
        , expect = Http.expectJson MsgGotResultsAudienceFolder (Decode.list audienceFolderJsonDecoder)
        }


cmdSearchAudience : Model -> Cmd Msg
cmdSearchAudience model =
    Http.get
        { url = model.urlAudience
        , expect = Http.expectJson MsgGotResultsAudience (Decode.list audienceJsonDecoder)
        }



--DECODERS


audienceFolderJsonDecoder : Decoder AudienceFolder.AudienceFolder
audienceFolderJsonDecoder =
    Decode.succeed AudienceFolder.AudienceFolder
        |> required "id" Decode.int
        |> required "name" Decode.string
        |> required "parent" (Decode.maybe Decode.int)


audienceTypeDecoder : Decoder Audience.AudienceType
audienceTypeDecoder =
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


audienceJsonDecoder : Decoder Audience.Audience
audienceJsonDecoder =
    Decode.succeed Audience.Audience
        |> required "id" Decode.int
        |> required "name" Decode.string
        |> required "type" audienceTypeDecoder
        |> required "folder" (Decode.maybe Decode.int)
