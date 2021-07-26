module Tests exposing (..)

import Data.Audience as A
import Expect exposing (Expectation)
import Fuzz
import Json.Decode as Jd
import Json.Encode as Je
import Main
import Test exposing (..)


suite : Test
suite =
    describe "audience decoder"
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


encodeType : A.AudienceType -> Je.Value
encodeType type_ =
    case type_ of
        A.Authored ->
            Je.string "user"

        A.Shared ->
            Je.string "shared"

        A.Curated ->
            Je.string "curated"


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
