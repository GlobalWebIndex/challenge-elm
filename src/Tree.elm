module Tree exposing (..)


type alias Id =
    String


type ParentId
    = Root
    | NodeId Id


type alias Tree a =
    List (Node a)


type Node a
    = Node Id a (Tree a)


empty : Tree a
empty =
    []


addNode : Tree a -> Node a -> Tree a
addNode tree node =
    tree ++ [ node ]


extendSubtree : Id -> Node a -> Tree a -> Tree a
extendSubtree parentId node subtree =
    subtree
        |> List.map
            (\(Node nid nvalue nchildren) ->
                if (nid == parentId) then
                    (Node nid nvalue (addNode nchildren node))
                else
                    (Node nid nvalue nchildren)
            )


insert : ParentId -> Id -> a -> Tree a -> Tree a
insert parentId nodeId value tree =
    let
        newNode =
            (Node nodeId value [])
    in
        case parentId of
            Root ->
                addNode tree newNode

            NodeId parentNodeId ->
                extendSubtree parentNodeId newNode tree
