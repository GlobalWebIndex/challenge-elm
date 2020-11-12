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

listOfMaybeList : Maybe (List a) -> List a
listOfMaybeList mxs =
  case mxs of
    Just xs -> xs
    Nothing -> []

getChildren : Int -> Maybe Model
getChildren folderId =
  case (folders0, subfolders0, subaudiences0) of
    (Ok foldersDict, Ok subfoldersDict, Ok subaudiencesDict) ->
      Maybe.map
        (\parentFolder -> 
            Model parentFolder
                  (listOfMaybeList (Dict.get folderId subfoldersDict))
                  (listOfMaybeList (Dict.get folderId subaudiencesDict))
          )
        (Dict.get folderId foldersDict)
    _ -> Nothing


main : Html msg
main =
    Html.text (log (toString (getChildren 357)) "There will be app soon!")

