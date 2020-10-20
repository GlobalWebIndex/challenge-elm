module Zipper exposing
    ( Zipper
    , create, fromTree
    , goUp, goTo
    , current, children
    , addChild, addChildren, mapRoot
    )

{-| A Multiway tree with a pointer, pointing at a specific subtree of the tree.


# Structure

@docs Zipper


# Build

@docs create, fromTree


# Navigation

@docs goUp, goTo


# Current level

@docs current, children


# Modification

@docs addChild, addChildren, mapRoot

-}

import MTree exposing (MTree)


{-| As we navigate in the tree we collect crumbs to be able to rebuild the tree
-}
type Crumb a
    = Crumb a (List (MTree a)) (List (MTree a))


{-| Multiway tree with a notion of a focus.
-}
type Zipper a
    = Zipper (MTree a) (List (Crumb a))


{-| List with a reference. The list has left side and right side and a reference to an element in a list
-}
type alias ListWithRef a =
    ( List a, a, List a )


type alias ListWithR a =
    ( List a, Maybe a, List a )


{-| Create a multiway tree pointing at the root element

    create 5

    --> leaf 5

-}
create : a -> Zipper a
create x =
    Zipper (MTree.leaf x) []


{-| Create a multiway tree pointing from a tree

    mtree 6 [ leaf 1, leaf 2 ] |> fromTree

-}
fromTree : MTree a -> Zipper a
fromTree tree =
    Zipper tree []


{-| Move the pointer to the parent

    mtree 6 [ leaf 1, leaf 2 ]
        |> fromTree
        |> goTo ((==) 2)
        |> goUp

    -->
    mtree 6 [ leaf 1, leaf 2 ]
        |> fromTree

-}
goUp : Zipper a -> Maybe (Zipper a)
goUp (Zipper parent breadcrumbs) =
    case breadcrumbs of
        [] ->
            Nothing

        (Crumb x leftUncles rightUncles) :: rest ->
            Just <| Zipper (MTree.mtree x (leftUncles ++ [ parent ] ++ rightUncles)) rest


{-| Move the pointer to a child that satisfy the test

    mtree 6 [leaf 1, leaf 2]
        |> fromTree
        |> goTo ((==) 2)
        |> Maybe.map current

        --> Just 2

-}
goTo : (a -> Bool) -> Zipper a -> Maybe (Zipper a)
goTo fn (Zipper tree breadcrumbs) =
    let
        x =
            tree |> MTree.root

        children_ =
            tree |> MTree.children

        ( left, ref, rest ) =
            findChild fn children_
    in
    case ref of
        Just itemToGo ->
            Just <| goToChild x breadcrumbs ( left, itemToGo, rest )

        Nothing ->
            Nothing


goToChild : a -> List (Crumb a) -> ListWithRef (MTree a) -> Zipper a
goToChild x breadcrumbs ( leftSide, itemToGo, rightSide ) =
    Zipper itemToGo (Crumb x leftSide rightSide :: breadcrumbs)


findChild : (a -> Bool) -> List (MTree a) -> ListWithR (MTree a)
findChild fn list =
    findChildHelp fn list ( [], Nothing, [] )


findChildHelp : (a -> Bool) -> List (MTree a) -> ListWithR (MTree a) -> ListWithR (MTree a)
findChildHelp fn children_ ( accL, child, accR ) =
    case children_ of
        first :: rest ->
            let
                x =
                    current (Zipper first [])
            in
            if fn x then
                ( List.reverse accL, Just first, rest )

            else
                findChildHelp fn rest ( first :: accL, Nothing, accR )

        [] ->
            ( accL, child, accR )


{-| Get the root value of the tree where the pointer is

    mtree 6 [leaf 1, leaf 2] |> fromTree |> goTo ((==) 2) |> Maybe.map current
        --> Just 2

-}
current : Zipper a -> a
current (Zipper tree _) =
    tree |> MTree.root


{-| Get the childrens of the tree where the pointer is

    mtree 6 [leaf 1, leaf 2] |> fromTree |> goTo ((==) 2) |> Maybe.map children
        --> Just []

-}
children : Zipper a -> List a
children (Zipper tree _) =
    List.map MTree.root (MTree.children tree)


{-| Change the root value of the tree where the pointer is

    mtree 6 [leaf 1, leaf 2] |> fromTree |> goTo ((==) 2) |> Maybe.map (changeRoot 9)
        --> mtree 6 [leaf 1, leaf 9]

-}
changeRoot : a -> Zipper a -> Zipper a
changeRoot x (Zipper tree breadcrumbs) =
    Zipper
        (MTree.changeRoot x tree)
        breadcrumbs


{-| Apply a function to the root element of the tree where the pointer at

    mtree 6 [leaf 1, leaf 2] |> fromTree |> goTo ((==) 2) |> Maybe.map (mapRoot ((+) 9))
        --> mtree 6 [leaf 1, leaf 11]

-}
mapRoot : (a -> a) -> Zipper a -> Zipper a
mapRoot fn (Zipper tree breadcrumbs) =
    Zipper
        (MTree.mapRoot fn tree)
        breadcrumbs


{-| Add a tree to the front of the children where the pointer at

     mtree 6 [leaf 1, leaf 2] |> fromTree |> goTo ((==) 2) |> Maybe.map (addChild (leaf 3))
        --> mtree 6 [ leaf 1
                       , mtree 2 [ leaf 3
                                     ]
                       ]

-}
addChild : MTree a -> Zipper a -> Zipper a
addChild x (Zipper tree breadcrumbs) =
    Zipper (MTree.addChild x tree) breadcrumbs


{-| Add a list of element to the front of the children where the pointer at

    mtree 6 [leaf 1, leaf 2] |> fromTree |> goTo ((==) 2) |> Maybe.map (addChildren [3, 4])
        --> mtree 6 [ leaf 1
                       , mtree 2 [ leaf 3
                                     , leaf 4
                                     ]
                       ]

-}
addChildren : List a -> Zipper a -> Zipper a
addChildren children_ zipper =
    children_
        |> List.map MTree.leaf
        |> List.foldr addChild zipper
