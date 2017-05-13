module Tests exposing (..)

import Test exposing (..)
import Tree exposing (Tree, Node(..), ParentId(..), insert, empty)
import Expect


all : Test
all =
    describe "Tree"
        [ describe "Insert"
            [ describe "Insertion into empty Tree"
                [ test "inserted one node with no parent ID, it should be added into root of the Tree" <|
                    \() ->
                        Tree.empty
                            |> Tree.insert Root "1" "1"
                            |> Expect.equal [ Node "1" "1" [] ]
                , test "inserted two nodes with no parent ID, they should be added into root of the Tree" <|
                    \() ->
                        Tree.empty
                            |> Tree.insert Root "1" "1"
                            |> Tree.insert Root "2" "2"
                            |> Expect.equal [ Node "1" "1" [], Node "2" "2" [] ]
                ]
            , let
                oneNodedTree =
                    Tree.empty
                        |> Tree.insert Root "1" "1"
              in
                describe "Given Tree with one node in root"
                    [ test "when inserting node without parent id, then Tree root should have two nodes" <|
                        \() ->
                            oneNodedTree
                                |> Tree.insert Root "2" "2"
                                |> Expect.equal [ Node "1" "1" [], Node "2" "2" [] ]
                    , test "when insterting node with parent id of non-existing node, then ignore insertion" <|
                        \() ->
                            oneNodedTree
                                |> Tree.insert (NodeId "nonexistingId") "2" "2"
                                |> Expect.equal [ Node "1" "1" [] ]
                    , test "when insterting node with parent id of inserted node, then Tree should have two levels" <|
                        \() ->
                            oneNodedTree
                                |> Tree.insert (NodeId "1") "2" "2"
                                |> Expect.equal [ Node "1" "1" [ Node "2" "2" [] ] ]
                    ]
            , let
                oneNodedTree =
                    Tree.empty
                        |> Tree.insert Root "1" "1"
                        |> Tree.insert Root "2" "2"
                        |> Tree.insert Root "3" "3"
              in
                describe "Given Tree with three nodes in root"
                    [ test "when inserting node without parent id, then Tree root should have four nodes" <|
                        \() ->
                            oneNodedTree
                                |> Tree.insert Root "4" "4"
                                |> Expect.equal [ Node "1" "1" [], Node "2" "2" [], Node "3" "3" [], Node "4" "4" [] ]
                    , test "when insterting node with parent id of inserted node, then Tree should have two levels" <|
                        \() ->
                            oneNodedTree
                                |> Tree.insert (NodeId "1") "4" "4"
                                |> Expect.equal [ Node "1" "1" [ Node "4" "4" [] ], Node "2" "2" [], Node "3" "3" [] ]
                    , test "when insterting two nodes with same parent id, then Tree should have two levels" <|
                        \() ->
                            oneNodedTree
                                |> Tree.insert (NodeId "2") "4" "4"
                                |> Tree.insert (NodeId "2") "5" "5"
                                |> Expect.equal [ Node "1" "1" [], Node "2" "2" [ Node "4" "4" [], Node "5" "5" [] ], Node "3" "3" [] ]
                    , test "when insterting node with parent id of inner node, then Tree should have three levels" <|
                        \() ->
                            oneNodedTree
                                |> Tree.insert (NodeId "2") "4" "4"
                                |> Tree.insert (NodeId "4") "5" "5"
                                |> Expect.equal [ Node "1" "1" [], Node "2" "2" [ Node "4" "4" [ Node "5" "5" [] ] ], Node "3" "3" [] ]
                    ]
            ]
        ]
