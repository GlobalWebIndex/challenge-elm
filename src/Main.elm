module Main exposing (main)

import Browser
import Css as Css
import Data.Audience as Audience exposing (Audience, AudienceType(..), audiencesJSON)
import Data.AudienceFolder as AudienceFolder exposing (AudienceFolder, audienceFoldersJSON)
import FileSystem as FS exposing (FileSystem)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, value)
import Html.Styled.Events exposing (onClick, onInput)
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
    | DecodeOk Audiences


type alias Audiences =
    { searchStr : String
    , selectedType : AudienceType
    , authored : AudienceBrowser
    , curated : AudienceBrowser
    , shared : List Audience
    }


type AudienceBrowser
    = AudienceBrowser (List AudienceFolder) (List Audience) (FileSystem AudienceFolder Audience)


type alias CategorizedAudiences =
    { authoredAudiences : List Audience
    , curatedAudiences : List Audience
    , sharedAudiences : List Audience
    }


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
                    let
                        { authoredAudiences, curatedAudiences, sharedAudiences } =
                            categorizeAudiences audiences

                        ( authoredFolders, curatedFolders ) =
                            List.partition (not << .curated) folders

                        categorizedAudiences =
                            Audiences
                                ""
                                Authored
                                (AudienceBrowser folders authoredAudiences (FS.createRoot (AudienceFolder.roots authoredFolders) (Audience.roots authoredAudiences)))
                                (AudienceBrowser folders curatedAudiences (FS.createRoot (AudienceFolder.roots curatedFolders) (Audience.roots curatedAudiences)))
                                (sharedAudiences |> List.sortBy .name)
                    in
                    ( DecodeOk categorizedAudiences, Cmd.none )

                Err error ->
                    ( DecodeFailed <| D.errorToString error, Cmd.none )

        Err error ->
            ( DecodeFailed <| D.errorToString error, Cmd.none )


categorizeAudiences : List Audience -> CategorizedAudiences
categorizeAudiences audiences =
    List.foldl categorize (CategorizedAudiences [] [] []) audiences


categorize : Audience -> CategorizedAudiences -> CategorizedAudiences
categorize audience { authoredAudiences, curatedAudiences, sharedAudiences } =
    case audience.type_ of
        Authored ->
            CategorizedAudiences (audience :: authoredAudiences) curatedAudiences sharedAudiences

        Curated ->
            CategorizedAudiences authoredAudiences (audience :: curatedAudiences) sharedAudiences

        Shared ->
            CategorizedAudiences authoredAudiences curatedAudiences (audience :: sharedAudiences)



-- Update


type Msg
    = GoUp
    | GoTo AudienceFolder
    | SelectAudience AudienceType
    | ChangeSearch String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case model of
        DecodeOk audiences ->
            --{ searchStr, selectedType, authored, curated, shared }
            case msg of
                ChangeSearch newStr ->
                    ( DecodeOk <| { audiences | searchStr = newStr }, Cmd.none )

                SelectAudience newType ->
                    ( DecodeOk <| { audiences | selectedType = newType, authored = audiences.authored |> goRoot, curated = audiences.curated |> goRoot }, Cmd.none )

                GoUp ->
                    case audiences.selectedType of
                        Authored ->
                            ( DecodeOk <| { audiences | authored = audiences.authored |> goUp }, Cmd.none )

                        Curated ->
                            ( DecodeOk <| { audiences | curated = audiences.curated |> goUp }, Cmd.none )

                        -- Won't happen
                        Shared ->
                            ( DecodeOk <| audiences, Cmd.none )

                GoTo folder ->
                    case audiences.selectedType of
                        Authored ->
                            ( DecodeOk <| { audiences | authored = audiences.authored |> goTo folder }, Cmd.none )

                        Curated ->
                            ( DecodeOk <| { audiences | curated = audiences.curated |> goTo folder }, Cmd.none )

                        -- Won't happen
                        Shared ->
                            ( DecodeOk <| audiences, Cmd.none )

        DecodeFailed _ ->
            ( model, Cmd.none )


