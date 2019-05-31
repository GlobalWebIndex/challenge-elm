module Main exposing (Model, Msg(..), audienceFoldersParsed, audiencesParsed, init, main, update, view)

{--import Html.Attributes exposing (style) --}
{--import Html.Styled as H exposing (button, div, text) --}
{--import Html.Styled.Attributes as A exposing (autofocus, hidden, id, src, tabindex) --}
{--import Html.Styled.Events as E exposing (keyCode, on, onClick) --}

import Browser
import Css as C exposing (border3, px, rgb, solid)
import Data.Audience exposing (Audience, audiencesDecoder, audiencesJSON)
import Data.AudienceFolder exposing (AudienceFolder, audienceFoldersDecoder, audienceFoldersJSON)
import Data.FileSystem exposing (mkFileSystem)
import Data.Focused.FileSystem exposing (FileSystemFocused, focus)
import Html exposing (Html)
import Json.Decode as Json exposing (decodeString)
import View.AudienceBrowser as AudienceBrowser exposing (Msg(..), audienceBrowser)


type alias Model =
    { audienceBrowserModel : AudienceBrowser.Model }


type Msg
    = NoOp
    | AudienceBrowserMsg AudienceBrowser.Msg


type OtherMsg
    = Up
    | Down



-- INIT


init : Model
init =
    { audienceBrowserModel =
        case ( audienceFoldersParsed, audiencesParsed ) of
            ( Err errMsg, Ok _ ) ->
                Err errMsg

            ( Ok _, Err errMsg ) ->
                Err errMsg

            ( Err errMsg1, Err errMsg2 ) ->
                Err <| errMsg1 ++ errMsg2

            ( Ok audienceFolders, Ok audiences ) ->
                Ok <| focus (mkFileSystem audienceFolders audiences)
    }


audienceFoldersParsed : Result String (List AudienceFolder)
audienceFoldersParsed =
    Result.mapError
        (\decoderError -> "ERROR when parsing audienceFoldersJSON: " ++ Json.errorToString decoderError)
        (decodeString audienceFoldersDecoder audienceFoldersJSON)


audiencesParsed : Result String (List Audience)
audiencesParsed =
    Result.mapError
        (\decoderError -> "ERROR when parsing audiencesJSON: " ++ Json.errorToString decoderError)
        (decodeString audiencesDecoder audiencesJSON)



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        AudienceBrowserMsg abmsg ->
            { model
                | audienceBrowserModel =
                    AudienceBrowser.update
                        abmsg
                        model.audienceBrowserModel
            }



-- VIEW


view : Model -> Html Msg
view model =
    Html.map AudienceBrowserMsg <|
        audienceBrowser model.audienceBrowserModel



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
