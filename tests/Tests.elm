module Tests exposing (..)

import Test exposing (..)
import Tree exposing (Tree, Node(..), ParentId(..), insert, empty, findNodeById, flatten, getParentId)
import Expect


treeWithOneNodeInRoot : Tree String
treeWithOneNodeInRoot =
    Tree.empty
        |> Tree.insert Root 1 "1"


treeWithTwoNodesInRoot : Tree String
treeWithTwoNodesInRoot =
    Tree.empty
        |> Tree.insert Root 1 "1"
        |> Tree.insert Root 2 "2"


treeWithOneNestedNode : Tree String
treeWithOneNestedNode =
    Tree.empty
        |> Tree.insert Root 1 "1"
        |> Tree.insert (NodeId 1) 2 "2"


treeWithFourNodesInThreeLevels : Tree String
treeWithFourNodesInThreeLevels =
    Tree.empty
        |> Tree.insert Root 1 "1"
        |> Tree.insert (NodeId 1) 2 "2"
        |> Tree.insert (NodeId 2) 3 "3"
        |> Tree.insert (NodeId 2) 4 "4"


treeWithThreeNodesInRoot : Tree String
treeWithThreeNodesInRoot =
    Tree.empty
        |> Tree.insert Root 1 "1"
        |> Tree.insert Root 2 "2"
        |> Tree.insert Root 3 "3"


all : Test
all =
    describe "Tree"
        [ describe "Find by id"
            [ test "when searching for node Id 1 in empty tree it should be Nothing" <|
                \() ->
                    Tree.empty
                        |> Tree.findNodeById 1
                        |> Expect.equal Nothing
            , test "Find by Id Root in tree with one node in Root it should return this node" <|
                \() ->
                    treeWithOneNodeInRoot
                        |> Tree.findNodeById 1
                        |> Expect.equal (Just (Node 1 "1" []))
            , test "Find by Id of child in tree with root with two nodes it should return correct node" <|
                \() ->
                    treeWithTwoNodesInRoot
                        |> Tree.findNodeById 2
                        |> Expect.equal (Just (Node 2 "2" []))
            , test "when node is in children then find it" <|
                \() ->
                    treeWithOneNestedNode
                        |> Tree.findNodeById 2
                        |> Expect.equal (Just (Node 2 "2" []))
            , test "when node with children is in root then find it" <|
                \() ->
                    treeWithFourNodesInThreeLevels
                        |> Tree.findNodeById 2
                        |> Expect.equal (Just (Node 2 "2" [ (Node 3 "3" []), (Node 4 "4" []) ]))
            ]
        , describe "Find root of id"
            [ test "when searching for node Id 1 in empty tree should be Root" <|
                \() ->
                    Tree.empty
                        |> Tree.getParentId 1
                        |> Expect.equal Root
            , test "when searching for node Id 1 in tree with node 1 in Root it should be Root" <|
                \() ->
                    treeWithOneNodeInRoot
                        |> Tree.getParentId 1
                        |> Expect.equal Root
            , test "when searching for node Id 2 in tree with node 2 as child of node in Root it should Node Id" <|
                \() ->
                    treeWithOneNestedNode
                        |> Tree.getParentId 2
                        |> Expect.equal (NodeId 1)
            ]
        , test "when searched node is deeply nested" <|
            \() ->
                treeWithFourNodesInThreeLevels
                    |> Tree.getParentId 4
                    |> Expect.equal (NodeId 2)
        , describe "Insert"
            [ describe "Insertion into empty Tree"
                [ test "inserted one node with no parent ID, it should be added into root of the Tree" <|
                    \() ->
                        Tree.empty
                            |> Tree.insert Root 1 "1"
                            |> Expect.equal [ Node 1 "1" [] ]
                , test "inserted two nodes with no parent ID, they should be added into root of the Tree" <|
                    \() ->
                        Tree.empty
                            |> Tree.insert Root 1 "1"
                            |> Tree.insert Root 2 "2"
                            |> Expect.equal [ Node 1 "1" [], Node 2 "2" [] ]
                ]
            , describe "Given Tree with one node in root"
                [ test "when inserting node without parent id, then Tree root should have two nodes" <|
                    \() ->
                        treeWithOneNodeInRoot
                            |> Tree.insert Root 2 "2"
                            |> Expect.equal [ Node 1 "1" [], Node 2 "2" [] ]
                , test "when insterting node with parent id of non-existing node, then ignore insertion" <|
                    \() ->
                        treeWithOneNodeInRoot
                            |> Tree.insert (NodeId 123) 2 "2"
                            |> Expect.equal [ Node 1 "1" [] ]
                , test "when insterting node with parent id of inserted node, then Tree should have two levels" <|
                    \() ->
                        treeWithOneNodeInRoot
                            |> Tree.insert (NodeId 1) 2 "2"
                            |> Expect.equal [ Node 1 "1" [ Node 2 "2" [] ] ]
                ]
            , describe "Given Tree with three nodes in root"
                [ test "when inserting node without parent id, then Tree root should have four nodes" <|
                    \() ->
                        treeWithThreeNodesInRoot
                            |> Tree.insert Root 4 "4"
                            |> Expect.equal [ Node 1 "1" [], Node 2 "2" [], Node 3 "3" [], Node 4 "4" [] ]
                , test "when insterting node with parent id of inserted node, then Tree should have two levels" <|
                    \() ->
                        treeWithThreeNodesInRoot
                            |> Tree.insert (NodeId 1) 4 "4"
                            |> Expect.equal [ Node 1 "1" [ Node 4 "4" [] ], Node 2 "2" [], Node 3 "3" [] ]
                , test "when insterting two nodes with same parent id, then Tree should have two levels" <|
                    \() ->
                        treeWithThreeNodesInRoot
                            |> Tree.insert (NodeId 2) 4 "4"
                            |> Tree.insert (NodeId 2) 5 "5"
                            |> Expect.equal [ Node 1 "1" [], Node 2 "2" [ Node 4 "4" [], Node 5 "5" [] ], Node 3 "3" [] ]
                , test "when insterting node with parent id of inner node, then Tree should have three levels" <|
                    \() ->
                        treeWithThreeNodesInRoot
                            |> Tree.insert (NodeId 2) 4 "4"
                            |> Tree.insert (NodeId 4) 5 "5"
                            |> Expect.equal [ Node 1 "1" [], Node 2 "2" [ Node 4 "4" [ Node 5 "5" [] ] ], Node 3 "3" [] ]
                ]
            ]
        ]
