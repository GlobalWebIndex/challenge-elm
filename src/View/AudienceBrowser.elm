module View.AudienceBrowser exposing (Model, Msg(..), audienceBrowser, showAudience, showFilesAndFolders, showFolder, update)

import Browser.Dom exposing (setViewportOf)
import Css as Css exposing (..)
import Data.Audience exposing (Audience, AudienceType(..))
import Data.FileSystem exposing (FileSystem(..), filterFiles, flatten, sortWith, toList)
import Data.Focused.FileSystem as FSF exposing (FileSystemFocused)
import Html exposing (Html)
import Html.Styled as H exposing (button, div, img, text)
import Html.Styled.Attributes as A exposing (css)
import Html.Styled.Events as E exposing (keyCode, on, onClick)
import Task



-- MODEL


type alias Model =
    { focusedFileSystem : FileSystemFocused Audience
    , filter : AudienceType
    }



-- MSG


type Msg
    = StepDown Int
    | StepUp
    | ChangeFilter AudienceType
    | NoOp



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        { filter, focusedFileSystem } =
            model
    in
    case msg of
        NoOp ->
            ( model, Cmd.none )

        StepDown n ->
            ( { model
                | focusedFileSystem =
                    maybeUpdate (FSF.stepDown n) focusedFileSystem
              }
            , scroolAudienceBrowserToTop
            )

        StepUp ->
            ( { model
                | focusedFileSystem =
                    maybeUpdate FSF.stepUp focusedFileSystem
              }
            , scroolAudienceBrowserToTop
            )

        ChangeFilter type_ ->
            ( { focusedFileSystem = (FSF.focus << FSF.defocus) focusedFileSystem
              , filter =
                    type_
              }
            , scroolAudienceBrowserToTop
            )


scroolAudienceBrowserToTop : Cmd Msg
scroolAudienceBrowserToTop =
    Task.attempt (always NoOp) (setViewportOf "fileAndFoldersContainer" 0 0)


maybeUpdate : (a -> Maybe a) -> a -> a
maybeUpdate updater value =
    Maybe.withDefault value <| Maybe.andThen updater (Just value)



-- VIEW


audienceBrowser : Model -> Html Msg
audienceBrowser model =
    H.toUnstyled <|
        let
            ( fragments, focusedFolder ) =
                model.focusedFileSystem

            filter =
                model.filter

            filteredFocusedFolder =
                let
                    filtered =
                        filterFiles (\audience -> True) focusedFolder
                in
                if filter == Shared then
                    flatten filtered

                else
                    filtered

            isRoot =
                fragments == []
        in
        case filteredFocusedFolder of
            File _ ->
                text "ERROR: You can only look inside of folder not file"

            Folder name folderContent ->
                div
                    [ css
                        [ displayFlex
                        , flexDirection column
                        , maxWidth browserWidth
                        , border3 (px 2) solid colors.lightGrey
                        , borderRadius (px 5)
                        , padding (px 2)
                        , fontFamily sansSerif
                        ]
                    ]
                <|
                    [ folderName isRoot name
                    , showFilesAndFolders isRoot folderContent
                    , filterButtons model.filter
                    ]


folderName : Bool -> String -> H.Html Msg
folderName isRoot name =
    div
        [ css
            [ displayFlex
            , justifyContent center
            , color colors.grey
            , fontSize (px 14)
            , fontWeight bold
            , paddingTop (px 7)
            , paddingBottom (px 7)
            , borderBottom3 (px 2) solid colors.lightGrey
            ]
        ]
        [ text <|
            if isRoot then
                "Audiences Browser"

            else
                name
        ]


upFolderButton : Bool -> H.Html Msg
upFolderButton isHidden =
    div
        [ onClick StepUp
        , css <|
            [ fileFolderStyle.other
            , paddingLeft <| px fileFolderStyle.textLeftPadding
            , color colors.link
            , border3 (px 1) solid colors.grey
            , displayFlex
            , alignItems center
            , backgroundColor colors.white
            , width (px 195)
            , height (px 14)
            , position sticky
            , top (px 0)
            , cursor pointer
            ]
                ++ (if isHidden then
                        [ visibility hidden ]

                    else
                        []
                   )
        ]
        [ webIcon fileFolderStyle.iconSize fileFolderStyle.iconSize "https://img.icons8.com/material-outlined/48/000000/up3.png"
        , div [ css [ paddingLeft (px fileFolderStyle.textLeftPadding) ] ] [ text " Go back" ]
        ]


filterButtons : AudienceType -> H.Html Msg
filterButtons audienceType =
    let
        iconSize =
            25
    in
    div
        [ css
            [ displayFlex
            , justifyContent spaceAround
            , marginTop (px 4)
            ]
        ]
        [ filterButton Authored audienceType <| webIcon iconSize iconSize "https://img.icons8.com/material-outlined/48/000000/user.png"
        , separator
        , filterButton Shared audienceType <| webIcon iconSize iconSize "https://img.icons8.com/material-outlined/48/000000/share.png"
        , separator
        , filterButton Curated audienceType <| webIcon iconSize iconSize "https://img.icons8.com/material-outlined/48/000000/conference-call.png"
        ]


