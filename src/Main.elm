module Main exposing (main, view)

import Browser
import Data.Audience exposing (Audience, AudienceType(..), audiencesDecoder, audiencesJSON)
import Data.AudienceFolder exposing (AudienceFolder, audienceFoldersDecoder, audienceFoldersJSON)
import Data.FileSystem exposing (makeFileSystem)
import Data.Focused.FileSystem exposing (FileSystemFocused, focus)
import Html exposing (Html, text)
import Json.Decode as Json exposing (decodeString)
import View.AudienceBrowser as AudienceBrowser exposing (audienceBrowser)



-- MODEL


type alias Model =
    Result String AudienceBrowser.Model



-- INIT


init : flags -> ( Model, Cmd msg )
init =
    \_ ->
        ( case ( audienceFoldersParsed, audiencesParsed ) of
            ( Err errMsg, Ok _ ) ->
                Err errMsg

            ( Ok _, Err errMsg ) ->
                Err errMsg

            ( Err errMsg1, Err errMsg2 ) ->
                Err <| errMsg1 ++ errMsg2

            ( Ok audienceFolders, Ok audiences ) ->
                Ok <|
                    { focusedFileSystem = focus (makeFileSystem audienceFolders audiences)
                    , filter = Authored
                    }
        , Cmd.none
        )


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


type Msg
    = AudienceBrowserMsg AudienceBrowser.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case model of
        Err _ ->
            ( model, Cmd.none )

        Ok browserModel ->
            case msg of
                AudienceBrowserMsg abmsg ->
                    (Tuple.mapSecond (Cmd.map AudienceBrowserMsg) << Tuple.mapFirst Ok) <|
                        AudienceBrowser.update
                            abmsg
                            browserModel



-- VIEW


view : Model -> Html Msg
view model =
    case model of
        Err errMsg ->
            text errMsg

        Ok browserModel ->
            Html.map AudienceBrowserMsg <|
                audienceBrowser browserModel



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
