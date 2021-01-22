module Tree.Zipper.Extra exposing (findChild, findNextSibling)

import Tree.Zipper as Zipper exposing (Zipper)


findChild : (a -> Bool) -> Zipper a -> Maybe (Zipper a)
findChild test zipper =
    case Zipper.firstChild zipper of
        Nothing ->
            Nothing

        Just firstChild ->
            if test (Zipper.label firstChild) then
                Just firstChild

            else
                findNextSibling test firstChild


findNextSibling : (a -> Bool) -> Zipper a -> Maybe (Zipper a)
findNextSibling test zipper =
    case Zipper.nextSibling zipper of
        Nothing ->
            Nothing

        Just nextSibling ->
            if test (Zipper.label nextSibling) then
                Just nextSibling

            else
                findNextSibling test nextSibling
