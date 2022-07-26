module Data.Tree exposing (buildDict, buildAudiences, buildFolders)

import Dict exposing (Dict)


-- buildDict computes a mapping parentId -> List item
--
-- I assume that parentId 0 is not used and use it as
-- replacement for null (Nothing) parent/folder Id.
-- If that assumption is not correct we can map Maybe Int
-- to String like this:
--
-- case parentId if
--     Nothing ->
--         "null"
--     Just id ->
--         String.fromInt id
--

buildDict : List a -> (a -> comparable) -> Dict comparable (List a)
buildDict items key =
    List.foldl
        (\x acc ->
             Dict.update
                 (key x)
                 -- we could use << and put Just at the head of the chain
                 -- but I'd prefer a "forward" style :)
                 (identity                      -- to get good indentation :)
                      >> Maybe.map ((::) x)     -- prepend to an existing list
                      >> Maybe.withDefault [x]  -- or create a new one
                      >> Just)                  -- and put back to the dict
                 acc)
        Dict.empty
        items


-- build the mapping for audiences
buildAudiences
     : List { a | folder : Maybe Int }
    -> Dict Int (List { a | folder : Maybe Int })
buildAudiences audiences =
    buildDict audiences (.folder >> Maybe.withDefault 0)


-- build the mapping for audience folders
buildFolders
     : List { a | parent : Maybe Int }
    -> Dict Int (List { a | parent : Maybe Int })
buildFolders folders =
    buildDict folders (.parent >> Maybe.withDefault 0)
