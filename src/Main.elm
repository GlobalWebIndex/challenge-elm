module Main exposing (main)

import Browser
import Data.Audience as Audience exposing (Audience)
import Data.AudienceFolder as AudienceFolder exposing (AudienceFolder)
import Error exposing (Error)
import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events as Events
import Level exposing (Level)
import Process
import Styles
import Task
import View.Icon as Icon


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Flags =
    ()


type Model
    = FetchingData
    | DataFetched Level
    | DataError Error


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( FetchingData, fetchData )


{-| The HTTP requests are mocked by using the JSON strings.
They can easily be replaced with the correct HTTP requests.
-}
fetchData : Cmd Msg
fetchData =
    let
        task =
            Task.map2 Tuple.pair
                AudienceFolder.list
                Audience.list
    in
    -- This simulates the HTTP delay
    Process.sleep 500
        |> Task.andThen (\() -> task)
        |> Task.attempt GotDataResponse



-- UPDATE


type Msg
    = GotDataResponse (Result Error ( List AudienceFolder, List Audience ))
    | GoToRootFolder
    | GoToParentFolder Int
    | GoToFolder Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( updateModel msg model, Cmd.none )


updateModel : Msg -> Model -> Model
updateModel msg model =
    -- No catch all (exhaustive) to prevent not handling new messages
    case model of
        FetchingData ->
            case msg of
                GotDataResponse (Ok ( audienceFolders, audiences )) ->
                    DataFetched <| Level.build audienceFolders audiences

                GotDataResponse (Err error) ->
                    DataError error

                GoToRootFolder ->
                    model

                GoToParentFolder _ ->
                    model

                GoToFolder _ ->
                    model

        DataFetched level ->
            case msg of
                GotDataResponse _ ->
                    model

                GoToRootFolder ->
                    DataFetched <| Level.goToRootFolder level

                GoToParentFolder folderId ->
                    DataFetched <| Level.goToParentFolder folderId level

                GoToFolder folderId ->
                    DataFetched <| Level.goToFolder folderId level

        -- No `Msg` to handle for now. We could retry the HTTP request (when implementing HTTP requests)
        DataError _ ->
            model



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    let
        content =
            case model of
                FetchingData ->
                    viewLoading

                DataFetched zipper ->
                    viewData zipper

                DataError error ->
                    viewError error
    in
    Html.div
        [ Attr.class Styles.content ]
        -- CSS Styles (elm-css) are separated because of the `elm/html` requirement
        (Html.map never Styles.styles :: content)


viewLoading : List (Html Msg)
viewLoading =
    [ Html.div [ Attr.class Styles.loader ] [] ]


viewError : Error -> List (Html Msg)
viewError error =
    [ Html.h1 [] [ Html.text (Error.title error) ]
    , Html.p [] [ Html.text (Error.message error) ]
    ]


viewData : Level -> List (Html Msg)
viewData level =
    let
        ( audienceFolders, audiences ) =
            Level.children level

        currentAudienceFolder =
            Level.currentFolder level

        parentAudienceFolders =
            Level.parentFoldersFromRoot level
    in
    [ viewBreadcrumb parentAudienceFolders currentAudienceFolder
    , Html.ul
        [ Attr.class Styles.list ]
        (List.map viewAudienceFolder audienceFolders
            ++ List.map viewAudience audiences
        )
    ]


{-| Could be extracted and generalized in a `View.Breadcrumb` module if other breadcrumbs are created
-}
viewBreadcrumb : List AudienceFolder -> Maybe AudienceFolder -> Html Msg
viewBreadcrumb parentAudienceFolders maybeCurrentAudienceFolder =
    let
        items =
            viewRootFolder (maybeCurrentAudienceFolder == Nothing)
                :: List.map viewParentFolder parentAudienceFolders
                ++ (case maybeCurrentAudienceFolder of
                        Nothing ->
                            []

                        Just currentAudienceFolder ->
                            [ viewCurrentFolder currentAudienceFolder ]
                   )
    in
    items
        |> List.intersperse Icon.arrowRight
        |> Html.div [ Attr.class Styles.breadcrumb ]


viewRootFolder : Bool -> Html Msg
viewRootFolder currentIsRoot =
    let
        attrs =
            if currentIsRoot then
                [ Attr.class Styles.current
                ]

            else
                [ Attr.class Styles.parent
                , Events.onClick GoToRootFolder
                ]
    in
    Html.div attrs [ Html.text "Root" ]


viewParentFolder : AudienceFolder -> Html Msg
viewParentFolder audienceFolder =
    Html.div
        [ Attr.class Styles.parent
        , Events.onClick (GoToParentFolder audienceFolder.id)
        ]
        [ Html.text audienceFolder.name ]


viewCurrentFolder : AudienceFolder -> Html Msg
viewCurrentFolder currentAudienceFolder =
    Html.div
        [ Attr.class Styles.current
        ]
        [ Html.text currentAudienceFolder.name ]


viewAudienceFolder : AudienceFolder -> Html Msg
viewAudienceFolder audienceFolder =
    Html.li
        [ Attr.class Styles.audienceFolder
        , Events.onClick (GoToFolder audienceFolder.id)
        ]
        [ Icon.folder
        , Html.text audienceFolder.name
        ]


viewAudience : Audience -> Html Msg
viewAudience audience =
    Html.li
        [ Attr.class Styles.audience ]
        [ Html.div [] [ Html.text audience.name ]
        ]
