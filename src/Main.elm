module Main exposing (main)

import Browser
import Data.Audience exposing (Audience)
import Data.AudienceFolder exposing (AudienceFolder)
import Data.AudienceTree exposing (AudienceTree)
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Json.Decode exposing (Decoder)
import Process
import Task


type Model
    = Loading LoadingModel
    | DecodingError
    | Loaded LoadedModel


type Msg
    = LoadingMsg LoadingMsg
    | LoadedMsg LoadedMsg


{-| simulates a http loading
-}
wait : Msg -> Cmd Msg
wait msg =
    Task.perform (always msg) (Process.sleep 1000)


listInData : Decoder a -> Decoder (List a)
listInData decoder =
    Json.Decode.field "data" (Json.Decode.list decoder)


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading { audiences = Nothing, audienceFolders = Nothing }
    , Cmd.batch
        [ GotAudiences
            (Json.Decode.decodeString
                (listInData Data.Audience.decoder)
                Data.Audience.fixtures
            )
            |> LoadingMsg
            |> wait
        , GotAudienceFolders
            (Json.Decode.decodeString
                (listInData Data.AudienceFolder.decoder)
                Data.AudienceFolder.fixtures
            )
            |> LoadingMsg
            |> wait
        ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( LoadingMsg loadingMsg, Loading loading ) ->
            updatedLoading loadingMsg loading

        -- instead of using the `_` wildcard for all the other possible
        -- (msg, model) combinaison, I pattern match against LoadingMsg and
        -- "anything else". This way, if I add some variant to the Msg
        -- type, the compiler will help me finding out where to add code.
        ( LoadingMsg _, _ ) ->
            ( model, Cmd.none )

        ( LoadedMsg loadedMsg, Loaded loaded ) ->
            updateLoaded loadedMsg loaded

        ( LoadedMsg _, _ ) ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    case model of
        Loading loadingModel ->
            viewLoading loadingModel
                |> Html.map LoadingMsg

        DecodingError ->
            viewError

        Loaded loadedModel ->
            viewLoaded loadedModel
                |> Html.map LoadedMsg


viewError : Html Msg
viewError =
    Html.div [] [ Html.text "Something wrong happened. Please try to reload the page." ]



------------
-- LOADING
------------


type LoadingMsg
    = GotAudiences (Result Json.Decode.Error (List Audience))
    | GotAudienceFolders (Result Json.Decode.Error (List AudienceFolder))


type alias LoadingModel =
    { audiences : Maybe (List Audience)
    , audienceFolders : Maybe (List AudienceFolder)
    }


updatedLoading : LoadingMsg -> LoadingModel -> ( Model, Cmd Msg )
updatedLoading msg loadingModel =
    case msg of
        GotAudiences (Err _) ->
            ( DecodingError, Cmd.none )

        GotAudienceFolders (Err _) ->
            ( DecodingError, Cmd.none )

        GotAudiences (Ok audiences) ->
            ( transitionLoaded { loadingModel | audiences = Just audiences }
            , Cmd.none
            )

        GotAudienceFolders (Ok audienceFolders) ->
            ( transitionLoaded { loadingModel | audienceFolders = Just audienceFolders }
            , Cmd.none
            )


transitionLoaded : LoadingModel -> Model
transitionLoaded loading =
    case ( loading.audiences, loading.audienceFolders ) of
        ( Just audiences, Just audienceFolders ) ->
            let
                ( audienceTree, errors ) =
                    Data.AudienceTree.fromAudiencesAndFolders audiences audienceFolders
            in
            Loaded
                { breadcrumbs = []
                , currentTree = audienceTree
                , errors = errors
                }

        _ ->
            Loading loading


viewLoading : LoadingModel -> Html LoadingMsg
viewLoading _ =
    Html.div [] [ Html.text "Data are loading..." ]



------------
-- LOADED
------------


type LoadedMsg
    = FolderClicked AudienceTree
    | BreadcrumbClicked SplittedBreadcrumb


type alias LoadedModel =
    { breadcrumbs : List AudienceTree
    , currentTree : AudienceTree
    , errors : Data.AudienceTree.Errors
    }


updateLoaded : LoadedMsg -> LoadedModel -> ( Model, Cmd Msg )
updateLoaded msg loadedModel =
    case msg of
        FolderClicked audienceTree ->
            ( Loaded
                { loadedModel
                    | breadcrumbs = loadedModel.currentTree :: loadedModel.breadcrumbs
                    , currentTree = audienceTree
                }
            , Cmd.none
            )

        BreadcrumbClicked splittedBreadcrumb ->
            ( Loaded
                { loadedModel
                    | breadcrumbs = splittedBreadcrumb.breadcrumbs
                    , currentTree = splittedBreadcrumb.currentTree
                }
            , Cmd.none
            )


viewLoaded : LoadedModel -> Html LoadedMsg
viewLoaded loadedModel =
    Html.div [ Html.Attributes.class "flex flex-row p-4 space-x-10" ]
        [ Html.div [ Html.Attributes.class "flex flex-col space-y-4" ]
            [ viewBreadcrumbs loadedModel
            , viewTree loadedModel.currentTree
            ]
        , viewTreeErrors loadedModel.errors
        ]


viewTree : AudienceTree -> Html LoadedMsg
viewTree tree =
    Html.div [ Html.Attributes.class "flex flex-col space-y-2" ]
        (List.map viewFolder (Data.AudienceTree.children tree)
            ++ List.map viewAudience (Data.AudienceTree.audiences tree)
        )


commonClasses : Html.Attribute msg
commonClasses =
    Html.Attributes.class "p-5 w-64 rounded-md flex flex-row"


truncate : List (Html.Attribute msg) -> List (Html msg) -> Html msg
truncate attrs children =
    Html.div (Html.Attributes.class "w-full truncate" :: attrs) children


viewFolder : AudienceTree -> Html LoadedMsg
viewFolder folder =
    Html.button
        [ commonClasses
        , Html.Attributes.class "bg-blue-800 text-blue-100"
        , Html.Events.onClick (FolderClicked folder)
        ]
        [ truncate [ Html.Attributes.class "flex flex-row items-center space-x-3" ]
            [ viewIcon [] "folder"
            , Html.div [] [ Html.text (Data.AudienceTree.name folder) ]
            , Html.div [ Html.Attributes.class "bg-blue-900 text-gray-300 px-2 py-1 text-xs rounded-md" ]
                [ Html.text
                    (String.fromInt
                        (List.length (Data.AudienceTree.children folder)
                            + List.length (Data.AudienceTree.audiences folder)
                        )
                    )
                ]
            ]
        ]


viewAudience : String -> Html LoadedMsg
viewAudience audience =
    Html.div
        [ commonClasses
        , Html.Attributes.class "bg-blue-600 text-blue-100"
        ]
        [ truncate [ Html.Attributes.class "flex flex-row" ] [ Html.text audience ] ]


viewIcon : List (Html.Attribute msg) -> String -> Html msg
viewIcon attrs name =
    Html.i (Html.Attributes.class "material-icons" :: attrs) [ Html.text name ]



---------
-- ERRORS
---------


viewTreeErrors : Data.AudienceTree.Errors -> Html LoadedMsg
viewTreeErrors errors =
    let
        duplicated =
            errors.duplicatedFolderIds
                |> List.map
                    (\folder ->
                        Html.div [ errorClass ]
                            [ Html.text <|
                                "The "
                                    ++ String.fromInt folder.duplicates.id
                                    ++ " id is used by \""
                                    ++ folder.name
                                    ++ "\" and \""
                                    ++ folder.duplicates.name
                                    ++ "\" folders. Only \""
                                    ++ folder.duplicates.name
                                    ++ "\" has been included."
                            ]
                    )

        missingFromAudiences =
            errors.missingFolderId
                |> List.map
                    (\audience ->
                        Html.div [ errorClass ]
                            [ Html.text <|
                                "The audience \""
                                    ++ audience.name
                                    ++ "\" (id: "
                                    ++ String.fromInt audience.id
                                    ++ ") references "
                                    ++ String.fromInt audience.parent
                                    ++ " as folder id, but this folder doesn't exist. "
                                    ++ " This audience has been added to the root."
                            ]
                    )

        missingFromFolders =
            errors.missingFolderParentId
                |> List.map
                    (\folder ->
                        Html.div [ errorClass ]
                            [ Html.text <|
                                "The folder \""
                                    ++ folder.name
                                    ++ "\" (id: "
                                    ++ String.fromInt folder.id
                                    ++ ") references "
                                    ++ String.fromInt folder.parent
                                    ++ " as parent folder id, but this folder doesn't exist. "
                                    ++ " This folder has been added to the root."
                            ]
                    )
    in
    Html.div
        [ Html.Attributes.class "flex flex-col space-y-2" ]
        (duplicated
            ++ missingFromAudiences
            ++ missingFromFolders
        )


errorClass : Html.Attribute msg
errorClass =
    Html.Attributes.class "p-5 w-64 rounded-md flex flex-row bg-red-800 text-red-100"



-----------
-- BREADCRUMBS
-----------


viewBreadcrumbs : LoadedModel -> Html LoadedMsg
viewBreadcrumbs loadedModel =
    toSplittedBreadcrumbs loadedModel.breadcrumbs
        |> List.reverse
        |> List.map
            (\splitted ->
                Html.button
                    [ Html.Events.onClick (BreadcrumbClicked splitted)
                    , Html.Attributes.class "text-blue-500 underline"
                    ]
                    [ Html.text (Data.AudienceTree.name splitted.currentTree) ]
            )
        |> (\breadcrumbsHtml ->
                breadcrumbsHtml
                    ++ [ Html.div []
                            [ Html.text (Data.AudienceTree.name loadedModel.currentTree) ]
                       ]
           )
        |> List.intersperse (Html.div [ Html.Attributes.class "mx-1" ] [ Html.text ">" ])
        |> Html.div [ Html.Attributes.class "flex flex-row text-sm items-center" ]


type alias SplittedBreadcrumb =
    { currentTree : AudienceTree
    , breadcrumbs : List AudienceTree
    }


toSplittedBreadcrumbs : List AudienceTree -> List SplittedBreadcrumb
toSplittedBreadcrumbs breadcrumbs =
    case breadcrumbs of
        [] ->
            []

        first :: others ->
            { currentTree = first, breadcrumbs = others } :: toSplittedBreadcrumbs others



-----------
-- BOILERPLATE
-----------


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
