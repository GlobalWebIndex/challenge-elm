module MTree exposing
    ( MTree
    , leaf, mtree
    , root, children
    , addChild, changeRoot, mapRoot
    )

{-| A Multiway tree. A multiway tree consinst of nodes. Each node can have an arbitrary number of children element.
A Multiway tree can not be empty, must have a value.


# Multiway trees

@docs MTree


# Build

@docs leaf, mtree


# Structure

@docs root, children


# Transform

@docs addChild, changeRoot, mapRoot

-}


type MTree a
    = MNode a (List (MTree a))



{- Create a multiway tree containing only a single value, without any children.

   leaf 1
-}


leaf : a -> MTree a
leaf x =
    MNode x []



{- Create a multiway tree from a value and a list of child

   mtree 6 [leaf 1, leaf 2]
-}


mtree : a -> List (MTree a) -> MTree a
mtree label_ children_ =
    MNode label_ children_



{- Get the root value of the tree

   mtree 6 [leaf 1, leaf 2] |> root == 6
-}


root : MTree a -> a
root (MNode root_ _) =
    root_



{- Get the children of the tree

   mtree 6 [leaf 1, leaf 2] |> children
       == [leaf 1, leaf 2]
-}


children : MTree a -> List (MTree a)
children (MNode _ children_) =
    children_



{- Add an element to the front of the children

   mtree 6 [leaf 1, leaf 2] |> addChild (leaf 9)
       == mtree 9 [ leaf 1
                      , leaf 2
                      ]
-}


addChild : MTree a -> MTree a -> MTree a
addChild childTree (MNode e children_) =
    MNode e (childTree :: children_)



{- Change the root value of the tree

   mtree 6 [leaf 1, leaf 2] |> changeRoot 9
       == mtree 9 [ leaf 1
                      , leaf 2
                      ]
-}


changeRoot : a -> MTree a -> MTree a
changeRoot x (MNode root_ children_) =
    MNode x children_



{- Apply a function to the root value of the tree

   mtree 6 [leaf 1, leaf 2] |> mapRoot ((*) 2)
       == mtree 12
           [ leaf 1
           , leaf 2
           ]
-}


mapRoot : (a -> a) -> MTree a -> MTree a
mapRoot mapFn (MNode root_ children_) =
    MNode (mapFn root_) children_
