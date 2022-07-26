module Main exposing (main, Msg(..), update, view, init)


import Browser
import Data.Audience            exposing (Audience, AudienceType, audiencesJSON)
import Data.AudienceFolder      exposing (AudienceFolder, audienceFoldersJSON)
import Data.Decoder             exposing (decodeGetAudiences, decodeGetAudienceFolders)
import Data.Tree                exposing (..)
import Dict                     exposing (Dict)
import Html                     exposing (Html, div, text)
import Html.Attributes          exposing (style)
import Html.Events              exposing (onClick)
import Http
import Json.Decode as Decode    exposing (Decoder, decodeString)
import Task                     exposing (Task)


type alias Model =
    { audiences: Dict Int (List Audience)
    , folders: Dict Int (List AudienceFolder)
    , stack: List AudienceFolder
    }


type Msg
    = GotAudiences (List Audience)
    | GotAudienceFolders (List AudienceFolder)
    | OpenFolder AudienceFolder
    | GoUp


-- MAIN

main =
    Browser.element
        { init          = init
        , view          = view
        , update        = update
        , subscriptions = always Sub.none
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { audiences = Dict.empty
      , folders = Dict.empty
      , stack = []
      }

    -- Load audiences and folders concurrently.
    --
    -- The real application will execute an appropiate HTTP requests.
    -- But for testing purposes we will use the provided fixtures.
    , Cmd.batch
        [ Task.attempt (Result.withDefault [] >> GotAudiences)
              <| loadDataTask decodeGetAudiences audiencesJSON
        , Task.attempt (Result.withDefault [] >> GotAudienceFolders)
              <| loadDataTask decodeGetAudienceFolders audienceFoldersJSON
        ]
    )


loadDataTask : Decoder a -> String -> Task Http.Error a
loadDataTask decoder fixture =
        case decodeString decoder fixture of
            Ok data ->
                Task.succeed data

            -- map JSON decode error into Http.BadBody as it done by elm/http
            Err err ->
                Task.fail <| Http.BadBody <| Decode.errorToString err



update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotAudiences audiences ->
            ( { model
                  | stack = []
                  , audiences = buildAudiences audiences
              }
            , Cmd.none
            )

        GotAudienceFolders folders ->
            ( { model
                  | stack = []
                  , folders = buildFolders folders
              }
            , Cmd.none
            )

        OpenFolder folder ->
            ( { model
                  | stack = folder :: model.stack
              }
            , Cmd.none
            )

        GoUp ->
            ( { model | stack = List.tail model.stack |> Maybe.withDefault [] }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    let parent =
            List.head model.stack

        parentId =
            case parent of
                Nothing ->
                    0
                Just folder ->
                    folder.id
    in

    -- We don't use CSS to simplify the build of the application.
    -- Using the elm only build allow us to use elm reactor or
    -- run run the application in debug mode line this:
    --   elm make --debug src/Main.elm && open index.html
    --
    -- So tags body & html are out of our control.
    -- Let's use some ancient positioning technics. The outer DIV
    -- is positioned absolute with height equal to viewport and width 200px
    --
    div [ style "width" "300px"
        , style "position" "absolute"
        , style "left" "0"
        , style "top" "0"
        , style "bottom" "0"
        , style "margin" "0"
        , style "padding" "0"
        , style "border" "0"
        ]
        [ div [ style "height" "30px" ] [ renderButtons model parent ]
        , div [ style "position" "absolute"
              , style "left" "0"
              , style "top" "30px"
              , style "bottom" "0"
              , style "overflow" "scroll"
              , style "width" "100%"
              ] [ renderFolders model parentId
                , renderAudiences model parentId
                ]
        ]


renderButtons model parent =
    case parent of
        Nothing ->
            text ""

        Just folder ->
            div [ style "padding" "10px"
                , style "overflow" "hidden"
                , style "white-space" "nowrap"
                , style "text-overflow" "ellipsis"
                , onClick GoUp ] [ text <| "Go up: " ++ folder.name]

renderFolders model parent =
    Dict.get parent model.folders
        |> Maybe.withDefault []
        |> List.map renderFolder
        |> div []


renderFolder : AudienceFolder -> Html Msg
renderFolder folder =
    div [ style "padding" "10px"
        , style "overflow" "hidden"
        , style "white-space" "nowrap"
        , style "text-overflow" "ellipsis"
        , style "color" "white"
        , style "background" "blue"
        , style "border-radius" "3px"
        , style "margin" "5px"
        , onClick <| OpenFolder folder
        ] [ text folder.name ]


renderAudiences model parent =
    Dict.get parent model.audiences
        |> Maybe.withDefault []
        |> List.map renderAudience
        |> div []


renderAudience audience =
    div [ style "padding" "10px"
        , style "overflow" "hidden"
        , style "white-space" "nowrap"
        , style "text-overflow" "ellipsis"
        , style "background" "grey"
        , style "margin" "5px"
        , style "border-radius" "3px"
        ] [ text audience.name ]
