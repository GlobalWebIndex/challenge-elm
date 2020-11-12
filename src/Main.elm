module Main exposing (main)

import Data.Audience exposing ( Audience, subaudiences0 )
import Data.AudienceFolder exposing ( AudienceFolder, subfolders0, folders0 )
import Html exposing (Html)

import Dict exposing ( Dict )

-- TODO: remove
import Debug exposing ( log, todo, toString )

type alias Model =
  { parentFolder : AudienceFolder
  , subfolders : List AudienceFolder
  , subaudiences : List Audience }

getChildren : Int -> Maybe Model
getChildren folderId =
  case (folders0, subfolders0, subaudiences0) of
    (Ok foldersDict, Ok subfoldersDict, Ok subaudiencesDict) ->
      Maybe.map3
        Model
        (Dict.get folderId foldersDict)
        (Dict.get folderId subfoldersDict)
        (Dict.get folderId subaudiencesDict)
    _ -> Nothing

main : Html msg
main =
    Html.text "There will be app soon!"

