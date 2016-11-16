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
    , currentFolder : Maybe AudienceFolder
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
          , currentFolder = Nothing
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
                    , currentFolder = Just folder
                  }
                , Cmd.none
                )

            SelectBreadcrumbItem folder ->
                ( { model | currentFolder = Just folder }, Cmd.none )

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
          -- , ul [] (List.map viewFolders model.audienceFolders)
        , ul [ id "rootFoldersPanel" ]
            (List.filterMap
                (viewRootFolderNavigationItem
                    model.currentFolder
                )
                model.audienceFolders
             {- (List.filter
                    rootFoldersFilter
                    model.audienceFolders
                )
             -}
            )
        , viewBreadcrumb model.currentPath
        , div [ id "contentPanel" ]
            [ viewFolderContentSubFolders
                model.currentFolder
                model.audienceFolders
            , viewFolderContentAudiences
                model.currentFolder
                model.audiences
            ]
        , h1 [] [ text "raw source data" ]
        , pre
            []
            [ text audienceFoldersJSON ]
        ]


viewRootFolderNavigationItem : Maybe AudienceFolder -> AudienceFolder -> Maybe (Html Msg)
viewRootFolderNavigationItem currentFolder folder =
    if folder.parent == Nothing then
        Just <|
            li
                []
                [ a [ class "button is-info", onClick (SelectRootDirectory folder) ]
                    [ case currentFolder of
                        Just openedFolder ->
                            if folder.id == openedFolder.id then
                                Icon.folder_open
                            else
                                Icon.folder

                        _ ->
                            Icon.folder
                    , text folder.name
                    ]
                ]
    else
        Nothing


viewBreadcrumbItem : AudienceFolder -> Html Msg
viewBreadcrumbItem folder =
    li []
        [ a [ class "btn ml1 h1", onClick (SelectBreadcrumbItem folder) ]
            [ text folder.name ]
        ]


viewFolderContentSubFolders : Maybe AudienceFolder -> List AudienceFolder -> Html Msg
viewFolderContentSubFolders currentFolder audienceFolders =
    case currentFolder of
        Just folder ->
            ul [ id "contentPanel folderList" ] [ text "any content" ]

        {- List.map
           (viewRootFolderNavigationItem currentFolder)
           (List.filter rootFoldersFilter audienceFolders)
        -}
        Nothing ->
            text "no select folder"


viewFolderContentAudiences : Maybe AudienceFolder -> List Data.Audience.Audience -> Html Msg
viewFolderContentAudiences currentFolderM audiences =
    case currentFolderM of
        Just currentFolder ->
            ul [ id "contentPanel audienceList" ] []

        {- <|
           List.map
               viewContentAudienceItem
               (List.filter
                   (\audience ->
                       case audience.folder of
                           folderId ->
                               currentFolder.id == folderId

                           _ ->
                               False
                   )
                   audiences
               )
        -}
        Nothing ->
            text "no select folder"


viewContentAudienceItem : Data.Audience.Audience -> Html Msg
viewContentAudienceItem audience =
    text audience.name


viewBreadcrumb : List AudienceFolder -> Html Msg
viewBreadcrumb currentPath =
    case currentPath of
        [] ->
            text "bez navigace"

        path ->
            ol [ id "breadcrumbPanel" ] <|
                List.map
                    viewBreadcrumbItem
                    path



-- FILTERS
{-

   rootFoldersFilter : AudienceFolder -> Bool
   rootFoldersFilter folder =
       folder.parent == Nothing
-}
