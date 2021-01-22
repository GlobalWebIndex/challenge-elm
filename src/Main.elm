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
    | DataFetched DataParams
    | DataError Error


type alias DataParams =
    { filter : Audience.AudienceType
    , authored : Level
    , shared : List Audience
    , curated : Level
    }


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
    | SetFilter Audience.AudienceType
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
                    DataFetched <| buildDataParams audienceFolders audiences

                GotDataResponse (Err error) ->
                    DataError error

                SetFilter _ ->
                    model

                GoToRootFolder ->
                    model

                GoToParentFolder _ ->
                    model

                GoToFolder _ ->
                    model

        DataFetched dataParams ->
            case msg of
                GotDataResponse _ ->
                    model

                SetFilter filter ->
                    DataFetched <| setFilter filter dataParams

                GoToRootFolder ->
                    DataFetched <| updateLevel Level.goToRootFolder dataParams

                GoToParentFolder folderId ->
                    DataFetched <| updateLevel (Level.goToParentFolder folderId) dataParams

                GoToFolder folderId ->
                    DataFetched <| updateLevel (Level.goToFolder folderId) dataParams

        -- No `Msg` to handle for now. We could retry the HTTP request (when implementing HTTP requests)
        DataError _ ->
            model


buildDataParams : List AudienceFolder -> List Audience -> DataParams
buildDataParams audienceFolders audiences =
    let
        -- Split audiences in one pass for better efficiency
        { authored, shared, curated } =
            audiences
                |> List.foldl
                    (\audience acc ->
                        case audience.type_ of
                            Audience.Authored ->
                                { acc | authored = audience :: acc.authored }

                            Audience.Shared ->
                                { acc | shared = audience :: acc.shared }

                            Audience.Curated ->
                                { acc | curated = audience :: acc.curated }
                    )
                    { authored = [], shared = [], curated = [] }
    in
    { filter = Audience.Authored
    , authored = Level.build audienceFolders authored
    , shared = List.sortBy .name shared
    , curated = Level.build audienceFolders curated
    }


setFilter : Audience.AudienceType -> DataParams -> DataParams
setFilter filter params =
    if filter == params.filter then
        params

    else
        let
            resetRootParams =
                case filter of
                    Audience.Authored ->
                        { params | authored = Level.goToRootFolder params.authored }

                    Audience.Shared ->
                        params

                    Audience.Curated ->
                        { params | curated = Level.goToRootFolder params.curated }
        in
        { resetRootParams | filter = filter }


updateLevel : (Level -> Level) -> DataParams -> DataParams
updateLevel updater params =
    case params.filter of
        Audience.Authored ->
            { params | authored = updater params.authored }

        Audience.Shared ->
            params

        Audience.Curated ->
            { params | curated = updater params.curated }



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

                DataFetched dataParams ->
                    viewData dataParams

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


viewData : DataParams -> List (Html Msg)
viewData params =
    viewFilterButtons params.filter
        :: (case params.filter of
                Audience.Authored ->
                    viewLevel params.authored

                Audience.Shared ->
                    viewList params.shared

                Audience.Curated ->
                    viewLevel params.curated
           )


viewFilterButtons : Audience.AudienceType -> Html Msg
viewFilterButtons currentFilter =
    let
        button filter title =
            let
                attrs =
                    if filter == currentFilter then
                        [ Attr.class Styles.current ]

                    else
                        [ Events.onClick (SetFilter filter) ]
            in
            Html.button
                (Attr.class Styles.filter :: attrs)
                [ Html.text title ]
    in
    Html.div
        [ Attr.class Styles.filters ]
        [ button Audience.Authored "Authored"
        , button Audience.Shared "Shared"
        , button Audience.Curated "Curated"
        ]


viewLevel : Level -> List (Html Msg)
viewLevel level =
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


viewList : List Audience -> List (Html Msg)
viewList audiences =
    [ Html.ul
        [ Attr.class Styles.list ]
        (List.map viewAudience audiences)
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
