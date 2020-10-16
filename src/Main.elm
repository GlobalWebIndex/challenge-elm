module Main exposing (main)

import Browser exposing (sandbox)
import Data.Audience exposing (..)
import Data.AudienceFolder exposing (..)
import Dict exposing (Dict)
import Dict.Extra as DE exposing (fromListDedupe)
import Html exposing (Html, div, button, text)
import Html.Events
import Html.Attributes
import Json.Decode as JD exposing (decodeString)
import List as L exposing (map, drop, filter)
import Maybe as M


type alias Model = {
    audiences : Dict Int (List Audience)
    , audienceFolders :  Dict Int (List AudienceFolder)
    , currentFolder : List Int
    , audienceFilter : AudienceType }

type Msg =
    Up
    | Down Int
    | Filter AudienceType

main : Program () Model Msg
main = sandbox {
    init = {audiences = audiences
        , audienceFolders = audienceFolders
        , currentFolder = []
        , audienceFilter = Authored},
    view = view,
    update = update}

view : Model -> Html Msg
view model =
    div [] [viewContents model]

update : Msg -> Model -> Model
update msg model =
    case msg of
        Up -> {model | currentFolder = L.drop 1 model.currentFolder}
        Down dir -> {model | currentFolder = dir::model.currentFolder}
        Filter at -> {model | audienceFilter = at, currentFolder = []}

audiences : Dict Int (List Audience)
audiences =
    audiencesJSON
    |> JD.decodeString decodeAudiences
    |> Result.withDefault []
    |> L.map (\aud -> (M.withDefault -1 aud.folder, [aud]))
    |> DE.fromListDedupe List.append

audienceFolders : Dict Int (List AudienceFolder)
audienceFolders =
    audienceFoldersJSON
    |> JD.decodeString decodeAudienceFolders
    |> Result.withDefault []
    |> L.map (\audF -> (M.withDefault -1 audF.parent, [audF]))
    |> DE.fromListDedupe List.append

viewContents : Model -> Html Msg
viewContents model =
    let
        currF = List.head model.currentFolder |> M.withDefault -1
        contents =
            if model.audienceFilter /= Shared then
                List.append
                (viewAudienceFolders model.audienceFolders currF)
                (viewAudiences model.audienceFilter model.audiences currF)
            else
                viewAllAudiences
                <| Dict.foldl (\parent children lst -> children++lst) [] model.audiences
    in
    Html.div (contentsStyle (currF /= -1))
        [ maybeViewBackButton (currF /= -1 && model.audienceFilter /= Shared)
        , viewFilterButtons model.audienceFilter
        , Html.ul [Html.Attributes.style "width" "50%"] contents
        ]

maybeViewBackButton : Bool -> Html Msg
maybeViewBackButton display =
    if display then
        Html.button ((Html.Events.onClick Up)::backButtonStyle) [Html.text "Back"]
    else
        Html.div [] []

viewFilterButtons : AudienceType -> Html Msg
viewFilterButtons at =
    Html.div
        [ Html.Attributes.style "width" "50%"
        , Html.Attributes.style "margin-left" "40px"
        , Html.Attributes.style "margin-top" "20px"
        ]
        [ viewFilterButton at Authored
        , viewFilterButton at Shared
        , viewFilterButton at Curated
        ]

viewFilterButton : AudienceType -> AudienceType -> Html Msg
viewFilterButton selectedAudienceType audienceType =
    let
        filterButtonStyles = containerStyle++containerButtonStyle
    in
    Html.button
        (filterButtonStyles++
            (selectedAudienceAction (selectedAudienceType == audienceType) (Filter audienceType))
        )
        [text <| audienceTypeToString audienceType]

audienceTypeToString : AudienceType -> String
audienceTypeToString at =
    case at of
        Shared -> "Shared"
        Authored -> "Authored"
        Curated -> "Curated"


selectedAudienceAction : Bool -> Msg -> List (Html.Attribute Msg)
selectedAudienceAction isSelected msg =
    let
        action = [Html.Events.onClick msg]
    in
    if isSelected then
        action ++ [Html.Attributes.style "background-color" "#baff13"]
    else action

viewAudienceFolders : Dict Int (List AudienceFolder) -> Int -> List (Html Msg)
viewAudienceFolders aFolders currentFolder =
    L.map viewAudienceFolder (Dict.get currentFolder aFolders |> M.withDefault [])

viewAudienceFolder : AudienceFolder -> Html Msg
viewAudienceFolder {id, name, parent} =
    Html.li (listItemStyle++
        [ Html.Events.onClick (Down id)
        , Html.Attributes.style "background-color" "#007bff"
        , Html.Attributes.style "cursor" "pointer"
        , Html.Attributes.style "border-color" "#007bff"
        ])
        [ Html.text name ]

viewAllAudiences : List Audience -> List (Html Msg)
viewAllAudiences ads =
    L.map (\file -> viewAudience file) ads

viewAudiences : AudienceType -> Dict Int (List Audience) -> Int -> List (Html Msg)
viewAudiences at ads currentFolder =
    L.map viewAudience (L.filter (\a -> a.type_ == at) (Dict.get currentFolder ads |> M.withDefault []))

viewAudience : Audience -> Html Msg
viewAudience {id, name, type_, folder} =
    Html.li
        (listItemStyle ++
            [ Html.Attributes.style "background-color" "#91c0f3"
            , Html.Attributes.style "border-color" "#8cacce" ])
        [Html.text name]


----- styles only ----

containerButtonStyle : List (Html.Attribute Msg)
containerButtonStyle = [Html.Attributes.style "width" "30%"
    , Html.Attributes.style "display" "inline-block"]

contentsStyle : Bool -> List (Html.Attribute Msg)
contentsStyle backExists =
    if backExists then []
    else [Html.Attributes.style "margin-top" "78px"]

listItemStyle : List (Html.Attribute Msg)
listItemStyle = containerStyle ++
    [ Html.Attributes.style "width" "100%"
    , Html.Attributes.style "color" "#fff"]

backButtonStyle : List (Html.Attribute Msg)
backButtonStyle = containerStyle ++
    [ Html.Attributes.style "margin-left" "40px"
    , Html.Attributes.style "background-color" "#7d30a5"
    , Html.Attributes.style "cursor" "pointer"
    , Html.Attributes.style "color" "#fff"
    , Html.Attributes.style "border-color" "#6b1371"
    , Html.Attributes.style "margin-top" "20px"]

containerStyle : List (Html.Attribute Msg)
containerStyle =
    [ Html.Attributes.style "display" "table"
    , Html.Attributes.style "font-weight" "400"
    , Html.Attributes.style "text-align" "center"
    , Html.Attributes.style "white-space" "nowrap"
    , Html.Attributes.style "vertical-align" "middle"
    , Html.Attributes.style "user-select" "none"
    , Html.Attributes.style "border" "1px solid transparent"
    , Html.Attributes.style "padding" ".375rem .75rem"
    , Html.Attributes.style "font-size" "1rem"
    , Html.Attributes.style "line-height" "1.5"
    , Html.Attributes.style "border-radius" ".25rem"
    , Html.Attributes.style "transition" "color .15s"]
