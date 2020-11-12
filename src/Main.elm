module Main exposing (main)

import Data.Audience exposing ( Audience, subaudiences0 )
import Data.AudienceFolder exposing ( AudienceFolder, subfolders0, folders0 )
import Html exposing (Html)
import Html exposing (Html)
import Html.Events as Events

import Browser

import Dict exposing ( Dict )

-- TODO: remove
import Debug exposing ( log, todo, toString )

-- ===STATE=== --
type alias ExplicitFolder =
  { parentFolder : AudienceFolder
  , subfolders : List AudienceFolder
  , subaudiences : List Audience }

type alias State = Maybe ExplicitFolder

-- helper
listOfMaybeList : Maybe (List a) -> List a
listOfMaybeList mxs =
  case mxs of
    Just xs -> xs
    Nothing -> []

getState : Int -> State
getState folderId =
  case (folders0, subfolders0, subaudiences0) of
    (Ok foldersDict, Ok subfoldersDict, Ok subaudiencesDict) ->
      Maybe.map
        (\parentFolder -> 
            ExplicitFolder
              parentFolder
              (listOfMaybeList (Dict.get folderId subfoldersDict))
              (listOfMaybeList (Dict.get folderId subaudiencesDict))
          )
        (Dict.get folderId foldersDict)
    _ -> Nothing

initState : State
-- initState = getState 357
initState = getState 3111
-- initState = Nothing

-- ===ACTION===
type Action = ChangeFolder Int

action : Action -> State -> State
action (ChangeFolder folderId) _ = getState folderId

-- ===VIEW===
view : State -> Html Action
view state =
  case state of
    Just explicitFolder ->
      -- log (toString state)
      Html.div
        []
        [ viewParent explicitFolder.parentFolder
        , viewSubfolders explicitFolder.subfolders
        , viewSubaudiences explicitFolder.subaudiences
        ]
    Nothing -> Html.text "nothing to display"

viewParent : AudienceFolder -> Html Action
viewParent folder =
  case folder.parent of
    Just folderId -> Html.h1 [ Events.onClick (ChangeFolder folderId) ] [ Html.text folder.name ]
    Nothing -> Html.h1 [] [ Html.text folder.name ]

viewSubfolder : AudienceFolder -> Html Action
viewSubfolder folder = Html.li [ Events.onClick (ChangeFolder folder.id) ] [ Html.text folder.name ]

viewSubfolders : List AudienceFolder -> Html Action
viewSubfolders folders = Html.ul [] (List.map viewSubfolder folders)

viewSubaudience : Audience -> Html Action
viewSubaudience audience = Html.li [] [ Html.text audience.name ]

viewSubaudiences : List Audience -> Html Action
viewSubaudiences audiences = Html.ul [] (List.map viewSubaudience audiences)

-- === MAIN ===
main = Browser.sandbox { init = initState, update = action, view = view }

