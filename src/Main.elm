module Main exposing (main)

import Html.App
import Html exposing (Html)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


-- Import Modules

import Data.Audience exposing (Audience, AudienceType(..))
import Data.AudienceFolder exposing (AudienceFolder)
import Json.Decode as Decode exposing (Decoder, (:=))
import Json.Decode.Extra as Decode exposing ((|:))


{-| Main file of application
-}
main : Program Never
main =
    -- Html.text "There will be app soon!"
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { audienceFolders : List Data.AudienceFolder.AudienceFolder
    , audiencies : List Data.Audience.Audience
    , currentPath : Maybe (List Data.AudienceFolder.AudienceFolder)
    , currentFolder : Maybe (Data.AudienceFolder.AudienceFolder)
    }


init : ( Model, Cmd Msg )
init =
    let
        audienceFolder =
            case Debug.log "audiencefolder" (audienceFoldersDecoder Data.AudienceFolder.audienceFoldersJSON) of
                Ok data ->
                    data

                -- @TODO: error reporting
                Err err ->
                    []

        audiencies =
            case Debug.log "audiencies" (audienciesDecoder Data.Audience.audiencesJSON) of
                Ok data ->
                    data

                -- @TODO: error reporting
                Err err ->
                    []
    in
        ( { audienceFolders = audienceFolder
          , audiencies = audiencies
          , currentPath = Nothing
          , currentFolder = Nothing
          }
        , Cmd.none
        )



-- DECODERS


audienceFoldersDecoder : String -> Result String (List AudienceFolder)
audienceFoldersDecoder json =
    json
        |> Decode.decodeString (Decode.at [ "data" ] <| Decode.list audienceFolderDecodeItem)


audienceFolderDecodeItem : Decoder AudienceFolder
audienceFolderDecodeItem =
    Decode.succeed AudienceFolder
        |: ("id" := Decode.int)
        |: ("name" := Decode.string)
        |: ("parent" := Decode.maybe Decode.int)


audienciesDecoder : String -> Result String (List Audience)
audienciesDecoder json =
    json
        |> Decode.decodeString (Decode.at [ "data" ] <| Decode.list audienciesDecoderItem)


audienciesDecoderItem : Decoder Audience
audienciesDecoderItem =
    Decode.succeed Audience
        |: ("id" := Decode.int)
        |: ("name" := Decode.string)
        |: ("type"
                := Decode.string
                `Decode.andThen` audienceTypeDecoder
           )
        |: ("folder" := Decode.maybe Decode.int)


audienceTypeDecoder : String -> Decoder AudienceType
audienceTypeDecoder audienceType =
    case audienceType of
        "authored" ->
            Decode.succeed Authored

        "shared" ->
            Decode.succeed Shared

        "curated" ->
            Decode.succeed Curated

        _ ->
            Decode.fail (audienceType ++ " is not a recognized audienceType for Audience")



-- MESSAGES


type Msg
    = SelectRootDirectory Data.AudienceFolder.AudienceFolder
    | SelectBreadcrumbItem Data.AudienceFolder.AudienceFolder
    | NoOp



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        _ =
            Debug.log "UPDATE msg: " msg

        _ =
            Debug.log "UPDATE model: " model
    in
        case msg of
            SelectRootDirectory folder ->
                ( { model
                    | currentPath = Just [ folder ]
                    , currentFolder = Just folder
                  }
                , Cmd.none
                )

            SelectBreadcrumbItem folder ->
                ( { model | currentFolder = Just folder }, Cmd.none )

            NoOp ->
                ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "folders" ]
          -- , ul [] (List.map viewFolders model.audienceFolders)
        , ul [ id "rootFoldersPanel" ]
            (List.map viewRootFolderNavigationItem <|
                List.filter rootFoldersFilter model.audienceFolders
            )
        , ol [ id "breadcrumbPanel" ] [ viewBreadcrumb model.currentPath ]
        , div [ id "contentPanel" ] [ viewFolderContent model.currentFolder ]
        , h1 [] [ text "raw source data" ]
        , pre
            []
            [ text Data.AudienceFolder.audienceFoldersJSON ]
        ]


viewRootFolderNavigationItem : Data.AudienceFolder.AudienceFolder -> Html Msg
viewRootFolderNavigationItem folder =
    li []
        [ a [ class "btn ml1 h1", onClick (SelectRootDirectory folder) ]
            [ text folder.name ]
        ]


viewBreadcrumbItem : Data.AudienceFolder.AudienceFolder -> Html Msg
viewBreadcrumbItem folder =
    li []
        [ a [ class "btn ml1 h1", onClick (SelectBreadcrumbItem folder) ]
            [ text folder.name ]
        ]


viewFolderContent : Maybe (Data.AudienceFolder.AudienceFolder) -> Html Msg
viewFolderContent currentFolder =
    case currentFolder of
        Just currentFolder ->
            text <| "HEN JE OBSAH " ++ (currentFolder.name)

        Nothing ->
            text "hen bude obsah"


viewBreadcrumb : Maybe (List Data.AudienceFolder.AudienceFolder) -> Html Msg
viewBreadcrumb currentPath =
    case currentPath of
        Just currentPath ->
            ol [] <|
                List.map
                    viewBreadcrumbItem
                    currentPath

        Nothing ->
            text "bez navigace"



-- FILTERS


rootFoldersFilter : Data.AudienceFolder.AudienceFolder -> Bool
rootFoldersFilter folder =
    folder.parent == Nothing
