module Main exposing (main)

import Browser
import Data.Audience as Audience
import Data.AudienceFolder as AudienceFolder
import Decoder
import Html exposing (Html, button, div, text, ul)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http exposing (Error(..))


type Msg
    = MsgGotResultsAudienceFolder (Result Http.Error (List AudienceFolder.AudienceFolder))
    | MsgGotResultsAudience (Result Http.Error (List Audience.Audience))
    | OpenFolder Int
    | GoBack
    | SelectCategory Audience.AudienceType


type alias Model =
    { audienceFolder : List AudienceFolder.AudienceFolder
    , audience : List Audience.Audience
    , urlAudienceFolder : String
    , urlAudience : String
    , errorMessage : Maybe String
    , currentFolderId : Maybe Int
    , selectedCategory : Audience.AudienceType
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
    div [ class "table" ]
        (List.concat
            [ categoryButtonsView
            , goBackView model
            , viewContent model
            ]
        )



--VIEW OF THE GO BACK BUTTON


goBackView : Model -> List (Html Msg)
goBackView model =
    if model.currentFolderId /= Nothing then
        [ div
            [ class "goBack-button", onClick GoBack ]
            [ text "Go Up" ]
        ]

    else
        []



--VIEW OF THE CONTENT


viewContent : Model -> List (Html Msg)
viewContent model =
    case model.currentFolderId of
        Just currentID ->
            [ div []
                (List.append
                    (folderSonView model currentID)
                    (audienceView model currentID)
                )
            ]

        --if the currentID is Nothing it will show us the first page
        --but if the category is Shared It will show just the Shared Audience
        Nothing ->
            case model.selectedCategory of
                Audience.Shared ->
                    [ div []
                        (viewSharedAudience model)
                    ]

                _ ->
                    [ div []
                        (List.append
                            (folderView model)
                            (viewAudienceWithoutFolder model)
                        )
                    ]



--VIEW OF THE PARTS


viewFilteredAudience : (Audience.Audience -> Bool) -> List Audience.Audience -> List (Html Msg)
viewFilteredAudience filterFn audienceList =
    [ ul [ class "audience-container" ]
        (List.filter filterFn audienceList
            |> List.map viewComponentAudience
        )
    ]


viewSharedAudience : Model -> List (Html Msg)
viewSharedAudience model =
    viewFilteredAudience (\audience -> audience.type_ == Audience.Shared) model.audience


viewAudienceWithoutFolder : Model -> List (Html Msg)
viewAudienceWithoutFolder model =
    case model.selectedCategory of
        Audience.Curated ->
            viewFilteredAudience (\audience -> audience.folder == Nothing && audience.type_ == Audience.Curated) model.audience

        _ ->
            viewFilteredAudience (\audience -> audience.folder == Nothing && audience.type_ == Audience.Authored) model.audience


viewAudienceByCategory : Audience.AudienceType -> Model -> Int -> List (Html Msg)
viewAudienceByCategory category model currentID =
    let
        filterFn audience =
            case category of
                Audience.Curated ->
                    audience.folder == Just currentID && audience.type_ == Audience.Curated

                _ ->
                    audience.folder == Just currentID && audience.type_ == Audience.Authored
    in
    viewFilteredAudience filterFn model.audience


audienceView : Model -> Int -> List (Html Msg)
audienceView model currentID =
    viewAudienceByCategory model.selectedCategory model currentID


folderView : Model -> List (Html Msg)
folderView model =
    [ ul []
        (model.audienceFolder
            --only show if parent == Nothing
            |> List.filter (\folder -> folder.parent == Nothing)
            |> List.map viewComponentFolder
        )
    ]


folderSonView : Model -> Int -> List (Html Msg)
folderSonView model currentID =
    let
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
                |> List.map viewComponentFolder
    in
    if List.isEmpty listOfFolderSon then
        []

    else
        [ div []
            [ ul [] listOfFolderSon
            ]
        ]



--VIEW OF THE COMPONENTS


categoryButtonsView : List (Html Msg)
categoryButtonsView =
    [ div []
        [ button [ class "category-button", onClick (SelectCategory Audience.Authored) ] [ text "Authored" ]
        , button [ class "category-button", onClick (SelectCategory Audience.Shared) ] [ text "Shared" ]
        , button [ class "category-button", onClick (SelectCategory Audience.Curated) ] [ text "Curated" ]
        ]
    ]


viewComponentFolder : AudienceFolder.AudienceFolder -> Html Msg
viewComponentFolder audienceFolder =
    button
        [ class "folder-button"
        , onClick (OpenFolder audienceFolder.id)
        ]
        [ text audienceFolder.name ]


viewComponentAudience : Audience.Audience -> Html Msg
viewComponentAudience audience =
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
                    ( { model | errorMessage = Just (errorMessage error) }, Cmd.none )

        MsgGotResultsAudience result ->
            case result of
                Ok data ->
                    let
                        newModel =
                            { model | audience = data, errorMessage = Nothing }
                    in
                    ( newModel, Cmd.none )

                Err error ->
                    ( { model | errorMessage = Just (errorMessage error) }, Cmd.none )

        OpenFolder folderId ->
            ( { model | currentFolderId = Just folderId }, Cmd.none )

        GoBack ->
            case model.currentFolderId of
                Just folderId ->
                    let
                        newId =
                            getActualParent folderId model
                    in
                    ( { model | currentFolderId = newId }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        SelectCategory category ->
            ( { model | selectedCategory = category, currentFolderId = Nothing }, Cmd.none )


errorMessage : Http.Error -> String
errorMessage error =
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
            reason



--Get the parent of the folder, if there is no parent he put the currentFolderId to Nothing so he come back
--to the inicial screen


getActualParent : Int -> Model -> Maybe Int
getActualParent folderId model =
    case getFolderById folderId model of
        Just folder ->
            case folder.parent of
                Just parentId ->
                    Just parentId

                Nothing ->
                    Nothing

        Nothing ->
            Nothing


getFolderById : Int -> Model -> Maybe AudienceFolder.AudienceFolder
getFolderById targetId model =
    List.filter (\folder -> folder.id == targetId) model.audienceFolder |> List.head



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
    , selectedCategory = Audience.Authored
    }



--CMD


cmdSearchFolder : Model -> Cmd Msg
cmdSearchFolder model =
    Http.get
        { url = model.urlAudienceFolder
        , expect = Http.expectJson MsgGotResultsAudienceFolder Decoder.decodeAudienceFolders
        }


cmdSearchAudience : Model -> Cmd Msg
cmdSearchAudience model =
    Http.get
        { url = model.urlAudience
        , expect = Http.expectJson MsgGotResultsAudience Decoder.decodeAudiences
        }
