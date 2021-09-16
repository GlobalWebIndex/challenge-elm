module Main exposing (main)

import Array
import Browser
import Data.Audience as A
import Data.AudienceFolder as F
import DataParser as P
import Html
import Html.Attributes as Hat
import Html.Events as Hev


main : Program () Model Msg
main =
    Browser.sandbox { init = init, view = view, update = update }


type Msg
    = FolderClick Int
    | GoUpClick


type alias Model =
    Result String GoodModel


{-| The audiences and folders are assigned new IDs in the parser.
The IDs are the array indexes. Root items are given the highest IDs
so that _Names is longer than _Parents by the number of root items.
So the first length(_Parents) items in _Names and \*Parents
correspond. This design takes advantage of fast lookups for array
items.

The downside of the design is that there is no guarantee in the
type system that the parent IDs in _Parents are valid array indexes
in _Names. This means that failing name lookup has to be handled in
the main logic rather than in the parser.

This design is inspired by the book Data-Oriented Design by
Richard Fabian, see <https://www.dataorienteddesign.com/dodbook> .
It's an idea from game dev that says that using tabular data
structures gives better performance. I am experimenting with using
it in high-level languages, like Elm and Go. I am finding so far
that it gives a really elegant and minimal internal state.

-}
type alias GoodModel =
    { audienceNames : Array.Array String
    , audienceParents : Array.Array Int
    , folderNames : Array.Array String
    , folderParents : Array.Array Int
    , currentLevel : Level
    }


type Level
    = Root
    | Parent Int


view : Model -> Html.Html Msg
view model =
    case model of
        Err err ->
            Html.text <| "internal error: " ++ err

        Ok good ->
            viewGood good


viewGood : GoodModel -> Html.Html Msg
viewGood model =
    goUpView model
        :: (foldersView model ++ audiencesView model)
        |> Html.div [ Hat.id "container" ]


nothing : Html.Html Msg
nothing =
    Html.text ""


goUpView : GoodModel -> Html.Html Msg
goUpView model =
    if model.currentLevel == Root then
        nothing

    else
        Html.button [ Hev.onClick GoUpClick ] [ Html.text "Go up" ]


foldersView : GoodModel -> List (Html.Html Msg)
foldersView model =
    List.map (oneFolderView model.folderNames) <|
        case model.currentLevel of
            Root ->
                List.range
                    (Array.length model.folderParents)
                    (Array.length model.folderNames - 1)

            Parent parentId ->
                Array.foldl
                    (\candidateParent ( i, is ) ->
                        ( i + 1
                        , if parentId == candidateParent then
                            i :: is

                          else
                            is
                        )
                    )
                    ( 0, [] )
                    model.folderParents
                    |> Tuple.second


oneFolderView : Array.Array String -> Int -> Html.Html Msg
oneFolderView names folderId =
    Html.button
        [ Hev.onClick <| FolderClick folderId ]
        [ Html.text <|
            case Array.get folderId names of
                Nothing ->
                    nonExistentFolder folderId

                Just name ->
                    name
        ]


nonExistentFolder : Int -> String
nonExistentFolder i =
    String.concat
        [ ">>>>>>>>>>>>>>>>>Internal error: folder with ID "
        , String.fromInt i
        , " doesn't have a name<<<<<<<<<<<<<<<<<<"
        ]


audiencesView : GoodModel -> List (Html.Html Msg)
audiencesView model =
    List.map (oneAudienceView model.audienceNames) <|
        case model.currentLevel of
            Root ->
                List.range
                    (Array.length model.audienceParents)
                    (Array.length model.audienceNames - 1)

            Parent parentId ->
                Array.foldl
                    (\candidateParent ( i, is ) ->
                        ( i + 1
                        , if parentId == candidateParent then
                            i :: is

                          else
                            is
                        )
                    )
                    ( 0, [] )
                    model.audienceParents
                    |> Tuple.second


oneAudienceView : Array.Array String -> Int -> Html.Html Msg
oneAudienceView names audienceId =
    Html.span
        []
        [ Html.text <|
            case Array.get audienceId names of
                Nothing ->
                    nonExistentAudience audienceId

                Just name ->
                    name
        ]


nonExistentAudience : Int -> String
nonExistentAudience i =
    String.concat
        [ ">>>>>>>>>>>>>>>>Internal error: audience with ID "
        , String.fromInt i
        , " doesn't have a name<<<<<<<<<<<<<<<<<<<<<"
        ]


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
            { model | currentLevel = Parent id }

        GoUpClick ->
            case model.currentLevel of
                Root ->
                    model

                Parent parent ->
                    goUp model parent


goUp : GoodModel -> Int -> GoodModel
goUp model parent =
    case Array.get parent model.folderParents of
        Nothing ->
            { model | currentLevel = Root }

        Just grandParent ->
            { model | currentLevel = Parent grandParent }


init : Model
init =
    case P.parse F.audienceFoldersJSON A.audiencesJSON of
        Err err ->
            Err err

        Ok parsed ->
            Ok
                { audienceNames = parsed.audienceNames
                , audienceParents = parsed.audienceParents
                , folderNames = parsed.folderNames
                , folderParents = parsed.folderParents
                , currentLevel = Root
                }
