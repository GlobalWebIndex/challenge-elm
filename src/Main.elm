module Main exposing (main)

import Browser
import Data.Api as Api
import Data.Audience as Audience exposing (Audience, AudienceType)
import Data.AudienceFolder exposing (AudienceFolder)
import Data.Store as Store exposing (AudienceFolderID, AudienceLevel, Store)
import Element exposing (Element, column, el, none, paragraph, row, text)
import Element.Background
import Element.Border
import Element.Events
import Element.Font
import Element.Input exposing (button)
import Html
import Html.Attributes
import Http
import Task



---------------
-- M O D E L --
---------------


type alias InitialisingState =
    { folders : Maybe (List AudienceFolder)
    , audiences : Maybe (List Audience)
    }


type Location
    = Root
    | Folder AudienceFolderID


type alias SucceedState =
    { location : Location
    , filterBy : AudienceType
    }


type Model
    = Initialising InitialisingState
    | Failed Http.Error
    | Succeed Store SucceedState


makeSelector : SucceedState -> Store.Selector
makeSelector state =
    case state.filterBy of
        Audience.Authored ->
            case state.location of
                Root ->
                    Store.OnlyAuthored

                Folder folderID ->
                    Store.OnlyAuthoredIn folderID

        Audience.Shared ->
            Store.OnlyShared

        Audience.Curated ->
            case state.location of
                Root ->
                    Store.OnlyCurated

                Folder folderID ->
                    Store.OnlyCuratedIn folderID


turnInitialising : InitialisingState -> Model
turnInitialising state =
    case Maybe.map2 Store.init state.folders state.audiences of
        Nothing ->
            Initialising state

        Just store ->
            Succeed store (SucceedState Root Audience.Authored)


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



-----------------
-- U P D A T E --
-----------------


type Msg
    = LoadAudienceFoldersDone (Result Http.Error (List AudienceFolder))
    | LoadAudiencesDone (Result Http.Error (List Audience))
    | GoDown AudienceFolderID
    | GoUp
    | SetFilterBy AudienceType


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
            ( Succeed store { state | location = Folder childFolderID }
            , Cmd.none
            )

        ( GoDown _, _ ) ->
            ( model, Cmd.none )

        ( GoUp, Succeed store state ) ->
            ( case state.location of
                Root ->
                    model

                Folder folderID ->
                    let
                        nextLocation =
                            Store.getFolderByID folderID store
                                |> Maybe.andThen .parent
                                |> Maybe.map Folder
                                |> Maybe.withDefault Root
                    in
                    Succeed store { state | location = nextLocation }
            , Cmd.none
            )

        ( GoUp, _ ) ->
            ( model, Cmd.none )

        ( SetFilterBy nextFilter, Succeed store state ) ->
            ( Succeed store
                { state
                    | location = Root
                    , filterBy = nextFilter
                }
            , Cmd.none
            )

        ( SetFilterBy _, _ ) ->
            ( model, Cmd.none )



-------------
-- V I E W --
-------------


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
        { onPress = Just GoUp
        , label = paragraph [] [ text ("↑ " ++ parentFolder.name) ]
        }


viewLevelColumn : List (Element msg) -> Element msg
viewLevelColumn =
    column
        [ Element.width Element.fill
        , Element.height Element.fill
        , Element.scrollbarY
        , Element.spacing 8
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


viewFilterButton : List (Element.Attribute msg) -> Element msg -> Element msg
viewFilterButton attributes label =
    button
        (Element.width Element.fill
            :: Element.paddingXY 6 18
            :: Element.Font.center
            :: attributes
        )
        { onPress = Nothing
        , label = label
        }


viewFilter : AudienceType -> AudienceType -> Element Msg
viewFilter filterBy filter =
    let
        label =
            case filter of
                Audience.Authored ->
                    "Authored"

                Audience.Shared ->
                    "Shared"

                Audience.Curated ->
                    "Curated"
    in
    if filterBy == filter then
        viewFilterButton
            [ Element.Background.color (Element.rgb255 100 100 100)
            , Element.Font.color (Element.rgb255 255 255 255)
            ]
            (text label)

    else
        viewFilterButton
            [ Element.Background.color (Element.rgb255 240 240 240)
            , Element.Font.color (Element.rgb255 100 100 100)
            , Element.Events.onClick (SetFilterBy filter)
            ]
            (text label)


viewFiltersRow : List (Element msg) -> Element msg
viewFiltersRow =
    row
        [ Element.width Element.fill
        , Element.spacing 8
        ]


viewFilters : AudienceType -> Element Msg
viewFilters filterBy =
    viewFiltersRow
        (List.map
            (viewFilter filterBy)
            [ Audience.Authored, Audience.Shared, Audience.Curated ]
        )


viewLayoutColumn : List (Element msg) -> Element msg
viewLayoutColumn =
    column
        [ Element.width Element.fill
        , Element.height Element.fill
        , Element.spacing 16
        ]


viewSucceed : Store -> SucceedState -> Element Msg
viewSucceed store state =
    viewLayoutColumn
        [ case Store.select (makeSelector state) store of
            Store.NotFound folderID ->
                view404 folderID

            Store.Root level ->
                viewLevel none level

            Store.Folder parentFolder level ->
                viewLevel (viewGoUp parentFolder) level
        , viewFilters state.filterBy
        ]


viewInitialising : Element msg
viewInitialising =
    viewLayoutColumn
        [ el
            (Element.Background.color (Element.rgb255 220 220 220)
                :: stylesButton
            )
            (text " ")
            |> List.repeat 10
            |> viewLevelColumn
        , viewFiltersRow
            (List.map
                (\_ ->
                    viewFilterButton
                        [ Element.Background.color (Element.rgb255 220 220 220)
                        ]
                        (text " ")
                )
                (List.range 0 2)
            )
        ]


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
    row
        [ Element.width (Element.maximum 400 Element.fill)
        , Element.height Element.fill
        , Element.padding 8
        , Element.Font.size 14
        ]
        [ case model of
            Initialising _ ->
                viewInitialising

            Failed err ->
                viewFailed err

            Succeed store state ->
                viewSucceed store state
        ]


view : Model -> Browser.Document Msg
view model =
    Browser.Document "Challenge"
        [ Element.layout
            [ Element.height Element.fill
            ]
            (viewLayout model)
        ]



-------------
-- M A I N --
-------------


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
