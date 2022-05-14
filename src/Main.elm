module Main exposing (main)

import Html exposing (Html)


import Data.Audience exposing (audiencesJSON)
import Data.AudienceFolder exposing (audienceFoldersJSON)


import Decoder.FolderDecoder as FD
import Decoder.AudienceDecoder as AD
import Data.Audience exposing (Audience)
import Data.AudienceFolder exposing (AudienceFolder)

import Algo exposing (..)
import Browser



type alias Model =
    { audience : List Audience
    , folders  : List AudienceFolder
    , visibleFolder :  Maybe Int
    , simple : SimpleFolder }



init : Model
init =  { audience = []
        , folders = []
        , visibleFolder = Nothing
        , simple = simpleFolder }

-- so what I do with the data
-- each audience member either belongs to some folder (which itself may belong into one), or it is a top level
-- so my data representation can reflect that
-- I can sort them at the beginning to their correct folders
-- and if they don't have any, just put them into the top level "folder"
-- 

-- the top level holds a list of folders and a list of top level members
-- non-top levels hold a list of items and a list of folders (because there are folders inside folders)
-- so the structure is essentially a file system tree structure
type alias Structure = {  }


simpleFolder : SimpleFolder
simpleFolder =
    let
        a = AD.decode audiencesJSON
        b = FD.decode audienceFoldersJSON
    in  case (a, b) of
            (Ok audiences, Ok folders) -> buildSimple (audiences, folders) Nothing (Nothing, Just "Root")
            _ -> SimpleFolder [] [] { id = Nothing, name = Nothing, parent = Nothing }
    






main : Program () Model ()
main =
    Browser.sandbox { init = init, update = update, view = view }


view : Model -> Html ()
view { simple } =
    viewSimple simple


viewSimple : SimpleFolder -> Html ()
viewSimple (SimpleFolder audiences folders { id, name, parent }) =
    Html.div [] [ Html.text "name: "
                , Html.text <| Debug.toString name

                , Html.ul [] <| List.map viewItem audiences ++ 
                    [ Html.br [] []
                    , Html.br [] []
                    , Html.text <| "folders: "
                    , Html.br [] []
                    , Html.br [] [] ] ++
                    List.map viewSimple folders

    ]


update : () -> Model -> Model
update msg model = model



viewItem : Audience -> Html ()
viewItem { id, name, type_, folder} =
    Html.li []  [ Html.text "id: "
                , Html.text <| String.fromInt id
                , Html.br [] []
                , Html.text "name: "
                , Html.text name
                , Html.br [] []
                , Html.text "type: "
                , Html.text <| Debug.toString type_
                , Html.br [] []
                , Html.text "folder: "
                , Html.text <| Debug.toString folder
                , Html.br [] []
                , Html.br [] [] ]
