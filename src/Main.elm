module Main exposing (main)

import Browser exposing (Document)
import Css as C
import Data.Audience as Audience exposing (Audience)
import Data.AudienceFolder as AudienceFolder exposing (AudienceFolder)
import FileSystem as FS exposing (FileSystem)
import Html.Attributes as A
import Html.Events as E
import Html.Styled as H exposing (Html)
import Json.Decode as D
import Request exposing (Request(..))


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { audiences : Request (List Audience)
    , audienceFolders : Request (List AudienceFolder)
    , fileSystem : Request (FileSystem AudienceFolder Audience)
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { audiences = Loading
      , audienceFolders = Loading
      , fileSystem = Loading
      }
    , Cmd.batch
        [ Audience.fetch AudienceReceived <|
            D.field "data" <|
                D.list Audience.decoder
        , AudienceFolder.fetch AudienceFoldersReceived <|
            D.field "data" <|
                D.list
                    AudienceFolder.decoder
        ]
    )



-- UPDATE


type Msg
    = AudienceReceived (Result D.Error (List Audience))
    | AudienceFoldersReceived (Result D.Error (List AudienceFolder))
    | FolderClicked Int
    | GoUp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        _ =
            Debug.log "msg" msg
    in
    case msg of
        GoUp ->
            ( { model | fileSystem = Request.map FS.up model.fileSystem }
            , Cmd.none
            )

        FolderClicked i ->
            ( { model | fileSystem = Request.map (FS.cd i) model.fileSystem }
            , Cmd.none
            )

        AudienceFoldersReceived result ->
            ( (case result of
                Ok folder ->
                    { model | audienceFolders = Success folder }

                Err x ->
                    let
                        _ =
                            Debug.log "error" x
                    in
                    { model | audienceFolders = Failure }
              )
                |> (\model_ ->
                        { model_
                            | fileSystem =
                                Request.map2 FS.toFileSystem
                                    model_.audienceFolders
                                    model_.audiences
                        }
                   )
            , Cmd.none
            )

        AudienceReceived result ->
            ( (case result of
                Ok audiences ->
                    { model | audiences = Success audiences }

                Err x ->
                    let
                        _ =
                            Debug.log "error" x
                    in
                    { model | audiences = Failure }
              )
                |> (\model_ ->
                        { model_
                            | fileSystem =
                                Request.map2 FS.toFileSystem
                                    model_.audienceFolders
                                    model_.audiences
                        }
                   )
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Document Msg
view model =
    let
        _ =
            Debug.log "model" model
    in
    { title = ""
    , body =
        [ case model.fileSystem of
            Loading ->
                H.text "loading"

            Success fileSystem ->
                fileSystemHtml fileSystem

            Failure ->
                H.text "something went wrong"
        ]
            |> H.withStyles []
    }


fileSystemHtml : FileSystem AudienceFolder Audience -> Html Msg
fileSystemHtml fileSystem =
    H.div []
        [ H.divS [ C.background "red" ]
            [ E.onClick GoUp ]
            [ H.text <|
                case FS.currentFolder fileSystem of
                    Just folder ->
                        folder.name

                    Nothing ->
                        ""
            ]
        , H.ulS
            [ C.background "lightblue" ]
            []
            (List.indexedMap
                (\i folder ->
                    H.li [ E.onClick <| FolderClicked i ] [ H.text folder.name ]
                )
                (FS.folders fileSystem)
            )
        , H.ulS [ C.background "green" ]
            []
            (List.map
                (\folder ->
                    H.li [] [ H.text folder.name ]
                )
                (FS.files fileSystem)
            )
        ]
