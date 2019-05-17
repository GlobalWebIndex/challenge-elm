module Example exposing (suite)

import Data.FileTree exposing (..)
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


fileTree : FileTree Int
fileTree =
    Folder "ROOT"
        [ Folder "A"
            [ File 1
            , Folder "B"
                [ File 2
                , File 3
                ]
            ]
        , File 3
        , Folder "C" [ File 4 ]
        ]


suite : Test
suite =
    describe "Data.FileTree"
        [ describe "toList"
            [ test "flattening naked file" <|
                \_ ->
                    Expect.equal
                        (toList <| File 1)
                        [ 1 ]
            , test "flattening empty folder" <|
                \_ ->
                    Expect.equal
                        (toList <| Folder "epmtyFolder" [])
                        []
            , test "flattening complex structure" <|
                \_ ->
                    Expect.equal
                        (toList <|
                            Folder "ROOT"
                                [ Folder "A"
                                    [ File 1
                                    , Folder "B"
                                        [ File 2
                                        , File 3
                                        ]
                                    , Folder "C" []
                                    ]
                                , File 4
                                , Folder "D" [ File 5 ]
                                ]
                        )
                        [ 1, 2, 3, 4, 5 ]
            ]
        , describe "filterFiles"
            [ test "filtering out (File 3)" <|
                \_ ->
                    Expect.equal
                        (filterFiles (\n -> n /= 3) <|
                            Folder "ROOT"
                                [ Folder "A"
                                    [ File 1
                                    , File 3
                                    , File 2
                                    , Folder "C" [ File 1, File 3 ]
                                    ]
                                , Folder "B" []
                                , File 2
                                , File 3
                                ]
                        )
                        (Folder "ROOT"
                            [ Folder "A"
                                [ File 1
                                , File 2
                                , Folder "C" [ File 1 ]
                                ]
                            , Folder "B" []
                            , File 2
                            ]
                        )
            ]
        , describe "mapFiles"
            [ test "mapping to different type" <|
                \_ ->
                    Expect.equal
                        (mapFiles (\_ -> 'a') (File 1))
                        (File 'a')
            , test "mapping naked file" <|
                \_ ->
                    Expect.equal
                        (mapFiles (\_ -> 'a') (File 1))
                        (File 'a')
            , test "mapping empty folder" <|
                \_ ->
                    Expect.equal
                        (mapFiles (\_ -> 0) (Folder "empty" []))
                        (Folder "empty" [])
            , test "mapping single folder" <|
                \_ ->
                    Expect.equal
                        (mapFiles (\_ -> 0) (Folder "empty" [ File 1, File 2 ]))
                        (Folder "empty" [ File 0, File 0 ])
            , test "mapping complex FileTree" <|
                \_ ->
                    Expect.equal
                        (mapFiles (\_ -> 0) <|
                            Folder "ROOT"
                                [ Folder "A" [ File 1, File 3, File 2 ]
                                , File 2
                                , File 3
                                ]
                        )
                        (Folder "ROOT"
                            [ Folder "A" [ File 0, File 0, File 0 ]
                            , File 0
                            , File 0
                            ]
                        )
            ]
        , describe "reverse"
            [ test "is identity on a naked file" <|
                \_ ->
                    Expect.equal
                        (File 1)
                        (File 1)
            , test "is identity on an empty folder" <|
                \_ ->
                    Expect.equal
                        (Folder "empty" [])
                        (Folder "empty" [])
            , test "reverses complex file tree correctly" <|
                \_ ->
                    Expect.equal
                        (reverse <|
                            Folder "ROOT"
                                [ Folder "A"
                                    [ File 1
                                    , Folder "B"
                                        [ File 2
                                        , File 3
                                        ]
                                    , Folder "C" []
                                    ]
                                , File 4
                                , Folder "D" [ File 5 ]
                                ]
                        )
                        (Folder "ROOT"
                            [ Folder "D" [ File 5 ]
                            , File 4
                            , Folder "A"
                                [ Folder "C" []
                                , Folder "B"
                                    [ File 3
                                    , File 2
                                    ]
                                , File 1
                                ]
                            ]
                        )
            ]
        ]
