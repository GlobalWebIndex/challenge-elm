module View.AudienceBrowser exposing (Model, Msg(..), audienceBrowser, showAudience, showFilesAndFolders, showFolder, update)

import Data.Audience exposing (Audience)
import Data.FileSystem exposing (FileSystem(..), sortWith)
import Data.Focused.FileSystem as FFS exposing (FileSystemFocused)
import Html exposing (Html)
import Html.Attributes exposing (style)
import Html.Styled as H exposing (button, div, text)
import Html.Styled.Attributes as A exposing (autofocus, hidden, id, src, tabindex)
import Html.Styled.Events as E exposing (keyCode, on, onClick)



-- MODEL


type alias Model =
    Result String (FileSystemFocused Audience)



-- MSG


type Msg
    = StepDown Int
    | StepUp



-- UPDATE


update : Msg -> Model -> Model
update msg focusedFileSystemResult =
    case focusedFileSystemResult of
        Err _ ->
            focusedFileSystemResult

        Ok focusedFileSystem ->
            case msg of
                StepDown n ->
                    Result.fromMaybe "ERROR: Only folders can be opened" <|
                        FFS.stepDown n focusedFileSystem

                StepUp ->
                    (Ok << Maybe.withDefault focusedFileSystem) <| FFS.stepUp focusedFileSystem



-- VIEW


audienceBrowser : Model -> Html Msg
audienceBrowser resultFileSystem =
    H.toUnstyled <|
        case resultFileSystem of
            Err errorMsg ->
                text errorMsg

            Ok focusedFS ->
                let
                    foldersAndFilesToShow =
                        Tuple.second focusedFS
                in
                case focusedFS of
                    ( _, Folder name folderContent ) ->
                        div [] <| button [ onClick StepUp ] [ text "Up" ] :: showFilesAndFolders folderContent

                    ( _, File audience ) ->
                        text "ERROR: Cannot get inside of a file"


showAudience : Audience -> H.Html Msg
showAudience audience =
    case audience of
        { id, name, type_ } ->
            div [] [ text name ]


showFolder : Int -> String -> H.Html Msg
showFolder position name =
    div [ onClick <| StepDown position ] [ text <| String.fromInt position ++ " - " ++ name ]


showFilesAndFolders : List (FileSystem Audience) -> List (H.Html Msg)
showFilesAndFolders =
    List.indexedMap
        (\position ->
            \fileOrFolder ->
                case fileOrFolder of
                    File audience ->
                        showAudience audience

                    Folder name _ ->
                        showFolder position name
        )
