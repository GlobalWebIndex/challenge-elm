module Main exposing (main)

import Html.App
import Html exposing (Html)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


-- Import Modules

import Data.Audience
import Data.AudienceFolder exposing (AudienceFolder)
import Json.Decode as Decode exposing (Decoder, (:=))
import Json.Decode.Extra as Decode exposing ((|:))
import List.Extra exposing (last)


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
    , currentPath : Maybe (List Data.AudienceFolder.AudienceFolder)
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
    in
        ( { audienceFolders = audienceFolder
          , currentPath = Nothing
          }
        , Cmd.none
        )


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



-- MESSAGES


type Msg
    = SelectRootDirectory Data.AudienceFolder.AudienceFolder
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
                ( { model | currentPath = Just [ folder ] }, Cmd.none )

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
        , ul [ id "RootFoldersPanel" ]
            (List.map viewFolders <|
                List.filter rootFoldersFilter model.audienceFolders
            )
        , div [ id "contentPanel" ] [ folderContent model.currentPath ]
        , h1 [] [ text "raw source data" ]
        , pre
            []
            [ text Data.AudienceFolder.audienceFoldersJSON ]
        ]


viewFolders : Data.AudienceFolder.AudienceFolder -> Html Msg
viewFolders folder =
    li []
        [ a [ class "btn ml1 h1", onClick (SelectRootDirectory folder) ]
            [ text folder.name ]
        ]


folderContent : Maybe (List Data.AudienceFolder.AudienceFolder) -> Html Msg
folderContent currentPath =
    case currentPath of
        Just currentPath ->
            case last currentPath of
                Just folder ->
                    text <| "HEN JE OBSAH " ++ (folder.name)

                -- @TODO: unexpected state, because model.currentPath is always Nothing instead empty List
                Nothing ->
                    text "Obsah nenalezen"

        Nothing ->
            text "hen bude obsah"



-- FILTERS


rootFoldersFilter : Data.AudienceFolder.AudienceFolder -> Bool
rootFoldersFilter folder =
    folder.parent == Nothing
