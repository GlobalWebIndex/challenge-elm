module Main exposing (main)

import Browser
import Css as Css
import Data.Audience as Audience exposing (Audience, AudienceType(..), audiencesJSON)
import Data.AudienceFolder as AudienceFolder exposing (AudienceFolder, audienceFoldersJSON)
import Explorer as E
import FileSystem as FS exposing (FileSystem)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import Json.Decode as D
import Json.Decode.Extra as DX



-- Main


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view >> toUnstyled
        }



-- Model


type Model
    = DecodeFailed String
    | DecodeOk (List AudienceFolder) (List Audience) (FileSystem AudienceFolder Audience)


init : () -> ( Model, Cmd Msg )
init _ =
    let
        decodedAudienceFolders =
            D.decodeString AudienceFolder.decoder audienceFoldersJSON

        decodedAudiences =
            D.decodeString Audience.decoder audiencesJSON
    in
    case decodedAudienceFolders of
        Ok folders ->
            case decodedAudiences of
                Ok audiences ->
                    ( DecodeOk
                        folders
                        audiences
                        (FS.createRoot (AudienceFolder.roots folders) (Audience.roots audiences))
                    , Cmd.none
                    )

                Err error ->
                    ( DecodeFailed <| D.errorToString error, Cmd.none )

        Err error ->
            ( DecodeFailed <| D.errorToString error, Cmd.none )



-- Update


type Msg
    = GoUp
    | GoTo AudienceFolder


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case model of
        DecodeOk folders audiences fs ->
            case msg of
                GoUp ->
                    ( DecodeOk
                        folders
                        audiences
                        (fs |> FS.goUp)
                    , Cmd.none
                    )

                GoTo folder ->
                    let
                        newSubFolders =
                            \_ -> List.filter (AudienceFolder.isParent folder) folders

                        newSubAudiences =
                            \_ -> List.filter (Audience.isParent folder) audiences
                    in
                    ( DecodeOk
                        folders
                        audiences
                        (fs |> FS.goTo folder |> FS.expandFolder newSubFolders newSubAudiences)
                    , Cmd.none
                    )

        DecodeFailed _ ->
            ( model, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- View


view : Model -> Html Msg
view model =
    case model of
        DecodeFailed errorStr ->
            text errorStr

        DecodeOk _ _ explorer ->
            let
                subFolders =
                    explorer |> FS.subFolders

                subAudiences =
                    explorer |> FS.subFiles
            in
            div []
                [ viewCurrentFolder (explorer |> FS.currentFolder) (List.length subFolders + List.length subAudiences)
                , div []
                    (List.map (\zipper -> viewAudienceFolder zipper) subFolders)
                , div []
                    (List.map (\file -> viewAudience file) subAudiences)
                ]


viewCurrentFolder : Maybe AudienceFolder -> Int -> Html Msg
viewCurrentFolder maybeFolder filesLength =
    case maybeFolder of
        Just folder ->
            div [ onClick GoUp, css [ folderCss True ] ]
                [ text folder.name
                , span [ css [ folderSize ] ] [ text <| String.fromInt filesLength ]
                ]

        Nothing ->
            div [] []


viewAudience : Audience -> Html msg
viewAudience audience =
    div [ css [ fileCss ] ]
        [ text audience.name ]


viewAudienceFolder : AudienceFolder -> Html Msg
viewAudienceFolder folder =
    div [ onClick (GoTo folder), css [ folderCss False ] ]
        [ text folder.name ]



-- Css


fileCss : Css.Style
fileCss =
    Css.batch
        [ Css.backgroundColor (Css.hex "#5f9ea0")
        , Css.width (Css.px 240)
        , Css.color (Css.hex "#ffffff")
        , Css.fontSize (Css.px 19)
        , Css.padding (Css.px 20)
        , Css.borderRadius (Css.px 5)
        , Css.margin (Css.px 5)
        ]


folderCss : Bool -> Css.Style
folderCss isOpen =
    let
        content =
            if isOpen then
                "\"🗁\""

            else
                "\"🗀\""
    in
    Css.batch
        [ fileCss
        , Css.cursor Css.pointer
        , Css.hover [ Css.backgroundColor (Css.hex "#4c7e80") ]
        , Css.after
            [ Css.property "content" content
            , Css.float Css.left
            , Css.marginTop (Css.px -4)
            , Css.marginRight (Css.px 8)
            ]
        ]


folderSize : Css.Style
folderSize =
    Css.batch
        [ Css.float Css.right
        , Css.backgroundColor (Css.hex "#3d6566")
        , Css.color (Css.hex "#ffffff")
        , Css.borderRadius (Css.px 4)
        , Css.paddingRight (Css.px 6)
        , Css.paddingLeft (Css.px 6)
        ]
