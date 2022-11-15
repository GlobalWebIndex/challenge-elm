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
import List.Extra as List


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
    }


type alias Opened =
    { parentID : List Int
    , parentName : List String
    , state : Bool
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
    , opened = { parentID = [ 0 ], parentName = ["Home"], state = False }
    , audience = Aud.audience
    }


update : Msg -> Model -> Model
update msg model =
    let
        newOpened =
            model.opened
        newParentID id =
            id :: newOpened.parentID
        newParentName name =
            name :: newOpened.parentName
    in
    case msg of
        MsgFolderOpened id name ->
            { model | opened = {
                newOpened | parentID = newParentID id, parentName = newParentName name, state = True } }

        MsgFolderClosed ->
            { model | opened = { newOpened | parentID = [0], parentName = ["Home"], state = False } }


view : Model -> Html Msg
view model =
    Html.div [ class "container" ]
        [ Html.h1 [ class "h1" ]
            [ Html.text "Audience Browser"
            ]
        , Html.div [ class "listContainer" ]
            [ Html.div [ id "head" ]
                [ Html.a [ class "breadcrumbps" ] [ text (breadCrumbs model) ]
                , Html.button [ class "backButton", onClick (MsgFolderClosed) ] [ text "Go Up" ]
                ]
            , Html.ul [ class "list" ]
                (List.map (openFolders model.opened) model.folders)
            , Html.ul [ class "list" ]
                (List.map (viewAudience model.opened) model.audience)
            ]
        ]


openFolders : Opened -> AudFolders.AudienceFolder -> Html Msg
openFolders opened list =
    if List.head opened.parentID == Just list.parent && opened.state == True then
        Html.button [ class "folder", onClick (MsgFolderOpened list.id list.name) ] [ text list.name ]

    else if list.parent == 0 && opened.state == False then
        Html.button [ class "folder", onClick (MsgFolderOpened list.id list.name) ] [ text list.name ]

    else
        text ""


breadCrumbs model =
    toString (List.reverse model.opened.parentName)


viewAudience : Opened -> Aud.Audience -> Html msg
viewAudience opened listAudience =
    if List.head opened.parentID == Just listAudience.folder && opened.state == True then
        Html.button [ class "audience" ] [ text listAudience.name ]

    else if listAudience.folder == 0 && opened.state == False then
        Html.button [ class "audience" ] [ text listAudience.name ]

    else
        text ""
