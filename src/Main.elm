module Main exposing (main)

import Browser
import Data.Api as Api
import Data.Audience exposing (Audience)
import Data.AudienceFolder exposing (AudienceFolder)
import Data.Store as Store exposing (AudienceFolderID, AudienceLevel, Store)
import Element exposing (Element, column, el, none, paragraph, text)
import Element.Background
import Element.Border
import Element.Events
import Element.Font
import Element.Input exposing (button)
import Html
import Http
import Task


type alias InitialisingState =
    { folders : Maybe (List AudienceFolder)
    , audiences : Maybe (List Audience)
    }


type alias SucceedState =
    { current : Maybe AudienceFolderID
    }


type Model
    = Initialising InitialisingState
    | Failed Http.Error
    | Succeed Store SucceedState


turnInitialising : InitialisingState -> Model
turnInitialising state =
    case Maybe.map2 Store.init state.folders state.audiences of
        Nothing ->
            Initialising state

        Just store ->
            Succeed store (SucceedState Nothing)


init : flags -> ( Model, Cmd Msg )
init _ =
    ( Initialising
        { folders = Nothing
        , audiences = Nothing
        }
    , Cmd.batch
        [ Task.attempt LoadAudienceFoldersDone Api.getListOfAudienceFolders
        , Task.attempt LoadAudiencesDone Api.getListOfAudiences
        ]
    )


type Msg
    = LoadAudienceFoldersDone (Result Http.Error (List AudienceFolder))
    | LoadAudiencesDone (Result Http.Error (List Audience))
    | GoDown AudienceFolderID
    | GoUp


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

        ( GoDown childFolderID, Succeed store state ) ->
            ( Succeed store { state | current = Just childFolderID }
            , Cmd.none
            )

        ( GoDown _, _ ) ->
            ( model, Cmd.none )

        ( GoUp, Succeed store state ) ->
            case state.current of
                Nothing ->
                    ( model, Cmd.none )

                Just currentFolderID ->
                    ( Succeed store { state | current = Store.getParentFolderID currentFolderID store }
                    , Cmd.none
                    )

        ( GoUp, _ ) ->
            ( model, Cmd.none )


viewInitialising : Element msg
viewInitialising =
    text "Initialising..."


viewFailed : Http.Error -> Element msg
viewFailed err =
    case err of
        Http.BadUrl url ->
            text ("Wrong request url is provided: `" ++ url ++ "`")

        Http.Timeout ->
            text "Request is canceled by timeout"

        Http.NetworkError ->
            text "Poor internet connection"

        Http.BadStatus status ->
            text ("Request went back with bad status: `" ++ String.fromInt status ++ "`")

        Http.BadBody message ->
            text message


stylesButton : List (Element.Attribute msg)
stylesButton =
    [ Element.width Element.fill
    , Element.padding 20
    , Element.Font.color (Element.rgb255 255 255 255)
    ]


viewFolder : AudienceFolder -> Element Msg
viewFolder folder =
    button
        (Element.Background.color (Element.rgb255 26 113 153)
            :: stylesButton
        )
        { onPress = Just (GoDown folder.id)
        , label = paragraph [] [ text folder.name ]
        }


viewAudience : Audience -> Element msg
viewAudience audience =
    paragraph
        (Element.Background.color (Element.rgb255 24 151 205)
            :: stylesButton
        )
        [ text audience.name ]


viewGoUp : Element Msg
viewGoUp =
    button
        (Element.Background.color (Element.rgb255 26 80 130)
            :: stylesButton
        )
        { onPress = Just GoUp
        , label = text "Go Up"
        }


viewLevel : Element Msg -> AudienceLevel -> Element Msg
viewLevel toUp level =
    column
        [ Element.spacing 8
        , Element.width Element.fill
        ]
        (toUp :: List.map viewFolder level.folders ++ List.map viewAudience level.audiences)


viewSucceed : Store -> SucceedState -> Element Msg
viewSucceed store { current } =
    case current of
        Nothing ->
            viewLevel none (Store.getRootLevel store)

        Just folderID ->
            case Store.getLevelByFolderID folderID store of
                Nothing ->
                    text "oops"

                Just level ->
                    viewLevel viewGoUp level


viewLayout : Model -> Element Msg
viewLayout model =
    el
        [ Element.width (Element.maximum 300 Element.fill)
        , Element.padding 8
        , Element.Font.size 14
        ]
        (case model of
            Initialising _ ->
                viewInitialising

            Failed err ->
                viewFailed err

            Succeed store state ->
                viewSucceed store state
        )


view : Model -> Browser.Document Msg
view model =
    Browser.Document "Challenge"
        [ Element.layout [] (viewLayout model)
        ]


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
