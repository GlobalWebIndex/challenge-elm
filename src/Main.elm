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


type alias Model =
    Result String GoodModel


{-| The audiences and folders are assigned new IDs in the parser.
The IDs are the array indexes. Root items are given a negative parent
ID. This design takes advantage of fast array lookups.

Folders are given the lowest IDs, then audiences. Each part can be got by slicing the array using 'firstAudienceId'.

If an array lookup fails then the item is root.

This design is inspired by the book Data-Oriented Design by
Richard Fabian, see <https://www.dataorienteddesign.com/dodbook> .
It's an idea from game dev that says that using tabular data
structures gives better performance. I am experimenting with using
it in high-level languages, like Elm and Go. I am finding so far
that it gives a really elegant and minimal internal state.

-}
type alias GoodModel =
    { names : Array.Array String
    , parents : Array.Array Int
    , firstAudienceId : Int
    , currentLevel : Int
    }


view : Model -> Html.Html Msg
view model =
    case model of
        Err err ->
            Html.text <| "internal error: " ++ err

        Ok good ->
            viewGood good


viewGood : GoodModel -> Html.Html Msg
viewGood model =
    breadcrumb model
        :: (foldersView model ++ audiencesView model)
        |> Html.div [ Hat.id "container" ]


breadcrumb : GoodModel -> Html.Html Msg
breadcrumb model =
    Html.div [] <|
        List.map (nonEndCrumb model.names) (getCrumbIds model)
            ++ [ endCrumb model.names model.currentLevel ]


nonEndCrumb : Array.Array String -> Int -> Html.Html Msg
nonEndCrumb folderNames level =
    Html.button [ Hev.onClick <| FolderClick level ]
        [ Html.text <| folderName folderNames level ]


endCrumb : Array.Array String -> Int -> Html.Html Msg
endCrumb folderNames level =
    Html.span
        []
        [ Html.text <| folderName folderNames level ]


folderName : Array.Array String -> Int -> String
folderName folderNames level =
    case Array.get level folderNames of
        Nothing ->
            "Home"

        Just name ->
            name


getCrumbIds : GoodModel -> List Int
getCrumbIds { currentLevel, parents } =
    getCrumbIdsHelp parents ( [], currentLevel )


getCrumbIdsHelp : Array.Array Int -> ( List Int, Int ) -> List Int
getCrumbIdsHelp parents ( crumbs, currentLevel ) =
    case Array.get currentLevel parents of
        Nothing ->
            crumbs

        Just parent ->
            getCrumbIdsHelp parents ( parent :: crumbs, parent )


foldersView : GoodModel -> List (Html.Html Msg)
foldersView model =
    List.map (oneFolderView model.names) (getFolders model)


getFolders : GoodModel -> List Int
getFolders { currentLevel, parents, firstAudienceId } =
    Array.foldl
        (\candidateParent ( i, is ) ->
            ( i + 1
            , if currentLevel == candidateParent then
                i :: is

              else
                is
            )
        )
        ( 0, [] )
        (Array.slice 0 firstAudienceId parents)
        |> Tuple.second


oneFolderView : Array.Array String -> Int -> Html.Html Msg
oneFolderView names folderId =
    Html.button
        [ Hev.onClick <| FolderClick folderId ]
        [ Html.text <| folderName names folderId ]


audiencesView : GoodModel -> List (Html.Html Msg)
audiencesView model =
    List.map (oneAudienceView model.names) <| getAudiences model


getAudiences : GoodModel -> List Int
getAudiences { currentLevel, firstAudienceId, parents } =
    Array.foldl
        (\candidateParent ( i, is ) ->
            ( i + 1
            , if currentLevel == candidateParent then
                i :: is

              else
                is
            )
        )
        ( firstAudienceId, [] )
        (Array.slice firstAudienceId (Array.length parents) parents)
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


{-| It's sad to have this. It arises because the type system can't
guarantee that the parent IDs all have names.
-}
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
        FolderClick level ->
            { model | currentLevel = level }


init : Model
init =
    case P.parse F.audienceFoldersJSON A.audiencesJSON of
        Err err ->
            Err err

        Ok parsed ->
            Ok
                { names = parsed.names
                , parents = parsed.parents
                , firstAudienceId = parsed.firstAudienceId
                , currentLevel = P.rootId
                }
