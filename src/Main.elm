module Main exposing (main)

import Basics.Extra exposing (flip)
import Browser
import Data.Audience exposing (Audience, audienceToString)
import Html exposing (Html)
import Html.Attributes exposing (style)
import Html.Events as Events
import Label exposing (Label(..))
import Maybe.Extra
import String.Extra
import Tree.Zipper as Zipper exposing (Zipper)
import Zipper exposing (kids, tree)


type Msg
    = Navigate (Zipper Label)


type alias Model =
    Zipper.Zipper Label


init : Model
init =
    tree


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }


view : Model -> Html Msg
view zipper =
    let
        (Label { audiences, name, id }) =
            Zipper.label zipper

        folders =
            kids zipper

        {- NOTE: I would not really write it like this in real project. Just thought I would have some fun and perhaps humor someone with a pointfree eye ;) -}
        ifNotRoot =
            (flip Maybe.andThen <| id) << always << Just

        {- NOTE: I decided against it. One button is enough. -}
        -- rootButton = viewGoButton "Back to TOP" <| Zipper.root zipper
        -- toTop = ifNotRoot rootButton
        goUp =
            ifNotRoot <| viewGoUp zipper

        folderTitle =
            Html.span
                [ style "padding" "15px"
                , style "margin" "15px"
                , style "background-color" "pink"
                ]
                [ Html.text <| "Now viewing: " ++ name ]

        levelName =
            ifNotRoot folderTitle

        directories =
            viewFolders folders

        items =
            if List.isEmpty audiences then
                [{- EMPTY FOLDER -}]

            else
                List.map viewAudience audiences

        navigation =
            Maybe.Extra.values
                [ -- toTop
                  goUp
                , levelName
                ]
    in
    Html.div
        [ style "margin" "auto"
        , style "margin-top" "0"
        , style "margin-bottom" "0"
        , style "width" "50%"
        , style "border" "3px solid green"
        ]
    <|
        navigation
            ++ [ Html.ul [ style "list-style-type" "none", style "overflow-y" "scroll", style "height" "90vh" ] <|
                    directories
                        ++ items
               ]


viewFolders : List (Zipper Label) -> List (Html Msg)
viewFolders folders =
    List.map viewFolder folders


viewGoButton : String -> Zipper Label -> Html Msg
viewGoButton message goWhere =
    Html.div
        [ Events.onClick <| Navigate goWhere
        , style "background-color" "teal"
        , style "padding" "20px"
        ]
        [ Html.text message ]


viewGoUp : Zipper Label -> Html Msg
viewGoUp zipper =
    let
        maybeParent =
            Zipper.parent zipper

        {- NOTE: Honestly, I am not happy with the code here. I think some more thought out strategy might help.
           Like - since we know this function is only called when it IS POSSIBLE to go up, we might leverage that and shift the responsibility
           of proving that the current level HAS a parent to the caller.
           But I have spent enought time with this code already so fine tuning it seems like a pointless task - epsecially since I can just write my thoughts here.
        -}
        goMessage =
            Maybe.andThen
                (Zipper.label >> (\(Label { name }) -> String.Extra.nonEmpty name))
                maybeParent
                |> Maybe.map ((++) "< ")
                |> Maybe.Extra.unwrap "< /" identity
    in
    viewGoButton goMessage <| Maybe.withDefault (Zipper.root zipper) (Zipper.parent zipper)
--                                              ^^^ this will never happen, this function won't get called when in the root.


viewFolder : Zipper Label -> Html Msg
viewFolder zipper =
    let
        (Label { name, audiences }) =
            Zipper.label zipper

        size =
            List.length (Zipper.children zipper) + List.length audiences
    in
    Html.li
        [ style "padding" "15px"
        , style "margin" "15px"
        , style "background-color" "teal"
        , Events.onClick <| Navigate zipper
        ]
        [ Html.text <| "Folder Name: " ++ name ++ " number of items: " ++ String.fromInt size ]


viewAudience : Audience -> Html Msg
viewAudience { name } =
    Html.li [ style "margin" "15px", style "padding" "15px", style "background-color" "turquoise" ]
        [ Html.text ("name: " ++ name) ]


update : Msg -> Model -> Model
update msg _ =
    case msg of
        Navigate zipper ->
            zipper
