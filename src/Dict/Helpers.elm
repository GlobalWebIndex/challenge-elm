
module Dict.Helpers exposing ( fromListBy, fromListAppendBy )

import Dict exposing ( Dict )

fromListBy : (a -> comparable) -> List a -> Dict comparable a
fromListBy getKey xs =
  let initState = Dict.empty
      action x state =
        Dict.insert (getKey x) x state
  in List.foldl action initState xs

-- Given for example a list of records
--   xs : List
-- each of which has a field id : Maybe Int,
-- then
--   fromListAppendBy .id xs
-- computes a dictionary whose keys are the ids and values are lists of records with that id.
fromListAppendBy : (a -> Maybe comparable) -> List a -> Dict comparable (List a)
fromListAppendBy getKey xs =
  let initState = Dict.empty
      action x state =
        case getKey x of
          Just k ->
            Dict.update
              k
              (\mys ->
                  case mys of
                    Just ys -> Just (x :: ys)
                    Nothing -> Just [x]
                )
              state
          Nothing -> state
  in List.foldr action initState xs

