module Main exposing (main)

import Browser
import Data.Audience as Aud
import Data.AudienceFolder as AudFolders
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
    , audience : List Aud.Audience
    , breadcrumbs : Breadcrumbs
    }


type alias Opened =
    { currentId : Maybe Int
    , parentId : Maybe Int
    , usedIdList : List Int
    , parentName : List String
    , state : Bool
    }


type alias Breadcrumbs =
    { breadCrumbName : List String
    , breadCrumbId : List Int
    }


type Msg
    = MsgFolderOpened Int String
    | MsgFolderClosed


init : Model
init =
    initModel


initModel : Model
initModel =
    { folders = AudFolders.audFolders
    , opened = { currentId = Nothing, parentId = Nothing, usedIdList = [], parentName = [], state = False }
    , audience = Aud.audience
    , breadcrumbs = { breadCrumbName = [ "Home" ], breadCrumbId = [] }
    }


update : Msg -> Model -> Model
update msg model =
    let
        newOpened =
            model.opened

        newBreadcrumb =
            model.breadcrumbs

        newBreadcrumbId id =
            id :: newBreadcrumb.breadCrumbId

        newParentId =
            newOpened.currentId

        newCurrentId =
            newOpened.parentId

        newParentName name =
            name :: newOpened.parentName

        newUsedIdList id =
            id :: newOpened.usedIdList

        newBreadcrumbpName name =
            name :: newBreadcrumb.breadCrumbName

        stateOfcurrentId id =
            case id of
                Just _ -> True
                Nothing -> False

    in
    case msg of
        MsgFolderOpened id name ->
            { model | opened = { newOpened | currentId = Just id, parentId = newParentId, parentName = newParentName name, usedIdList = newUsedIdList id, state = True }, breadcrumbs = { newBreadcrumb | breadCrumbName = newBreadcrumbpName name, breadCrumbId = newBreadcrumbId id } }

        MsgFolderClosed ->
            { model | opened = { newOpened | currentId = newCurrentId, parentId = List.head (List.drop 2 newOpened.usedIdList), parentName = List.drop 1 newOpened.parentName, usedIdList = List.drop 1 newOpened.usedIdList, state = stateOfcurrentId newOpened.parentId }, breadcrumbs = { newBreadcrumb | breadCrumbName = List.drop 1 newBreadcrumb.breadCrumbName, breadCrumbId = List.drop 1 newBreadcrumb.breadCrumbId } }


view : Model -> Html Msg
view model =
    Html.div [ class "container" ]
        [ Html.h1 [ class "h1" ]
            [ Html.text "Audience Browser"
            ]
        , Html.div [ class "listContainer" ]
            [ Html.div [ id "head" ]
                [ Html.a [ class "breadcrumbps" ] [ text (breadCrumbs model) ]
                , Html.button [ class "backButton", onClick MsgFolderClosed ] [ text "Go Up" ]
                ]
            , Html.ul [ class "list" ]
                (List.map (openFolders model.opened) model.folders)
            , Html.ul [ class "list" ]
                (List.map (viewAudience model.opened) model.audience)
            ]
        ]



-- closeFolders =
--     if opened.currentId == list.parent && opened.state == True then
--         MsgFolderClosed list.id
--     else
--         Html.button [ class "folder", onClick (MsgFolderOpened list.id list.name) ] [ text list.name ]


openFolders : Opened -> AudFolders.AudienceFolder -> Html Msg
openFolders opened list =
    if opened.currentId == list.parent && opened.state == True then
        Html.button [ class "folder", onClick (MsgFolderOpened list.id list.name) ] [ text list.name ]

    else if list.parent == Nothing && opened.state == False then
        Html.button [ class "folder", onClick (MsgFolderOpened list.id list.name) ] [ text list.name ]

    else
        text ""


breadCrumbs model =
    toString (List.reverse model.breadcrumbs.breadCrumbName)


viewAudience : Opened -> Aud.Audience -> Html msg
viewAudience opened listAudience =
    if opened.currentId == listAudience.folder && opened.state == True then
        Html.button [ class "audience" ] [ text listAudience.name ]

    else if listAudience.folder == Nothing && opened.state == False then
        Html.button [ class "audience" ] [ text listAudience.name ]

    else
        text ""
