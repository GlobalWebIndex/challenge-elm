module Main exposing (main)

import Browser
import Data.Audience as A
import Data.AudienceFolder as F
import DataParser as P
import Dict
import Html
import Html.Attributes as Hat
import Html.Events as Hev
import Set


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


type Msg
    = FolderClick ( Int, String )
    | GoUpClick


type alias Model =
    Result String GoodModel


{-| I made the assumption that names are unique within a folder. This
means that audience IDs are not needed, as they are uniquely defined
by the combination of their name and containing folder.

This model design is inspired by the book Data-Oriented Design by
Richard Fabian, see <https://www.dataorienteddesign.com/dodbook> .
It's an idea from game dev that says that using tabular data
structures gives better performance. I am experimenting with using
it in high-level languages, like Elm and Go. I am finding so far
that it gives a really elegant and minimal internal state.

-}
type alias GoodModel =
    { rootAudiences : Set.Set String

    -- An audience that is not root is uniquely defined by its
    -- name and its parent. Parents always have names.
    , subAudiences : Set.Set ( AudienceName, Folder )
    , rootFolders : Set.Set Folder
    , subFolders : Dict.Dict Folder Folder
    , currentLevel : Level
    }


type alias AudienceName =
    String


type alias Folder =
    ( Int, String )


type Level
    = Root
    | Parent Folder


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
        goUpView model
            :: (foldersView model ++ audiencesView model)


nothing : Html.Html Msg
nothing =
    Html.text ""


goUpView : GoodModel -> Html.Html Msg
goUpView model =
    if model.currentLevel == Root then
        nothing

    else
        Html.button
            [ Hev.onClick GoUpClick ]
            [ Html.text "Go up" ]


foldersView : GoodModel -> List (Html.Html Msg)
foldersView model =
    List.map oneFolderView <|
        case model.currentLevel of
            Root ->
                Set.toList <| model.rootFolders

            Parent parentId ->
                Dict.keys <|
                    Dict.filter
                        (isChildFolderOf parentId)
                        model.subFolders


isChildFolderOf : ( Int, String ) -> ( Int, String ) -> ( Int, String ) -> Bool
isChildFolderOf candidateParent _ parent =
    candidateParent == parent


isChildAudienceOf : ( Int, String ) -> ( String, ( Int, String ) ) -> Bool
isChildAudienceOf parent ( _, candidateParent ) =
    parent == candidateParent


oneFolderView : ( Int, String ) -> Html.Html Msg
oneFolderView ( folderId, name ) =
    Html.button
        [ Hev.onClick <| FolderClick ( folderId, name ) ]
        [ Html.text name ]


audiencesView : GoodModel -> List (Html.Html Msg)
audiencesView model =
    List.map oneAudienceView <|
        Set.toList <|
            case model.currentLevel of
                Root ->
                    model.rootAudiences

                Parent parent ->
                    Set.map Tuple.first <|
                        Set.filter
                            (isChildAudienceOf parent)
                            model.subAudiences


oneAudienceView : String -> Html.Html Msg
oneAudienceView name =
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
            { model | currentLevel = Parent id }

        GoUpClick ->
            case model.currentLevel of
                Root ->
                    model

                Parent parent ->
                    goUp model parent


goUp : GoodModel -> ( Int, String ) -> GoodModel
goUp model parent =
    case Dict.get parent model.subFolders of
        Nothing ->
            { model | currentLevel = Root }

        Just grandParent ->
            { model | currentLevel = Parent grandParent }


init : Model
init =
    case P.parse F.audienceFoldersJSON A.audiencesJSON of
        Err err ->
            Err err

        Ok { rootAudiences, subAudiences, rootFolders, subFolders } ->
            Ok
                { rootAudiences = rootAudiences
                , subAudiences = subAudiences
                , rootFolders = rootFolders
                , subFolders = subFolders
                , currentLevel = Root
                }
