module Main exposing (main)

import Data.Audience exposing (Audience, audiencesDecoder)
import Data.AudienceFolder exposing (AudienceFolder, foldersDecoder)
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Json.Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (..)
import Tree exposing (..)


type alias Model =
    ( Tree, List Tree )


type Msg
    = Goto Tree
    | GotoUp


initModel : Model
initModel =
    ( buildTree folders audiences, [] )


handleDecodedResult : Result String (List a) -> List a
handleDecodedResult r =
    case r of
        Ok results ->
            results

        Err err ->
            Debug.log err []


audiences : List Audience
audiences =
    Json.Decode.decodeString audiencesDecoder Data.Audience.audiencesJSON |> handleDecodedResult


folders : List AudienceFolder
folders =
    Json.Decode.decodeString foldersDecoder Data.AudienceFolder.audienceFoldersJSON |> handleDecodedResult


goUpButton : List Tree -> Html Msg
goUpButton t =
    case t of
        x :: xs ->
            Html.div [ class "goup", onClick (GotoUp) ] [ Html.text "Go UP" ]

        [] ->
            Html.text ""


folderButton : Tree -> Html Msg
folderButton tree =
    Html.li [ class "folder", onClick (Goto tree) ] [ Html.text (Tree.name tree) ]


audienceButton : String -> Html Msg
audienceButton name =
    Html.li [ class "items" ] [ Html.text name ]


view : Model -> Html Msg
view ( Tree _ f l, stack ) =
    Html.div [ class "container" ]
        [ goUpButton stack
        , Html.ul [ class "folders" ]
            (List.map folderButton f)
        , Html.ul [ class "data" ]
            (List.map (\a -> audienceButton a.name) l)
        ]


update : Msg -> Model -> Model
update msg (( tree, stack ) as model) =
    case msg of
        Goto target ->
            ( target, tree :: stack )

        GotoUp ->
            case stack of
                x :: xs ->
                    ( x, xs )

                [] ->
                    model


{-| Main file of application
-}
main =
    Html.beginnerProgram { model = initModel, view = view, update = update }
