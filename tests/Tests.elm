module Tests exposing (..)

import Data.Audience as A
import Data.AudienceFolder as F
import Dict
import Expect exposing (Expectation)
import Fuzz
import Json.Decode as Jd
import Json.Encode as Je
import Main
import Parser as P
import Set
import Test exposing (..)


suite : Test
suite =
    describe "all tests"
        [ describe "audience decoder" audienceDecoder
        , describe "folder decoder" folderDecoder
        ]


folderDecoder : List Test
folderDecoder =
    [ test "simple folder decoder" <|
        \_ ->
            Expect.ok <|
                Jd.decodeString
                    P.decodeFolders
                    F.audienceFoldersJSON
    , fuzz folderFuzz "fuzz encode-decode for folder" <|
        \randomFolder ->
            Expect.ok <|
                Jd.decodeString
                    P.decodeOneFolder
                    (encodeFolder randomFolder)
    ]


audienceDecoder : List Test
audienceDecoder =
    [ test "simple decode audiences" <|
        \_ ->
            Expect.ok <|
                Jd.decodeString
                    P.decodeAudiences
                    A.audiencesJSON
    , fuzz audienceFuzz "fuzz encode-decode for audience" <|
        \randomAudience ->
            Expect.ok <|
                Jd.decodeString
                    P.decodeOneAudience
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
