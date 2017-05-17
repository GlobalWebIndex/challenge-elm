module Tests exposing (..)

import Test exposing (..)
import Tree exposing (Tree, Node(..), ParentId(..), insert, empty, findById, flatten)
import Expect


all : Test
all =
    describe "Tree"
        [ describe "Find by id"
            [ test "when searching for node Id 1 in empty tree should be Nothing" <|
                \() ->
                    Tree.empty
                        |> Tree.findById 1
                        |> Expect.equal Nothing
            , test "Find by Id Root in tree with one node in Root should return this node" <|
                \() ->
                    Tree.empty
                        |> Tree.insert Root 1 "1"
                        |> Tree.findById 1
                        |> Expect.equal (Just (Node 1 "1" []))
            , test "Find by Id of child in tree with root with two nodes should return correct node" <|
                \() ->
                    Tree.empty
                        |> Tree.insert Root 1 "1"
                        |> Tree.insert Root 2 "2"
                        |> Tree.findById 2
                        |> Expect.equal (Just (Node 2 "2" []))
            , test "when node is in children then find it" <|
                \() ->
                    Tree.empty
                        |> Tree.insert Root 1 "1"
                        |> Tree.insert (NodeId 1) 2 "2"
                        |> Tree.findById 2
                        |> Expect.equal (Just (Node 2 "2" []))
            , test "when node with children is in root" <|
                \() ->
                    Tree.empty
                        |> Tree.insert Root 1 "1"
                        |> Tree.insert (NodeId 1) 2 "2"
                        |> Tree.insert (NodeId 2) 3 "3"
                        |> Tree.insert (NodeId 2) 4 "4"
                        |> Tree.findById 2
                        |> Expect.equal (Just (Node 2 "2" [ (Node 3 "3" []), (Node 4 "4" []) ]))
            ]
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
            , let
                oneNodedTree =
                    Tree.empty
                        |> Tree.insert Root 1 "1"
              in
                describe "Given Tree with one node in root"
                    [ test "when inserting node without parent id, then Tree root should have two nodes" <|
                        \() ->
                            oneNodedTree
                                |> Tree.insert Root 2 "2"
                                |> Expect.equal [ Node 1 "1" [], Node 2 "2" [] ]
                    , test "when insterting node with parent id of non-existing node, then ignore insertion" <|
                        \() ->
                            oneNodedTree
                                |> Tree.insert (NodeId 123) 2 "2"
                                |> Expect.equal [ Node 1 "1" [] ]
                    , test "when insterting node with parent id of inserted node, then Tree should have two levels" <|
                        \() ->
                            oneNodedTree
                                |> Tree.insert (NodeId 1) 2 "2"
                                |> Expect.equal [ Node 1 "1" [ Node 2 "2" [] ] ]
                    ]
            , let
                oneNodedTree =
                    Tree.empty
                        |> Tree.insert Root 1 "1"
                        |> Tree.insert Root 2 "2"
                        |> Tree.insert Root 3 "3"
              in
                describe "Given Tree with three nodes in root"
                    [ test "when inserting node without parent id, then Tree root should have four nodes" <|
                        \() ->
                            oneNodedTree
                                |> Tree.insert Root 4 "4"
                                |> Expect.equal [ Node 1 "1" [], Node 2 "2" [], Node 3 "3" [], Node 4 "4" [] ]
                    , test "when insterting node with parent id of inserted node, then Tree should have two levels" <|
                        \() ->
                            oneNodedTree
                                |> Tree.insert (NodeId 1) 4 "4"
                                |> Expect.equal [ Node 1 "1" [ Node 4 "4" [] ], Node 2 "2" [], Node 3 "3" [] ]
                    , test "when insterting two nodes with same parent id, then Tree should have two levels" <|
                        \() ->
                            oneNodedTree
                                |> Tree.insert (NodeId 2) 4 "4"
                                |> Tree.insert (NodeId 2) 5 "5"
                                |> Expect.equal [ Node 1 "1" [], Node 2 "2" [ Node 4 "4" [], Node 5 "5" [] ], Node 3 "3" [] ]
                    , test "when insterting node with parent id of inner node, then Tree should have three levels" <|
                        \() ->
                            oneNodedTree
                                |> Tree.insert (NodeId 2) 4 "4"
                                |> Tree.insert (NodeId 4) 5 "5"
                                |> Expect.equal [ Node 1 "1" [], Node 2 "2" [ Node 4 "4" [ Node 5 "5" [] ] ], Node 3 "3" [] ]
                    ]
            ]
        ]
