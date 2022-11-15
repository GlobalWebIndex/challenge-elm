module Main exposing (main)

-- import Data.Audience
import Data.AudienceFolder as AudFolders

import Browser
import Debug exposing (toString)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Decode exposing (string)
import Platform.Cmd exposing (none)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Model =
    { folders : List AudFolders.AudienceFolder
    , opened : Opened
    , audience : List Audience
    }

type alias Audience =
    { id : Int
    , name : String
    , type_ : AudienceType
    , folder : Int
    }


type AudienceType
    = Authored
    | Shared
    | Curated


type alias Opened =
    { parentID : Int
    , parentName : String
    , state : Bool
    }


type Msg
    = MsgFoldersOpened Int String
    | MsgFolderClosed


init : Model
init =
    initModel


initModel : Model
initModel =
    { folders = AudFolders.audFolders
    , opened = { parentID = 0, parentName = "Home", state = False }
    , audience =
        [ { id = 1, name = "Audience1", type_ = Authored, folder = 2 }
        , { id = 1, name = "Audience2", type_ = Shared, folder = 3 }
        , { id = 1, name = "Audience3", type_ = Authored, folder = 5 }
        , { id = 1, name = "Audience4", type_ = Authored, folder = 6 }
        , { id = 1, name = "Audience5", type_ = Shared, folder = 2 }
        , { id = 1, name = "Audience6", type_ = Authored, folder = 1 }
        , { id = 1, name = "Audience7", type_ = Curated, folder = 2 }
        , { id = 1, name = "Audience8", type_ = Authored, folder = 5 }
        , { id = 1, name = "Audience9", type_ = Curated, folder = 0 }
        ]
    }





update : Msg -> Model -> Model
update msg model =
    let
        newOpened =
            model.opened
    in
    case msg of
        MsgFoldersOpened id name ->
            { model | opened = { newOpened | parentID = id, parentName = name, state = True } }

        MsgFolderClosed ->
            { model | opened = { newOpened | parentID = 0, parentName = "Home", state = False } }


view : Model -> Html Msg
view model =
    Html.div [ class "container" ]
        [ Html.h1 [ class "h1" ]
            [ Html.text "Audience Browser"
            ]
        , Html.div [ class "search" ]
            [ Html.button [ id "searchButton" ]
                [ Html.img
                    [ class "searchIcon"
                    , Html.Attributes.src "src/Svg/searchIcon.svg"
                    , Html.Attributes.attribute "description" "SearchIcon"
                    ]
                    []
                ]
            , Html.input [ Html.Attributes.type_ "search", placeholder "Search", id "searchbar" ]
                []
            ]
        , Html.div [ class "listContainer" ]
            [ Html.div [ id "head" ]
                [ Html.a [ class "breadcrumbps" ] [ text (breadCrumbs model) ]
                , Html.button [ class "backButton", onClick MsgFolderClosed ] [ text "Back" ]
                ]
            , Html.ul [ class "list" ]
                (List.map (openFolders model.opened) model.folders)
            , Html.ul [ class "list" ]
                (List.map (viewAudience model.opened) model.audience)
            ]
        ]


openFolders : Opened -> AudFolders.AudienceFolder -> Html Msg
openFolders opened list =
    if opened.parentID == list.parent && opened.state == True then
        Html.li []
            [ Html.button [ class "folder", onClick (MsgFoldersOpened list.id list.name) ] [ text list.name ]
            ]

    else if list.parent == 0 && opened.state == False then
        Html.li []
            [ Html.button [ class "folder", onClick (MsgFoldersOpened list.id list.name) ] [ text list.name ]
            ]

    else
        Html.li []
            []


breadCrumbs model =
    model.opened.parentName


viewAudience : Opened -> Audience -> Html msg
viewAudience opened listAudience =
    if opened.parentID == listAudience.folder && opened.state == True then
        Html.li []
            [ Html.button [ class "audience" ] [ text listAudience.name ]
            ]
    else if listAudience.folder == 0 && opened.state == False then
        Html.li []
            [ Html.button [ class "audience" ] [ text listAudience.name ]
            ]
    else
        Html.li []
            []


