module Tree
    exposing
        ( Tree
        , Node(..)
        , Id
        , ParentId(..)
        , empty
        , insert
        , findNodeById
        , flatten
        , getParentId
        , getSubtree
        )


type alias Id =
    Int


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


flatten : Tree a -> List (Node a)
flatten tree =
    tree
        |> List.foldl
            (\node acc ->
                if (List.length (getChildren node)) == 0 then
                    acc ++ [ node ]
                else
                    acc ++ [ node ] ++ (flatten (getChildren node))
            )
            empty


getChildren : Node a -> Tree a
getChildren (Node _ _ children) =
    children


findNodeById : Id -> Tree a -> Maybe (Node a)
findNodeById id tree =
    tree
        |> flatten
        |> List.filter
            (\(Node nodeId value children) ->
                nodeId == id
            )
        |> List.head


getParentId : Id -> Tree a -> ParentId
getParentId id tree =
    let
        filteredNodes =
            tree
                |> flatten
                |> List.filter
                    (\(Node nodeId value children) ->
                        List.any (\(Node nodeId _ _) -> nodeId == id) children
                    )
                |> List.head
    in
        case filteredNodes of
            Nothing ->
                Root

            Just (Node nodeId _ _) ->
                NodeId nodeId


insert : ParentId -> Id -> a -> Tree a -> Tree a
insert parentId nodeId value tree =
    let
        newNode =
            (Node nodeId value empty)
    in
        case parentId of
            Root ->
                addNode newNode tree

            NodeId parentNodeId ->
                extendSubtree parentNodeId newNode tree


addNode : Node a -> Tree a -> Tree a
addNode node tree =
    tree ++ [ node ]


extendSubtree : Id -> Node a -> Tree a -> Tree a
extendSubtree targetId node subtree =
    subtree
        |> List.map
            (\(Node nid nvalue nchildren) ->
                if (nid == targetId) then
                    (Node nid nvalue (addNode node nchildren))
                else if (List.length nchildren) > 0 then
                    (Node nid nvalue (extendSubtree targetId node nchildren))
                else
                    (Node nid nvalue nchildren)
            )


getSubtree : ParentId -> Tree a -> Tree a
getSubtree nodeParentId tree =
    case nodeParentId of
        Root ->
            tree

        NodeId id ->
            tree
                |> findNodeById id
                |> getSubtreeOfNode tree


getSubtreeOfNode : Tree a -> Maybe (Node a) -> Tree a
getSubtreeOfNode tree maybeNode =
    case maybeNode of
        Nothing ->
            tree

        Just (Node _ _ children) ->
            children
