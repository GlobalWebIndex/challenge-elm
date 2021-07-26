module Example exposing (..)

import Data.Audience
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Json.Decode as Jd
import Main
import Test exposing (..)


suite : Test
suite =
    describe "audience decoder"
        [ test "simple decode audiences" <|
            \_ ->
                Expect.notEqual
                    Nothing
                    (Jd.decodeString
                        Main.decodeAudiences
                        Data.Audience.audiencesJSON
                    )
        ]
