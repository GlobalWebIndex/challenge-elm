module Main exposing (main)

import Maybe.Extra
import Tree.Zipper as Zipper exposing (Zipper)

import Html exposing (Html)
import Html.Events as Events

import Browser

import Data.Audience exposing (Audience, audienceToString)

import Label exposing (Label(..))
import Zipper exposing (zipper, kids)


type Msg
    = Navigate (Zipper Label)


type alias Model = Zipper.Zipper Label


init : Model
init = zipper


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }


view : Model -> Html Msg
view zipper =
    let
        (Label { audiences, name, id }) = Zipper.label zipper
        folders = kids zipper
    in
        Html.div [] <|
                    (if Maybe.Extra.isJust id then [ Html.div [Events.onClick <| Navigate (Zipper.root zipper) ] [Html.text "Back to TOP"] ] else [] )
                    ++
                    (if Maybe.Extra.isNothing id then [{- ROOT LEVEL -}] else [ viewGoUp zipper ])
                    ++
                    (if Maybe.Extra.isJust id
                        then    [ Html.text <| "Now viewing: " ++ name ]
                        else    [])
                    ++
                    [ Html.ul [] <| List.map viewFolder folders
                    , Html.br [] [] ]
                    ++
                    (if List.isEmpty audiences
                        then []
                                
                        else    [ Html.text "Items: "
                                , Html.br [] []
                                , Html.ul [] <| List.map ((Html.li []) << (List.singleton) << viewAudience) audiences
                                ]
                    )


viewGoUp : Zipper Label -> Html Msg
viewGoUp zipper =
    let
        maybeParrent = Zipper.parent zipper
        goMessage = case maybeParrent of
            Nothing -> "go back to /"
            Just parent ->
                let
                    (Label { name }) = Zipper.label parent
                in  "go back to /" ++ name

    in  Html.div [Events.onClick <| Navigate (Maybe.withDefault (Zipper.root zipper) (Zipper.parent zipper)) ] [Html.text goMessage]


viewFolder : Zipper Label -> Html Msg
viewFolder zipper =
    let
        (Label { name, audiences }) = Zipper.label zipper
        size = (Zipper.children zipper |> List.length) + (List.length audiences)
    in  Html.li [Events.onClick <| Navigate zipper] [ Html.text <| "Folder Name: " ++ name ++ " number of items: " ++ (String.fromInt size) ]


viewAudience : Audience -> Html Msg
viewAudience { name, type_ } =
    Html.div [] [ Html.text <| "name: " ++ name
                , Html.br [] []
                , Html.text <| "type: " ++ audienceToString type_
                , Html.br [] []
                , Html.br [] []
                ]


update : Msg -> Model -> Model
update msg _ =
    case msg of
        Navigate zipper -> zipper
