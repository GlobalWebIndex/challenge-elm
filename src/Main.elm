module Main exposing (main)

import Data.Audience exposing (..)
import Data.AudienceFolder exposing (..)
import Html exposing (Html, div, button, text)
import Html.Events
import Html.Attributes
import Browser exposing (sandbox)
import Json.Decode exposing (decodeString)
import Dict.Extra as DE
import Dict exposing (Dict, size)
import List exposing (map, drop)
import Maybe as M exposing (withDefault)
import Debug exposing (toString)


main : Program () Model Msg
main = sandbox {
    init = {audiences = audiences, audienceFolders = audienceFolders, currentFolder = []},
    view = view,
    update = update}

type alias Model = {
    audiences : Dict Int (List Audience)
    , audienceFolders :  Dict Int (List AudienceFolder)
    , currentFolder : List Int }

type Msg =
    Up
    | Down Int

view : Model -> Html Msg
view model =
    div [] [displayContents model]

update : Msg -> Model -> Model
update msg model =
    case msg of
        Up -> {model | currentFolder = drop 1 model.currentFolder}
        Down dir -> {model | currentFolder = dir::model.currentFolder}


audiences : Dict Int (List Audience)
audiences =
    audiencesJSON
    |> decodeString decodeAudiences
    |> Result.withDefault []
    |> map (\aud -> (M.withDefault -1 aud.folder, [aud]))
    |> DE.fromListDedupe List.append

audienceFolders : Dict Int (List AudienceFolder)
audienceFolders =
    audienceFoldersJSON
    |> decodeString decodeAudienceFolders
    |> Result.withDefault []
    |> map (\audF -> (M.withDefault -1 audF.parent, [audF]))
    |> DE.fromListDedupe List.append


displayContents : Model -> Html Msg
displayContents model =
    let
        currF = List.head model.currentFolder |> withDefault -1
    in
    Html.div []
    [maybeDisplayBack (currF /= -1)
    , Html.ul [ Html.Attributes.style "width" "50%"]
        <| List.append
            (map displayFolder (Dict.get currF model.audienceFolders |> withDefault []))
            (map displayFile (Dict.get currF model.audiences |> withDefault []))
    ]

maybeDisplayBack : Bool -> Html Msg
maybeDisplayBack display =
    if display then
        Html.button ((Html.Events.onClick Up)::backButtonStyle) [Html.text "Back"]
    else
        Html.div [] []

displayFolder : AudienceFolder -> Html Msg
displayFolder {id, name, parent} =
    Html.li (commonStyle++
        [ Html.Events.onClick (Down id)
        , Html.Attributes.style "background-color" "#007bff"
        , Html.Attributes.style "cursor" "pointer"
        ])
        [ Html.text name ]

displayFile : Audience -> Html Msg
displayFile {id, name, type_, folder} =
    Html.li ((Html.Attributes.style "background-color" "#91c0f3")::commonStyle) [Html.text name]

commonStyle = [ Html.Attributes.style "color" "#fff"
        , Html.Attributes.style "border-color" "#007bff"
        , Html.Attributes.style "display" "table"
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
        , Html.Attributes.style "transition" "color .15s"
        , Html.Attributes.style "width" "100%"
    ]

backButtonStyle = [ Html.Attributes.style "margin-left" "40px"
    , Html.Attributes.style "background-color" "#7d30a5"
    , Html.Attributes.style "cursor" "pointer"
    , Html.Attributes.style "color" "#fff"
    , Html.Attributes.style "border-color" "#007bff"
    , Html.Attributes.style "display" "table"
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
