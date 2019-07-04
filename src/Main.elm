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
import Html.Attributes
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
    | GoUp (Maybe AudienceFolderID)


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

        ( GoUp parentFolderID, Succeed store state ) ->
            ( Succeed store { state | current = parentFolderID }
            , Cmd.none
            )

        ( GoUp _, _ ) ->
            ( model, Cmd.none )


stylesButton : List (Element.Attribute msg)
stylesButton =
    [ Element.width Element.fill
    , Element.padding 20
    ]


viewFolder : AudienceFolder -> Element Msg
viewFolder folder =
    button
        (Element.Background.color (Element.rgb255 26 113 153)
            :: Element.Font.color (Element.rgb255 255 255 255)
            :: stylesButton
        )
        { onPress = Just (GoDown folder.id)
        , label = paragraph [] [ text ("→ " ++ folder.name) ]
        }


viewAudience : Audience -> Element msg
viewAudience audience =
    paragraph
        (Element.Background.color (Element.rgb255 24 151 205)
            :: Element.Font.color (Element.rgb255 255 255 255)
            :: stylesButton
        )
        [ text audience.name ]


viewGoUp : AudienceFolder -> Element Msg
viewGoUp parentFolder =
    button
        (Element.Border.solid
            :: Element.Border.width 2
            :: Element.Border.color (Element.rgb255 26 113 153)
            :: Element.Font.color (Element.rgb255 26 113 153)
            :: stylesButton
        )
        { onPress = Just (GoUp parentFolder.parent)
        , label = paragraph [] [ text ("↑ " ++ parentFolder.name) ]
        }


viewLevelColumn : List (Element msg) -> Element msg
viewLevelColumn =
    column
        [ Element.spacing 8
        , Element.width Element.fill
        ]


viewLevel : Element Msg -> AudienceLevel -> Element Msg
viewLevel toUp level =
    viewLevelColumn
        (toUp :: List.map viewFolder level.folders ++ List.map viewAudience level.audiences)


view404 : AudienceFolderID -> Element msg
view404 folderID =
    paragraph
        []
        [ text ("The folder `" ++ String.fromInt folderID ++ "` doesn't exist")
        ]


viewSucceed : Store -> SucceedState -> Element Msg
viewSucceed store { current } =
    case current of
        Nothing ->
            viewLevel none (Store.getRootLevel store)

        Just folderID ->
            case Store.getFolderLevel folderID store of
                Nothing ->
                    view404 folderID

                Just ( parentFolder, level ) ->
                    viewLevel (viewGoUp parentFolder) level


viewInitialising : Element msg
viewInitialising =
    el
        (Element.Background.color (Element.rgb255 220 220 220)
            :: stylesButton
        )
        (text " ")
        |> List.repeat 10
        |> viewLevelColumn


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