goUp : AudienceBrowser -> AudienceBrowser
goUp (AudienceBrowser folders audiences fs) =
    AudienceBrowser folders audiences (fs |> FS.goUp)


goRoot : AudienceBrowser -> AudienceBrowser
goRoot (AudienceBrowser folders audiences fs) =
    AudienceBrowser folders audiences (fs |> FS.goRoot)


goTo : AudienceFolder -> AudienceBrowser -> AudienceBrowser
goTo folder (AudienceBrowser folders audiences fs) =
    let
        newSubFolders =
            \_ -> List.filter (AudienceFolder.isParent folder) folders |> List.sortBy .name

        newSubAudiences =
            \_ -> List.filter (Audience.isParent folder) audiences |> List.sortBy .name

        newFs =
            fs |> FS.goTo folder |> FS.expandFolder newSubFolders newSubAudiences
    in
    AudienceBrowser folders audiences newFs



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

        DecodeOk { searchStr, selectedType, authored, curated, shared } ->
            let
                audienceBrowser =
                    case selectedType of
                        Authored ->
                            viewCurrentLevel searchStr authored selectedType

                        Curated ->
                            viewCurrentLevel searchStr curated selectedType

                        Shared ->
                            div [ css [ browser ] ]
                                (List.map (viewAudience selectedType) shared)
            in
            div []
                [ inputWithIcon "🔎" [ value searchStr, onInput ChangeSearch ] []
                , audienceBrowser
                , viewAudienceTypeSelector selectedType
                ]


inputWithIcon : String -> List (Attribute msg) -> List (Html msg) -> Html msg
inputWithIcon icon attributes c =
    div [ css [ inputWrapper ] ]
        [ div [ css [ inputIcon ] ] [ text icon ]
        , input (css [ searchInputCss ] :: attributes) c
        ]


viewAudienceTypeSelector : AudienceType -> Html Msg
viewAudienceTypeSelector audienceType =
    let
        isAuthored =
            audienceType == Authored

        isShared =
            audienceType == Shared

        isCurated =
            audienceType == Curated
    in
    div [ css [ Css.displayFlex ] ]
        [ viewAudienceType "Authored" Authored isAuthored
        , viewAudienceType "Shared" Shared isShared
        , viewAudienceType "Curated" Curated isCurated
        ]


viewAudienceType : String -> AudienceType -> Bool -> Html Msg
viewAudienceType label audienceType selected =
    div [ onClick <| SelectAudience audienceType, css [ audienceTypeCss, audienceTypeSelected selected, audienceColor audienceType ] ]
        [ text label ]


viewCurrentLevel : String -> AudienceBrowser -> AudienceType -> Html Msg
viewCurrentLevel searchStr (AudienceBrowser _ _ fs) audienceType =
    let
        subFolders =
            fs |> FS.subFolders

        subAudiences =
            fs |> FS.subFiles |> List.filter (includes (String.toLower searchStr) << String.toLower << .name)
    in
    div [ css [ browser ] ]
        [ viewCurrentFolder audienceType (fs |> FS.currentFolder) (List.length subFolders + List.length subAudiences)
        , div []
            (List.map (viewAudienceFolder audienceType) subFolders)
        , div []
            (List.map (viewAudience audienceType) subAudiences)
        ]


includes : String -> String -> Bool
includes s1 s2 =
    case s1 of
        "" ->
            True

        _ ->
            String.indexes s1 s2 |> List.length |> (/=) 0


viewCurrentFolder : AudienceType -> Maybe AudienceFolder -> Int -> Html Msg
viewCurrentFolder audienceType maybeFolder filesLength =
    case maybeFolder of
        Just folder ->
            div [ onClick GoUp, css [ folderCss True audienceType ] ]
                [ text folder.name
                , span [ css [ folderSize audienceType ] ] [ text <| String.fromInt filesLength ]
                ]

        Nothing ->
            div [] []


