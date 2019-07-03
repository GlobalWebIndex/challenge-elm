module Main exposing (main)

import Browser
import Data.Api
import Data.Audience exposing (Audience)
import Data.AudienceFolder exposing (AudienceFolder)
import Data.Store exposing (Store)
import Element exposing (Element, el, text)
import Http
import Task


type alias InitialisingState =
    { folders : Maybe (List AudienceFolder)
    , audiences : Maybe (List Audience)
    }


type Model
    = Initialising InitialisingState
    | Failed Http.Error
    | Succeed Store


turnInitialising : InitialisingState -> Model
turnInitialising state =
    case Maybe.map2 Data.Store.init state.folders state.audiences of
        Nothing ->
            Initialising state

        Just store ->
            Succeed store


init : flags -> ( Model, Cmd Msg )
init _ =
    ( Initialising
        { folders = Nothing
        , audiences = Nothing
        }
    , Cmd.batch
        [ Task.attempt LoadAudienceFoldersDone Data.Api.getListOfAudienceFolders
        , Task.attempt LoadAudiencesDone Data.Api.getListOfAudiences
        ]
    )


type Msg
    = LoadAudienceFoldersDone (Result Http.Error (List AudienceFolder))
    | LoadAudiencesDone (Result Http.Error (List Audience))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( LoadAudienceFoldersDone (Err err), _ ) ->
            ( Failed err, Cmd.none )

        ( LoadAudienceFoldersDone (Ok listOfFolders), Initialising state ) ->
            ( turnInitialising { state | folders = Just listOfFolders }
            , Cmd.none
            )

        ( LoadAudienceFoldersDone _, _ ) ->
            ( model, Cmd.none )

        ( LoadAudiencesDone (Err err), _ ) ->
            ( Failed err, Cmd.none )

        ( LoadAudiencesDone (Ok listOfAudiences), Initialising state ) ->
            ( turnInitialising { state | audiences = Just listOfAudiences }
            , Cmd.none
            )

        ( LoadAudiencesDone _, _ ) ->
            ( model, Cmd.none )


viewInitialising : Element msg
viewInitialising =
    text "Initialising..."


viewFailed : Http.Error -> Element msg
viewFailed err =
    case err of
        Http.BadUrl url ->
            el [] (text ("Wrong request url is provided: `" ++ url ++ "`"))

        Http.Timeout ->
            el [] (text "Request is canceled by timeout")

        Http.NetworkError ->
            el [] (text "Poor internet connection")

        Http.BadStatus status ->
            el [] (text ("Request went back with bad status: `" ++ String.fromInt status ++ "`"))

        Http.BadBody message ->
            el [] (text message)


viewSucceed : Store -> Element msg
viewSucceed store =
    text "Succeed"


view : Model -> Browser.Document Msg
view model =
    Browser.Document "Challenge"
        [ case model of
            Initialising _ ->
                Element.layout [] viewInitialising

            Failed err ->
                Element.layout [] (viewFailed err)

            Succeed store ->
                Element.layout [] (viewSucceed store)
        ]


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