labelifyAudienceType type_ =
    case type_ of
        Authored ->
            "Authored "

        Shared ->
            "Shared "

        Curated ->
            "Curated"


separator =
    div
        [ css
            [ width (px 2)
            , backgroundColor colors.lightGrey
            ]
        ]
        []


filterButton : AudienceType -> AudienceType -> H.Html Msg -> H.Html Msg
filterButton buttonType chosenType icon =
    div
        [ css <|
            (if buttonType == chosenType then
                [ border3 (px 1) solid colors.link, textDecoration underline ]

             else
                []
            )
                ++ [ displayFlex
                   , flexDirection column
                   , alignItems center
                   , fontSize (px 10)
                   , fontFamily sansSerif
                   , color colors.link
                   , cursor pointer
                   , borderRadius (px 2)
                   , padding (px 5)
                   , width (px 50)
                   ]
        , onClick <| ChangeFilter buttonType
        ]
        [ icon
        , text <| labelifyAudienceType buttonType
        ]


webIcon : Float -> Float -> String -> H.Html Msg
webIcon w h url =
    img
        [ A.src url
        , css
            [ width (px w)
            , height (px h)
            ]
        ]
        []


showAudience : Audience -> H.Html Msg
showAudience audience =
    let
        { name } =
            audience
    in
    div
        [ css
            [ fileFolderStyle.other
            , paddingLeft <| px <| 2 * fileFolderStyle.textLeftPadding + fileFolderStyle.iconSize
            , backgroundColor colors.fileBGC
            , border3 (px 1) solid colors.fileBGC
            ]
        ]
        [ ellipsifiedText name ]


showFolder : Int -> String -> Int -> H.Html Msg
showFolder index name filesCount =
    div
        [ onClick <| StepDown index
        , css
            [ fileFolderStyle.other
            , backgroundColor colors.folderBGC
            , paddingLeft <| px fileFolderStyle.textLeftPadding
            , displayFlex
            , alignItems center
            , justifyContent spaceBetween
            , border3 (px 1) solid colors.folderBGC
            , cursor pointer
            ]
        ]
        [ div [ css [ displayFlex, alignItems center ] ]
            [ div [ css [ position relative, top (px 0.1) ] ]
                [ webIcon fileFolderStyle.iconSize fileFolderStyle.iconSize "https://img.icons8.com/ultraviolet/48/000000/folder-invoices.png" ]
            , div [ css [ paddingLeft <| px fileFolderStyle.textLeftPadding ] ]
                [ ellipsifiedText name ]
            ]
        , div
            [ css
                [ color colors.lightGrey
                , marginRight <| px fileFolderStyle.textLeftPadding
                ]
            ]
            [ text <| "(" ++ String.fromInt filesCount ++ ")" ]
        ]


showFilesAndFolders : Bool -> List (FileSystem Audience) -> H.Html Msg
showFilesAndFolders isRoot folderContent =
    div
        [ css <|
            [ maxHeight browserHeight
            , overflowY scroll
            , overflowX hidden
            , borderBottom3 (px 2) solid colors.lightGrey
            ]
        , A.id "fileAndFoldersContainer"
        ]
    <|
        (if isRoot then
            text ""

         else
            upFolderButton isRoot
        )
            :: List.indexedMap
                (\position ->
                    \fileOrFolder ->
                        case fileOrFolder of
                            File audience ->
                                showAudience audience

                            Folder name contents ->
                                let
                                    filesCount =
                                        List.length <| toList fileOrFolder
                                in
                                -- i dont show folders that contain no files at all
                                if filesCount > 0 then
                                    showFolder position name filesCount

                                else
                                    text ""
                )
                folderContent


ellipsifiedText : String -> H.Html Msg
ellipsifiedText txt =
    let
        maxLength =
            25

        shouldEllipsify =
            String.length txt > maxLength
    in
    div
        [ A.title <|
            if shouldEllipsify then
                txt

            else
                ""
        ]
        [ text <|
            if shouldEllipsify then
                String.left maxLength txt ++ "..."

            else
                txt
        ]


browserWidth =
    px 215


browserHeight =
    px 500


folderIconSize =
    16


fileFolderStyle =
    { iconSize = 16
    , textLeftPadding = 6
    , other =
        batch
            [ marginTop (px 2)
            , borderRadius (px 2)
            , color colors.white
            , paddingTop (px 13)
            , paddingBottom (px 13)
            , fontSize (px 11)
            ]
    }


colors =
    { white = rgb 255 255 255
    , black = rgb 0 0 0
    , grey = rgb 85 85 85
    , lightGrey = rgb 219 219 219
    , link = rgb 40 65 186
    , folderBGC = rgb 40 65 186
    , fileBGC = rgb 128 147 242
    }
