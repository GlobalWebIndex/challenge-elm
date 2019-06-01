module View.AudienceBrowser exposing (Model, Msg(..), audienceBrowser, showAudience, showFilesAndFolders, showFolder, update)

import Browser.Dom exposing (setViewportOf)
import Css as Css exposing (..)
import Data.Audience exposing (Audience, AudienceType)
import Data.FileSystem exposing (FileSystem(..), sortWith)
import Data.Focused.FileSystem as FFS exposing (FileSystemFocused)
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
                    maybeUpdate (FFS.stepDown n) focusedFileSystem
              }
            , scroolAudienceBrowserToTop
            )

        StepUp ->
            ( { model
                | focusedFileSystem =
                    maybeUpdate FFS.stepUp focusedFileSystem
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

            isRoot =
                fragments == []
        in
        case focusedFolder of
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
                    , showFilesAndFolders isRoot model.filter folderContent
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
        [ filterButton "Authored" <| webIcon iconSize iconSize "https://img.icons8.com/material-outlined/48/000000/user.png"
        , separator
        , filterButton "Shared" <| webIcon iconSize iconSize "https://img.icons8.com/material-outlined/48/000000/share.png"
        , separator
        , filterButton "Default" <| webIcon iconSize iconSize "https://img.icons8.com/material-outlined/48/000000/conference-call.png"
        ]


separator =
    div
        [ css
            [ width (px 2)
            , backgroundColor colors.lightGrey
            ]
        ]
        []


filterButton name icon =
    div
        [ css
            [ displayFlex
            , flexDirection column
            , alignItems center
            , fontSize (px 10)
            , fontFamily sansSerif
            , color colors.link
            ]
        ]
        [ icon
        , text name
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


showFolder : Int -> String -> H.Html Msg
showFolder index name =
    div
        [ onClick <| StepDown index
        , css
            [ fileFolderStyle.other
            , backgroundColor colors.folderBGC
            , paddingLeft <| px fileFolderStyle.textLeftPadding
            , displayFlex
            , alignItems center
            , border3 (px 1) solid colors.folderBGC
            , cursor pointer
            ]
        ]
        [ div [ css [ position relative, top (px 0.1) ] ]
            [ webIcon fileFolderStyle.iconSize fileFolderStyle.iconSize "https://img.icons8.com/ultraviolet/48/000000/folder-invoices.png" ]
        , div [ css [ paddingLeft <| px fileFolderStyle.textLeftPadding ] ]
            [ ellipsifiedText name ]
        ]


showFilesAndFolders : Bool -> AudienceType -> List (FileSystem Audience) -> H.Html Msg
showFilesAndFolders isRoot audienceType folderContent =
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

                            Folder name _ ->
                                showFolder position name
                )
                (List.filter
                    (\fs ->
                        case fs of
                            File { type_ } ->
                                True

                            Folder _ _ ->
                                True
                    )
                    folderContent
                )


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