viewAudience : AudienceType -> Audience -> Html Msg
viewAudience audienceType audience =
    div [ css [ fileCss audienceType ] ]
        [ text audience.name ]


viewAudienceFolder : AudienceType -> AudienceFolder -> Html Msg
viewAudienceFolder audienceType folder =
    div [ onClick (GoTo folder), css [ folderCss False audienceType ] ]
        [ text folder.name ]



-- Css


inputIcon : Css.Style
inputIcon =
    Css.batch
        [ Css.position Css.absolute
        , Css.left (Css.px 10)
        ]


inputWrapper : Css.Style
inputWrapper =
    Css.batch
        [ Css.displayFlex
        , Css.alignItems Css.center
        ]


searchInputCss : Css.Style
searchInputCss =
    Css.batch
        [ Css.margin (Css.px 5)
        , Css.width (Css.px 245)
        , Css.height (Css.px 35)
        , Css.fontSize (Css.px 19)
        , Css.borderRadius (Css.px 5)
        , Css.paddingLeft (Css.px 30)
        ]


audienceTypeCss : Css.Style
audienceTypeCss =
    Css.batch
        [ Css.fontSize (Css.px 19)
        , Css.padding (Css.px 10)
        , Css.borderRadius (Css.px 5)
        , Css.margin (Css.px 5)
        , Css.color (Css.hex "#ffffff")
        , Css.cursor Css.pointer
        ]


audienceTypeSelected : Bool -> Css.Style
audienceTypeSelected isSelected =
    if isSelected then
        Css.batch
            [ Css.boxShadow5 (Css.px 0) (Css.px 0) (Css.px 0) (Css.px 2) (Css.hex "#000000") ]

    else
        Css.batch
            []


browser : Css.Style
browser =
    Css.batch
        [ Css.overflowY Css.auto
        , Css.height (Css.vh 86)
        ]


fileCss : AudienceType -> Css.Style
fileCss audienceType =
    Css.batch
        [ audienceColor audienceType
        , Css.width (Css.px 240)
        , Css.color (Css.hex "#ffffff")
        , Css.fontSize (Css.px 19)
        , Css.padding (Css.px 20)
        , Css.borderRadius (Css.px 5)
        , Css.margin (Css.px 5)
        ]


folderCss : Bool -> AudienceType -> Css.Style
folderCss isOpen audienceType =
    let
        content =
            if isOpen then
                "\"🗁\""

            else
                "\"🗀\""
    in
    Css.batch
        [ fileCss audienceType
        , Css.cursor Css.pointer
        , Css.hover [ Css.property "filter" "brightness(90%)" ]
        , Css.after
            [ Css.property "content" content
            , Css.float Css.left
            , Css.marginTop (Css.px -4)
            , Css.marginRight (Css.px 8)
            ]
        ]


folderSize : AudienceType -> Css.Style
folderSize audienceType =
    Css.batch
        [ Css.float Css.right
        , audienceDarkerColor audienceType
        , Css.color (Css.hex "#ffffff")
        , Css.borderRadius (Css.px 4)
        , Css.paddingRight (Css.px 6)
        , Css.paddingLeft (Css.px 6)
        ]


audienceColor : AudienceType -> Css.Style
audienceColor audienceType =
    case audienceType of
        Authored ->
            Css.backgroundColor (Css.hex "#f08080")

        Shared ->
            Css.backgroundColor (Css.hex "#ffbf00")

        Curated ->
            Css.backgroundColor (Css.hex "#5f9ea0")


audienceDarkerColor : AudienceType -> Css.Style
audienceDarkerColor audienceType =
    case audienceType of
        Authored ->
            Css.backgroundColor (Css.hex "#904d4d")

        Shared ->
            Css.backgroundColor (Css.hex "#997300")

        Curated ->
            Css.backgroundColor (Css.hex "#3d6566")
