module Tests exposing (..)

import Data.Audience as A
import Data.AudienceFolder as F
import Expect exposing (Expectation)
import Fuzz
import Json.Decode as Jd
import Json.Encode as Je
import Main
import Test exposing (..)
import Dict
import Set


suite : Test
suite =
    describe "all tests"
        [ describe "audience decoder" audienceDecoder
        , describe "folder decoder" folderDecoder
        , describe "child selecter" childSelecter
        ]


childSelecter =
    [ test "getChildrenHelp" <|
        \_ ->
            let
                got =
                    Main.getChildrenHelp
                        (Set.fromList [0, 1, 2])
                        1
                        "a"
                expected =
                    True
            in
                Expect.equal got expected
                    
    , test "getChildrenOf" <|
        \_ ->
            let
                got =
                    Main.getChildrenOf
                        0
                        (Dict.fromList [(1, "a"), (2, "b"), (3, "d")])
                        (Dict.fromList [(4, 5), (2, 0), (3, 0)])
                expected =
                    Dict.fromList [(2, "b"), (3, "d")]
            in
                Expect.equal got expected
    ]


folderDecoder =
    [ test "simple folder decoder" <|
        \_ ->
            Expect.ok <|
                Jd.decodeString
                    Main.decodeFolders
                    F.audienceFoldersJSON
    , fuzz folderFuzz "fuzz encode-decode for folder" <|
        \randomFolder ->
            Expect.ok <|
                Jd.decodeString
                    Main.decodeOneFolder
                    (encodeFolder randomFolder)
    ]


audienceDecoder =
    [ test "simple decode audiences" <|
        \_ ->
            Expect.ok <|
                Jd.decodeString
                    Main.decodeAudiences
                    A.audiencesJSON
    , fuzz audienceFuzz "fuzz encode-decode for audience" <|
        \randomAudience ->
            Expect.ok <|
                Jd.decodeString
                    Main.decodeOneAudience
                    (encodeAudience randomAudience)
    ]


audienceFuzz : Fuzz.Fuzzer A.Audience
audienceFuzz =
    Fuzz.map4 A.Audience
        Fuzz.int
        Fuzz.string
        (Fuzz.oneOf <|
            List.map Fuzz.constant [ A.Curated, A.Shared, A.Authored ]
        )
        (Fuzz.maybe Fuzz.int)


folderFuzz : Fuzz.Fuzzer F.AudienceFolder
folderFuzz =
    Fuzz.map3 F.AudienceFolder
        Fuzz.int
        Fuzz.string
        (Fuzz.maybe Fuzz.int)


encodeType : A.AudienceType -> Je.Value
encodeType type_ =
    case type_ of
        A.Authored ->
            Je.string "user"

        A.Shared ->
            Je.string "shared"

        A.Curated ->
            Je.string "curated"


encodeFolder : F.AudienceFolder -> String
encodeFolder { id, name, parent } =
    Je.encode 4 <|
        Je.object <|
            [ ( "id", Je.int id )
            , ( "name", Je.string name )
            , ( "parent", encodeParent parent )
            ]


encodeParent : Maybe Int -> Je.Value
encodeParent maybe =
    case maybe of
        Nothing ->
            Je.null

        Just parent ->
            Je.int parent


encodeAudience : A.Audience -> String
encodeAudience { id, name, type_, folder } =
    Je.encode 4 <|
        Je.object <|
            [ ( "id", Je.int id )
            , ( "name", Je.string name )
            , ( "type", encodeType type_ )
            ]
                ++ (case folder of
                        Nothing ->
                            []

                        Just i ->
                            [ ( "folder", Je.int i ) ]
                   )
