module Main exposing (main)

import Browser
import Data.Audience exposing (Audience, AudienceType(..))
import Data.AudienceFolder exposing (AudienceFolder)
import Data.Mocked exposing (DirElem(..), Directory, parsedDirectory)
import Html exposing (Html, div, text)
import Html.Attributes exposing (classList)
import Html.Events exposing (onClick)
import List exposing (drop, head, length)
import Maybe.Extra exposing (join)
import Result exposing (Result(..))


type alias Model =
    { directory : Directory
    , parents : List (Maybe Int)
    }


type Msg
    = OpenFolder AudienceFolder
    | GoUp


parentIs : Maybe Int -> DirElem -> Bool
parentIs id de =
    case de of
        File audience ->
            audience.folder == id

        Folder audienceFolder ->
            audienceFolder.parent == id


init : Model
init =
    { directory = List.filter (parentIs Nothing) parsedDirectory
    , parents = []
    }


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


update : Msg -> Model -> Model
update msg model =
    case msg of
        OpenFolder folder ->
            let
                filteredDir =
                    List.filter (parentIs <| Just folder.id) parsedDirectory
            in
            { directory = filteredDir, parents = folder.parent :: model.parents }

        GoUp ->
            let
                filteredDir =
                    List.filter (parentIs <| join <| head model.parents) parsedDirectory
            in
            { directory = filteredDir, parents = drop 1 model.parents }


audienceView : Audience -> Html Msg
audienceView a =
    div [ classList [ ( "dir-elem", True ), ( "file", True ) ] ] [ text a.name ]


audienceFolderView : AudienceFolder -> Html Msg
audienceFolderView af =
    div [ onClick <| OpenFolder af, classList [ ( "dir-elem", True ), ( "folder", True ) ] ] [ text <| "🗀 Folder: " ++ af.name ]


dirElemView : DirElem -> Html Msg
dirElemView de =
    case de of
        File a ->
            audienceView a

        Folder af ->
            audienceFolderView af


goUpView : Model -> List (Html Msg)
goUpView model =
    if length model.parents > 0 then
        [ div [ onClick GoUp, classList [ ( "dir-elem", True ), ( "folder", True ) ] ] [ text ".." ] ]

    else
        []


view : Model -> Html Msg
view model =
    div [] (goUpView model ++ List.map dirElemView model.directory)
