module Main exposing (main)

import Html exposing (Html)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import FontAwesome.Web as Icon


-- Import Modules

import Data.Audience exposing (Audience, AudienceType(..))
import Data.AudienceFolder exposing (AudienceFolder, audienceFoldersJSON)
import Json.Decode as Decode exposing (Decoder, field)
import Json.Decode.Extra as Decode exposing ((|:))


{-| Main file of application
-}
main : Program Never Model Msg
main =
    -- Html.text "There will be app soon!"
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { audienceFolders : List AudienceFolder
    , audiences : List Data.Audience.Audience
    , currentPath : List AudienceFolder
    , selectedFolder : Maybe AudienceFolder
    }


init : ( Model, Cmd Msg )
init =
    let
        audienceFolder =
            case Debug.log "audiencefolder" (audienceFoldersDecoder audienceFoldersJSON) of
                Ok data ->
                    data

                -- @TODO: error reporting
                Err err ->
                    []

        audiences =
            case Debug.log "audiences" (audiencesDecoder Data.Audience.audiencesJSON) of
                Ok data ->
                    data

                -- @TODO: error reporting
                Err err ->
                    []
    in
        ( { audienceFolders = audienceFolder
          , audiences = audiences
          , currentPath = []
          , selectedFolder = Nothing
          }
        , Cmd.none
        )



-- DECODERS


audienceFoldersDecoder : String -> Result String (List AudienceFolder)
audienceFoldersDecoder json =
    json
        |> Decode.decodeString (Decode.at [ "data" ] <| Decode.list audienceFolderDecodeItem)


audienceFolderDecodeItem : Decoder AudienceFolder
audienceFolderDecodeItem =
    Decode.succeed AudienceFolder
        |: (field "id" Decode.int)
        |: (field "name" Decode.string)
        |: (field "parent" <| Decode.maybe Decode.int)


audiencesDecoder : String -> Result String (List Audience)
audiencesDecoder json =
    json
        |> Decode.decodeString (Decode.at [ "data" ] <| Decode.list audiencesDecoderItem)


audiencesDecoderItem : Decoder Audience
audiencesDecoderItem =
    Decode.succeed Audience
        |: (field "id" Decode.int)
        |: (field "name" Decode.string)
        |: (field "type_"
                Decode.string
                |> Decode.andThen audienceTypeDecoder
           )
        |: (field "folder" <| Decode.maybe Decode.int)


audienceTypeDecoder : String -> Decoder AudienceType
audienceTypeDecoder audienceType =
    case audienceType of
        "user" ->
            Decode.succeed Authored

        "shared" ->
            Decode.succeed Shared

        "curated" ->
            Decode.succeed Curated

        _ ->
            Decode.fail (audienceType ++ " is not a recognized audienceType for Audience")



-- MESSAGES


type Msg
    = SelectRootDirectory AudienceFolder
    | SelectBreadcrumbItem AudienceFolder
    | SelectSubDirectory AudienceFolder
    | NoOp



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        _ =
            Debug.log "UPDATE msg: " msg

        _ =
            Debug.log "UPDATE model: " model
    in
        case msg of
            SelectRootDirectory folder ->
                ( { model
                    | currentPath = [ folder ]
                    , selectedFolder = Just folder
                  }
                , Cmd.none
                )

            SelectBreadcrumbItem folder ->
                ( { model | selectedFolder = Just folder }, Cmd.none )

            SelectSubDirectory folder ->
                let
                    newCurrentPath =
                        setCurrentPath folder model.currentPath
                in
                    ( { model
                        | currentPath = newCurrentPath
                        , selectedFolder = Just folder
                      }
                    , Cmd.none
                    )

            NoOp ->
                ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "folders" ]
        , div [ class "column is-one-third" ]
            [ model.audienceFolders
                |> viewRootFolderNavigation model.selectedFolder
            ]
        , div [ class "column" ]
            [ model.currentPath
                |> viewBreadcrumb model.selectedFolder
            ]
        , div [ id "contentPanel", class "panel" ]
            [ h1 [] [ text "content" ]
            , model.audienceFolders
                |> (viewFolderContentSubFolders
                        model.selectedFolder
                   )
            , model.audiences
                |> (viewFolderContentAudiences
                        model.selectedFolder
                   )
            ]
        ]



-- VIEW main menu (root folders)


viewRootFolderNavigation : Maybe AudienceFolder -> List AudienceFolder -> Html Msg
viewRootFolderNavigation selectedFolder audienceFolders =
    aside [ class "menu" ]
        [ ul
            [ id "rootFoldersPanel"
            , class "menu-list"
            ]
            -- @TODO s |> a <| jdou teda dělat rúzné capiny, otázka zda nejsou naḱonec lepší "(...)"
            (audienceFolders
                |> List.filterMap
                    (viewRootFolderNavigationItem
                        selectedFolder
                    )
            )
        ]


