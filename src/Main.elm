module Main exposing (main)

import Css exposing (alignItems, auto, backgroundColor, borderBox, borderRadius, boxSizing, center, color, cursor, default, displayFlex, ellipsis, flexEnd, fontFamilies, fontSize, hex, hidden, justifyContent, listStyleType, margin, marginLeft, maxHeight, minHeight, minWidth, none, overflowX, overflowY, padding, padding2, paddingTop, pointer, px, rgba, textOverflow, width, zero)
import Css.Foreign exposing (body, global)
import Css.Helpers exposing (toCssIdentifier)
import Data.Audience exposing (audiencesDecoder, audiencesJSON)
import Data.AudienceFolder exposing (audienceFoldersDecoder, audienceFoldersJSON)
import Dict
import FontAwesome exposing (edit, folder, folderOpen, icon, useCss)
import Html
import Html.Styled exposing (Html, button, div, fromUnstyled, li, styled, text, toUnstyled, ul)
import Html.Styled.Attributes exposing (class, classList)
import Html.Styled.Events exposing (onClick)
import Json.Decode exposing (decodeString)
import NaturalOrdering


bodyStyleNode : Html msg
bodyStyleNode =
    global
        [ body
            [ backgroundColor (hex "#191e29")
            , color (hex "#b3c4cb")
            , fontFamilies [ "sans-serif" ]
            , boxSizing borderBox
            ]
        ]


type ContentListClasses
    = FolderClass
    | FolderOpenedClass
    | ContentListClass
    | ContentElementClass
    | ContentElementTextClass
    | ContentElementIconClass
    | FolderCountClass
    | AudienceEditIconClass


listStyleNode : Html msg
listStyleNode =
    Css.Foreign.global
        [ Css.Foreign.class ContentListClass
            [ listStyleType none
            , padding2 (px 2) zero
            , backgroundColor (hex "#fff")
            , width (px 300)
            , maxHeight (px 600)
            , overflowY auto
            ]
        , Css.Foreign.class ContentElementClass
            [ borderRadius (px 4), margin (px 6), padding (px 10), minHeight (px 40), displayFlex, alignItems center, fontSize (px 13), color (hex "#e2f1f8"), backgroundColor (hex "#4294ca") ]
        , Css.Foreign.class ContentElementTextClass
            [ textOverflow ellipsis, overflowX hidden ]
        , Css.Foreign.class ContentElementIconClass
            [ minWidth (px 40), displayFlex, justifyContent center ]
        , Css.Foreign.class FolderClass
            [ cursor pointer ]
        , Css.Foreign.class FolderOpenedClass
            [ color (hex "#ecf2f6"), backgroundColor (hex "#346f97"), cursor default ]
        , Css.Foreign.class FolderCountClass
            [ borderRadius (px 4), color (hex "#779aac"), backgroundColor (hex "#295a78"), padding (px 4), marginLeft (px 6) ]
        , Css.Foreign.class AudienceEditIconClass
            [ marginLeft auto, minWidth (px 30), displayFlex, justifyContent flexEnd ]
        ]


type alias Model =
    { breadcrumbs : List Int
    }


model : Model
model =
    Model []


type Msg
    = Clicked Int
    | GoUp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Clicked id ->
            ( { model | breadcrumbs = id :: model.breadcrumbs }, Cmd.none )

        GoUp ->
            ( { model | breadcrumbs = List.drop 1 model.breadcrumbs }, Cmd.none )


view : Model -> Html.Html Msg
view model =
    let
        currentLevelMaybe =
            List.head model.breadcrumbs

        audienceFolders =
            decodeString audienceFoldersDecoder audienceFoldersJSON
                |> Result.withDefault []

        currentFolderList =
            audienceFolders
                |> List.filter (\item -> Just item.id == currentLevelMaybe)
                |> List.head
                |> Maybe.andThen (\item -> Just [ folderHtml True item ])
                |> Maybe.withDefault []

        audiences =
            decodeString audiencesDecoder audiencesJSON
                |> Result.withDefault []

        currentLevelAudiences =
            audiences
                |> List.filter (\item -> item.folder == currentLevelMaybe)
                |> List.sortWith (NaturalOrdering.compareOn .name)

        currentLevelAudiencesHtml =
            currentLevelAudiences
                |> List.map
                    (\item ->
                        li
                            [ class (toCssIdentifier ContentElementClass) ]
                            [ div [ class (toCssIdentifier ContentElementIconClass) ] []
                            , div [ class (toCssIdentifier ContentElementTextClass) ] [ text <| item.name ]
                            , div [ class (toCssIdentifier AudienceEditIconClass) ]
                                [ fromUnstyled <| icon edit ]
                            ]
                    )

        audiencesInFoldersCounts =
            List.foldl
                (\element accumulator ->
                    case element.folder of
                        Just parentId ->
                            Dict.insert parentId (Dict.get parentId accumulator |> Maybe.withDefault 0 |> (+) 1) accumulator

                        Nothing ->
                            accumulator
                )
                Dict.empty
                audiences

        folderCounts =
            List.foldl
                (\element accumulator ->
                    case element.parent of
                        Just parentId ->
                            Dict.insert parentId (Dict.get parentId accumulator |> Maybe.withDefault 0 |> (+) 1) accumulator

                        Nothing ->
                            accumulator
                )
                audiencesInFoldersCounts
                audienceFolders

        currentLevelAudienceFolders =
            audienceFolders
                |> List.filter (\item -> item.parent == currentLevelMaybe)
                |> List.sortWith (NaturalOrdering.compareOn .name)

        folderHtml opened item =
            let
                count =
                    Dict.get item.id folderCounts |> Maybe.withDefault 0
            in
            li
                [ classList
                    [ ( toCssIdentifier FolderClass, True )
                    , ( toCssIdentifier FolderOpenedClass, opened )
                    , ( toCssIdentifier ContentElementClass, True )
                    ]
                , onClick <| Clicked item.id
                ]
                [ div [ class (toCssIdentifier ContentElementIconClass) ]
                    [ fromUnstyled <|
                        icon <|
                            if opened then
                                folderOpen
                            else
                                folder
                    ]
                , div [ class (toCssIdentifier ContentElementTextClass) ] [ text <| item.name ]
                , div [ class (toCssIdentifier FolderCountClass) ] [ text <| toString count ]
                ]

        currentLevelAudienceFoldersHtml =
            currentLevelAudienceFolders
                |> List.map (folderHtml False)
    in
    styled div
        []
        []
        [ bodyStyleNode
        , fromUnstyled useCss
        , if currentLevelMaybe == Nothing then
            text ""
          else
            div []
                [ button [ onClick GoUp ] [ text "Go up" ] ]
        , currentFolderList
            ++ currentLevelAudienceFoldersHtml
            ++ currentLevelAudiencesHtml
            |> (::) listStyleNode
            |> ul [ class (toCssIdentifier ContentListClass) ]
        ]
        |> toUnstyled


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , init = ( model, Cmd.none )
        }
