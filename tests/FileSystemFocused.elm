module FileSystemFocused exposing (suite)

import Data.FileSystem exposing (..)
import Data.Focused.FileSystem exposing (..)
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


suite : Test
suite =
    describe "Data.Focused.FileSystem"
        [ describe "focus"
            [ test "focusing file" <|
                \_ ->
                    Expect.equal
                        (focus <| File 1)
                        ( [], File 1 )
            , test "focusing folder" <|
                \_ ->
                    Expect.equal
                        (focus <| Folder "ROOT" [])
                        ( [], Folder "ROOT" [] )
            ]
        , describe "stepDown"
            [ test "stepping down into File" <|
                \_ ->
                    Expect.equal
                        (stepDown 0 <| focus (Folder "ROOT" [ File 0, File 1 ]))
                        (Just ( [ FolderWithHole "ROOT" [] [ File 1 ] ], File 0 ))
            , test "cannot step down with negative index" <|
                \_ ->
                    Expect.equal
                        (stepDown -1 <|
                            focus
                                (Folder "ROOT"
                                    [ Folder "A" []
                                    , Folder "B" []
                                    ]
                                )
                        )
                        Nothing
            , test "cannot step down with index larger than focused folder length" <|
                \_ ->
                    Expect.equal
                        (stepDown 2 <|
                            focus
                                (Folder "ROOT"
                                    [ Folder "A" []
                                    , Folder "B" []
                                    ]
                                )
                        )
                        Nothing
            , test "stepping down into 0th folder" <|
                \_ ->
                    Expect.equal
                        (stepDown 0 <|
                            focus
                                (Folder "ROOT"
                                    [ Folder "A" []
                                    , Folder "B" []
                                    ]
                                )
                        )
                        (Just ( [ FolderWithHole "ROOT" [] [ Folder "B" [] ] ], Folder "A" [] ))
            ]
        ]
