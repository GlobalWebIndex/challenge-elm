module Main exposing (main)

import Data.Audience exposing ( Audience, subaudiences0 )
import Data.AudienceFolder exposing ( AudienceFolder, subfolders0, folders0 )
import Html exposing (Html)
import Html.Events as Events
import Html.Attributes as Attr

import Browser

import Dict exposing ( Dict )

-- TODO: remove
import Debug exposing ( log, todo, toString )

-- ====== Overview ======
-- 0. To compile the app, execute
--      $ elm make src/Main.elm --output=public/main.js
--    and open public/index.html. The css is in public/style.css and is not included when the app is executed via elm reactor.
-- 1. Data.Audience and Data.AudienceFolder expose dictionaries
--    whose keys are folder ids and whose values are folders, subfolders, and subaudience of the mentioned folder id.
-- 2. If all parsing of JSON goes well, the state of the application is just
--    a triple (record) of parent folder, its subfolders and subaudiences.
-- 3. The only permissible action is to change the current parent folder.

-- ===STATE=== --
type alias ExplicitFolder =
  { parentFolder : AudienceFolder
  , subfolders : List AudienceFolder
  , subaudiences : List Audience }

type alias State = Maybe ExplicitFolder

-- a helper function - not worth to put into a separate module
listOfMaybeList : Maybe (List a) -> List a
listOfMaybeList mxs =
  case mxs of
    Just xs -> xs
    Nothing -> []

stateOfFolderId : Int -> State
stateOfFolderId folderId =
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
initState = stateOfFolderId 357
-- initState = stateOfFolderId 3111
-- initState = Nothing

-- ===ACTION===
type Action = ChangeFolder Int

action : Action -> State -> State
action (ChangeFolder folderId) _ = stateOfFolderId folderId

-- ===VIEW===
view : State -> Html Action
view state =
  case state of
    Just explicitFolder ->
      -- log (toString state)
      Html.div
        [ Attr.class "container" ]
        [ Html.a [ Attr.href "https://www.flaticon.com/authors/gregor-cresnar" ] [ Html.text "icon attribution" ]
        , viewParent explicitFolder
        , viewSubfolders explicitFolder.subfolders
        , viewSubaudiences explicitFolder.subaudiences
        ]
    Nothing -> Html.text "Nothing to display"

folderIcon = Html.img [ Attr.src "folder.svg" ] []
editIcon = Html.img [ Attr.src "pencil.svg" ] []

-- TODO: It is a bit unfortunate to recompute lengths every time the state changes,
--       but in practive for the size of the data that I am given this is not a big deal.
viewParent : ExplicitFolder -> Html Action
viewParent state =
  let parentFolder = state.parentFolder
      size = List.length state.subfolders + List.length state.subaudiences
      attributes =
        Attr.class "parent-folder" ::
          -- Different behaviour depending on whether the current parent folder has a parent.
          case parentFolder.parent of
            Just folderId -> [ Events.onClick (ChangeFolder folderId), Attr.class "parent-clickable" ]
            Nothing -> []
  in
    Html.h1
      attributes
      [ folderIcon, Html.text " "
      , Html.text parentFolder.name
      , Html.text " "
      , Html.span [ Attr.class "parent-size" ] [ Html.text (String.fromInt size) ] ]

viewSubfolder : AudienceFolder -> Html Action
viewSubfolder folder =
  Html.li
    [ Events.onClick (ChangeFolder folder.id)
    , Attr.class "subfolder" ]
    [ Html.text folder.name, Html.img [ Attr.src "folder.svg"] [] ]

viewSubfolders : List AudienceFolder -> Html Action
viewSubfolders folders =
  Html.ul
    [ Attr.class "subfolders", Attr.class "parent-clickable" ]
    (List.map viewSubfolder folders)

viewSubaudience : Audience -> Html Action
viewSubaudience audience =
  Html.li
    [ Attr.class "subaudience" ]
    [ Html.span [] [Html.text audience.name]
    , Html.img [ Attr.src "edit.svg"] [] ]

viewSubaudiences : List Audience -> Html Action
viewSubaudiences audiences =
  Html.ul
    [ Attr.class "subaudiences" ]
    (List.map viewSubaudience audiences)

-- === MAIN ===
main = Browser.sandbox { init = initState, update = action, view = view }

