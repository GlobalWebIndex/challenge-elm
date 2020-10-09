module Main exposing (main, rootAudiences)

import Browser
import Css as Css
import Data.Audience exposing (..)
import Data.AudienceFolder exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import Json.Decode as D
import Json.Decode.Extra as DX



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view >> toUnstyled
        }



-- MODEL


type Model
    = DecodeFailed String
    | DecodeOk AudiencesAndFolder


type alias AudiencesAndFolder =
    { audienceFolders : List AudienceFolder
    , audiences : List Audience
    , currentAudienceFolders : List AudienceFolder
    , currentAudiences : List Audience
    , currentFolder : Maybe AudienceFolder
    }


rootAudienceFolders : List AudienceFolder -> List AudienceFolder
rootAudienceFolders allAudienceFolders =
    List.filter isRootAudienceFolder allAudienceFolders


isRootAudienceFolder : AudienceFolder -> Bool
isRootAudienceFolder folder =
    case folder.parent of
        Just _ ->
            False

        Nothing ->
            True


rootAudiences : List Audience -> List Audience
rootAudiences allAudiences =
    List.filter isRootAudience allAudiences


isRootAudience : Audience -> Bool
isRootAudience audience =
    case audience.folder of
        Just _ ->
            False

        Nothing ->
            True


folderIdIs : Int -> Audience -> Bool
folderIdIs id audience =
    case audience.folder of
        Just fId ->
            if fId == id then
                True

            else
                False

        Nothing ->
            False


parentIdIs : Int -> AudienceFolder -> Bool
parentIdIs id folder =
    case folder.parent of
        Just fId ->
            if fId == id then
                True

            else
                False

        Nothing ->
            False


init : () -> ( Model, Cmd Msg )
init _ =
    let
        decodedAudienceFolders =
            D.decodeString (D.field "data" <| D.list audienceFolderDecoder) audienceFoldersJSON

        decodedAudiences =
            D.decodeString (D.field "data" <| D.list audienceDecoder) audiencesJSON
    in
    case decodedAudienceFolders of
        Ok audienceFolders ->
            case decodedAudiences of
                Ok audiences ->
                    ( DecodeOk <|
                        AudiencesAndFolder
                            audienceFolders
                            audiences
                            (rootAudienceFolders audienceFolders)
                            (rootAudiences audiences)
                            Nothing
                    , Cmd.none
                    )

                Err error ->
                    ( DecodeFailed <| D.errorToString error, Cmd.none )

        Err error ->
            ( DecodeFailed <| D.errorToString error, Cmd.none )



-- UPDATE


type Msg
    = GoUp AudienceFolder
    | OpenFolder AudienceFolder


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case model of
        DecodeOk { audienceFolders, audiences, currentAudienceFolders, currentAudiences } ->
            case msg of
                GoUp parentFolder ->
                    case parentFolder.parent of
                        Just parentId ->
                            let
                                currentFolder =
                                    List.head <| List.filter (\folder -> folder.id == parentId) audienceFolders

                                nextFolders =
                                    List.filter (parentIdIs parentId) audienceFolders

                                nextAudiences =
                                    List.filter (folderIdIs parentId) audiences
                            in
                            ( DecodeOk <| AudiencesAndFolder audienceFolders audiences nextFolders nextAudiences currentFolder, Cmd.none )

                        Nothing ->
                            ( DecodeOk <| AudiencesAndFolder audienceFolders audiences (rootAudienceFolders audienceFolders) (rootAudiences audiences) Nothing, Cmd.none )

                OpenFolder folder ->
                    let
                        nextFolders =
                            List.filter (parentIdIs folder.id) audienceFolders

                        nextAudiences =
                            List.filter (folderIdIs folder.id) audiences
                    in
                    ( DecodeOk <| AudiencesAndFolder audienceFolders audiences nextFolders nextAudiences (Just folder), Cmd.none )

        DecodeFailed _ ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    case model of
        DecodeFailed errorStr ->
            text errorStr

        DecodeOk { currentAudienceFolders, currentAudiences, currentFolder } ->
            div []
                [ viewCurrentFolder currentFolder
                , div []
                    (List.map (\folder -> viewAudienceFolder folder) currentAudienceFolders)
                , div []
                    (List.map (\file -> viewAudience file) currentAudiences)
                ]


viewCurrentFolder : Maybe AudienceFolder -> Html Msg
viewCurrentFolder maybeFolder =
    case maybeFolder of
        Just folder ->
            div [ onClick (GoUp folder), css [ folderCss True ] ]
                [ text folder.name ]

        Nothing ->
            div [] []


viewAudience : Audience -> Html msg
viewAudience audience =
    div [ css [ fileCss ] ]
        [ text audience.name ]


viewAudienceFolder : AudienceFolder -> Html Msg
viewAudienceFolder audienceFolder =
    div [ onClick (OpenFolder audienceFolder), css [ folderCss False ] ]
        [ text audienceFolder.name ]



-- DECODERS


audienceFolderDecoder : D.Decoder AudienceFolder
audienceFolderDecoder =
    D.succeed AudienceFolder
        |> DX.andMap (D.field "id" D.int)
        |> DX.andMap (D.field "name" D.string)
        |> DX.andMap (D.field "parent" (D.nullable D.int))


audienceDecoder : D.Decoder Audience
audienceDecoder =
    D.succeed Audience
        |> DX.andMap (D.field "id" D.int)
        |> DX.andMap (D.field "name" D.string)
        |> DX.andMap (D.field "type" (D.andThen audienceTypeDecoder D.string) |> DX.withDefault Shared)
        |> DX.andMap (D.field "folder" (D.nullable D.int))


audienceTypeDecoder : String -> D.Decoder AudienceType
audienceTypeDecoder typeString =
    case typeString of
        "authored" ->
            D.succeed Authored

        "shared" ->
            D.succeed Shared

        "curated" ->
            D.succeed Curated

        _ ->
            D.fail ("this is not an audience type: " ++ typeString)



-- CSS


fileCss : Css.Style
fileCss =
    Css.batch
        [ Css.backgroundColor (Css.hex "#5f9ea0")
        , Css.width (Css.px 200)
        , Css.color (Css.hex "white")
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
            , Css.float Css.right
            ]
        ]
