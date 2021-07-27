module Main exposing (..)

import Browser
import Data.Audience as A
import Data.AudienceFolder as F
import Dict
import Html
import Html.Attributes as Hat
import Html.Events as Hev
import Json.Decode as Jd
import Parser as P
import Set


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


type Msg
    = FolderClick Int
    | GoUpClick


type alias Model =
    Result String GoodModel


{-| The integer IDs are not the same as the ones provided in the data.
It seems likely that the provided IDs are row IDS from the database,
and that folders and audiences are kept in different tables, so
the IDs may well conflict. A globally unique ID is needed here.

This model design is inspired by the book Data-Oriented Design by
Richard Fabian, see <https://www.dataorienteddesign.com/dodbook> .
It's an idea from game dev that says that using tabular data
structures gives better performance. I am experimenting with using
it in high-level languages, like Elm and Go. I am finding so far
that it gives a really elegant and minimal internal state.

-}
type alias GoodModel =
    -- The keys are child IDs and the values are parent IDs. Root
    -- items are not included. If a map lookup fails then the item
    -- is root, so there are no internal errors caused by failing map
    -- lookups. The reason for using a dictionary rather than a list
    -- is to enforce that a child can have only one parent.
    { parents : Dict.Dict Int Int

    -- As well as providing the AudienceType for audiences, this is
    -- used to detect whether something is a folder or an audience.
    , audiences : Dict.Dict Int A.AudienceType

    -- The IDs and names for all the folders and audiences. This should
    -- only be mapped over, not use for lookup. Lookup is bad in this
    -- case because failure will have to be handled, and it shouldn't
    -- ever be possible to have an ID without a name.
    , all : Dict.Dict Int String
    , parent : Parent
    }


type Parent
    = Root
    | Parent Int


type OneItem
    = OneFolder Int
    | OneAudience Int


view : Model -> Html.Html Msg
view model =
    case model of
        Err err ->
            Html.text <| "internal error: " ++ err

        Ok good ->
            viewGood good


viewGood : GoodModel -> Html.Html Msg
viewGood model =
    Html.div
        [ Hat.id "container" ]
    <|
        List.concat
            [ goUpView model
            , foldersView model
            , audiencesView model
            ]


goUpView : GoodModel -> List (Html.Html Msg)
goUpView model =
    if model.parent == Root then
        []

    else
        [ Html.button
            [ Hev.onClick GoUpClick ]
            [ Html.text "Go up" ]
        ]


foldersView : GoodModel -> List (Html.Html Msg)
foldersView model =
    List.map oneFolderView <|
        Dict.toList <|
            Dict.filter (isFolder model.audiences) <|
                Dict.filter (isChildOf model.parents model.parent) model.all


isChildOf : Dict.Dict Int Int -> Parent -> Int -> String -> Bool
isChildOf parents parent potentialChild _ =
    case ( Dict.get potentialChild parents, parent ) of
        ( Nothing, Root ) ->
            True

        ( Nothing, Parent _ ) ->
            False

        ( Just potentialParent, Parent p ) ->
            potentialParent == p

        ( Just _, Root ) ->
            False


isFolder : Dict.Dict Int A.AudienceType -> Int -> String -> Bool
isFolder audiences id _ =
    Dict.get id audiences == Nothing


oneFolderView : ( Int, String ) -> Html.Html Msg
oneFolderView ( folderId, name ) =
    Html.button
        [ Hev.onClick <| FolderClick folderId ]
        [ Html.text name ]


audiencesView : GoodModel -> List (Html.Html Msg)
audiencesView model =
    List.map oneAudienceView <|
        Dict.toList <|
            Dict.filter (isAudience model.audiences) <|
                Dict.filter (isChildOf model.parents model.parent) model.all


isAudience : Dict.Dict Int A.AudienceType -> Int -> String -> Bool
isAudience audiences id _ =
    not <| Dict.get id audiences == Nothing


oneAudienceView : ( Int, String ) -> Html.Html Msg
oneAudienceView ( _, name ) =
    Html.span [] [ Html.text name ]


update : Msg -> Model -> Model
update msg model =
    case model of
        Err _ ->
            model

        Ok ok ->
            Ok <| updateGood msg ok


updateGood : Msg -> GoodModel -> GoodModel
updateGood msg model =
    case msg of
        FolderClick id ->
            { model | parent = Parent id }

        GoUpClick ->
            case model.parent of
                Root ->
                    model

                Parent parentId ->
                    goUp model parentId


goUp : GoodModel -> Int -> GoodModel
goUp model parent =
    case Dict.get parent model.parents of
        Nothing ->
            { model | parent = Root }

        Just grandParent ->
            { model | parent = Parent grandParent }


init : Model
init =
    case P.parse F.audienceFoldersJSON A.audiencesJSON of
        Err err ->
            Err err

        Ok { parents, audiences, all } ->
            Ok
                { parents = parents
                , audiences = audiences
                , all = all
                , parent = Root
                }
