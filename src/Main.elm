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


type Model
    = Bad String
    | Good GoodModel


type alias GoodModel =
    { parents : Dict.Dict Int Int
    , folders : Set.Set Int
    , audiences : Dict.Dict Int A.AudienceType
    , all : Dict.Dict Int String
    , parent : Parent
    }


type Parent
    = Root
    | Parent Int


type OneItem
    = OneFolder Int
    | OneAudience Int


getOneTopLevelFolderId : List F.AudienceFolder -> Maybe Int
getOneTopLevelFolderId folders =
    case folders of
        [] ->
            Nothing

        { parent } :: olders ->
            case parent of
                Nothing ->
                    getOneTopLevelFolderId olders

                Just id ->
                    Just id


getOneTopLevelAudienceId : List A.Audience -> Maybe Int
getOneTopLevelAudienceId audiences =
    case audiences of
        [] ->
            Nothing

        { folder } :: udiences ->
            case folder of
                Nothing ->
                    getOneTopLevelAudienceId udiences

                Just id ->
                    Just id


view : Model -> Html.Html Msg
view model =
    case model of
        Bad err ->
            Html.text <| "internal error: " ++ err

        Good good ->
            viewGood good


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
            Dict.filter (isFolder model.folders) <|
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


isFolder : Set.Set Int -> Int -> String -> Bool
isFolder folders id _ =
    Set.member id folders


oneFolderView : ( Int, String ) -> Html.Html Msg
oneFolderView ( folderId, name ) =
    Html.button
        [ Hev.onClick <| FolderClick folderId ]
        [ Html.text name ]


audiencesView : GoodModel -> List (Html.Html Msg)
audiencesView model =
    List.map oneAudienceView <|
        Dict.toList <|
            Dict.filter (isAudience model.folders) <|
                Dict.filter (isChildOf model.parents model.parent) model.all


isAudience : Set.Set Int -> Int -> String -> Bool
isAudience folders id _ =
    not <| Set.member id folders


oneAudienceView : ( Int, String ) -> Html.Html Msg
oneAudienceView ( _, name ) =
    Html.span [] [ Html.text name ]


update : Msg -> Model -> Model
update msg model =
    case model of
        Bad _ ->
            model

        Good ok ->
            Good <| updateGood msg ok


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


getTopLevel : Dict.Dict Int String -> Dict.Dict Int Int -> Dict.Dict Int String
getTopLevel all parents =
    Dict.filter (isRoot parents) all


isRoot : Dict.Dict Int Int -> Int -> String -> Bool
isRoot parents child _ =
    Dict.get child parents == Nothing


getChildrenOf : Int -> Dict.Dict Int String -> Dict.Dict Int Int -> Dict.Dict Int String
getChildrenOf parent all parents =
    Dict.filter (getChildrenHelp (getChildIds parent parents)) all


getChildrenHelp : Set.Set Int -> Int -> String -> Bool
getChildrenHelp childIds potentialChild _ =
    Set.member potentialChild childIds


getChildIds : Int -> Dict.Dict Int Int -> Set.Set Int
getChildIds parent parents =
    Set.fromList <|
        Dict.keys <|
            Dict.filter (parentIs parent) parents


parentIs : Int -> Int -> Int -> Bool
parentIs parent _ potentialParent =
    parent == potentialParent


getTopLevelHelp : Dict.Dict Int Int -> ( Int, String ) -> Bool
getTopLevelHelp parents ( id, _ ) =
    Dict.get id parents == Nothing


getFolderChildrenOf : Int -> Dict.Dict Int F.AudienceFolder -> Set.Set Int
getFolderChildrenOf id folders =
    Set.fromList <|
        Dict.keys <|
            Dict.filter (getFolderChildrenHelp id) folders


getFolderChildrenHelp id _ { parent } =
    case parent of
        Nothing ->
            False

        Just p ->
            p == id


getAudienceChildrenOf : Int -> Dict.Dict Int A.Audience -> Set.Set Int
getAudienceChildrenOf id audiences =
    Set.fromList <|
        Dict.keys <|
            Dict.filter (getAudienceChildrenHelp id) audiences


getAudienceChildrenHelp : Int -> Int -> A.Audience -> Bool
getAudienceChildrenHelp id _ { folder } =
    case folder of
        Nothing ->
            False

        Just f ->
            f == id


zeroModel : GoodModel
zeroModel =
    { parents = Dict.empty
    , folders = Set.empty
    , audiences = Dict.empty
    , all = Dict.empty
    , parent = Root
    }


init : Model
init =
    case P.parse F.audienceFoldersJSON A.audiencesJSON of
        Err err ->
            Bad err

        Ok { parents, folders, audiences, all } ->
            Good
                { parents = parents
                , folders = folders
                , audiences = audiences
                , all = all
                , parent = Root
                }