viewRootFolderNavigationItem : Maybe AudienceFolder -> AudienceFolder -> Maybe (Html Msg)
viewRootFolderNavigationItem selectedFolder folder =
    let
        {- @TODO: asi je blbost zobrazovat otevřenou vybranou položku v tomto menu,
           určitě to takto nefunguje jak má, protože
           pokud jsem v podsložce tak už nezjistím pod kterou root složkou jsem
           leda bych z currentPath (které ale v této cfunkci stejně nemám) tahal poslední prvek
        -}
        -- @TODO: no nevím, esli by nebylo lepší do funkce isOpenFolder nebylo lepší dávat Just folder a matchovat až tam
        isOpened =
            case selectedFolder of
                Just selectedFolder_unwrap ->
                    isOpenFolder selectedFolder_unwrap folder

                Nothing ->
                    False
    in
        if folder.parent == Nothing then
            Just <|
                li
                    []
                    [ a
                        [ class <|
                            if isOpened then
                                " is-active"
                            else
                                ""
                        , onClick (SelectRootDirectory folder)
                        ]
                        [ if isOpened then
                            Icon.folder_open
                          else
                            Icon.folder
                        , text folder.name
                        ]
                    ]
        else
            Nothing



-- VIEW Breadcrumb


viewBreadcrumb : Maybe AudienceFolder -> List AudienceFolder -> Html Msg
viewBreadcrumb selectedFolder currentPath =
    ul [ id "breadcrumbPanel", class "menu-list" ] <|
        List.map
            (viewBreadcrumbItem selectedFolder)
            (List.reverse currentPath)


viewBreadcrumbItem : Maybe AudienceFolder -> AudienceFolder -> Html Msg
viewBreadcrumbItem selectedFolder folder =
    let
        -- @TODO: no nevím, esli by nebylo lepší do funkce isOpenFolder nebylo lepší dávat Just folder a matchovat až tam
        isOpened =
            case selectedFolder of
                Just selectedFolder_unwrap ->
                    isOpenFolder selectedFolder_unwrap folder

                Nothing ->
                    False
    in
        if isOpened then
            li [ class "tag is-primary is-medium" ] [ text <| folder.name ]
        else
            li [ class "tag is-primary" ]
                [ a
                    [ onClick (SelectBreadcrumbItem folder)
                    ]
                    [ text <| folder.name ]
                ]



-- VIEW content - subfolders


viewFolderContentSubFolders : Maybe AudienceFolder -> List AudienceFolder -> Html Msg
viewFolderContentSubFolders selectedFolder audienceFolders =
    case selectedFolder of
        Just selectedFolder_unwrap ->
            ul [ id "contentPanel folderList" ]
                (audienceFolders
                    |> List.filterMap
                        (viewFolderContentSubFolderItem
                            selectedFolder_unwrap
                        )
                )

        Nothing ->
            div [ class "notification is-warning" ] [ text "no select folder - no subfolders" ]


viewFolderContentSubFolderItem : AudienceFolder -> AudienceFolder -> Maybe (Html Msg)
viewFolderContentSubFolderItem selectedFolder folder =
    let
        isOpened =
            isOpenFolder selectedFolder folder
    in
        case folder.parent of
            -- @TODO: má Elm pattern matching, že by to šlo přímo v case??? Just (parentFolder.id) ->
            Just parentId ->
                if (Debug.log "parent id" parentId) == (Debug.log "selectedFolder.id" selectedFolder.id) then
                    Just <|
                        li
                            [ class "button is-info" ]
                            [ a
                                [ onClick (SelectSubDirectory folder)
                                ]
                                [ Icon.folder
                                , text folder.name
                                ]
                            ]
                else
                    Nothing

            Nothing ->
                Nothing



-- VIEW content - audiences


viewFolderContentAudiences : Maybe AudienceFolder -> List Audience -> Html Msg
viewFolderContentAudiences selectedFolder audiences =
    case selectedFolder of
        Just selectedFolder_unwrap ->
            ul [ id "contentPanel audienceList" ]
                (audiences
                    |> List.filterMap
                        (viewContentAudienceItem selectedFolder_unwrap)
                )

        Nothing ->
            div [ class "notification is-warning" ] [ text "no select folder - no audiences" ]


viewContentAudienceItem : AudienceFolder -> Audience -> Maybe (Html Msg)
viewContentAudienceItem selectedFolder audience =
    case audience.folder of
        Just folderId ->
            if folderId == selectedFolder.id then
                Just (div [] [ text audience.name ])
            else
                Nothing

        Nothing ->
            Nothing



-- UTILS


isOpenFolder : AudienceFolder -> AudienceFolder -> Bool
isOpenFolder selectedFolder folder =
    if folder.id == selectedFolder.id then
        True
    else
        False


setCurrentPath : AudienceFolder -> List AudienceFolder -> List AudienceFolder
setCurrentPath newFolder currentPath =
    case newFolder.parent of
        Just parentId ->
            case currentPath of
                [] ->
                    -- @TODO: a co když newFolder není root folder?
                    [ newFolder ]

                deepFolder :: subPath ->
                    if parentId == deepFolder.id then
                        newFolder :: currentPath
                    else
                        setCurrentPath newFolder subPath

        Nothing ->
            [ newFolder ]
