module DecoderTests exposing(..)

import Data.Decoder     exposing(decodeAudience)
import Expect
import Json.Decode      exposing(decodeString)
import Test             exposing(..)



audienceDecoderTests : Test
audienceDecoderTests =
    describe "Audience API decoder"
        [ describe "valid audience types"
              [ test "Authored" <|
                    \_ ->
                        Expect.ok <| decodeString decodeAudience """ {
                           "id": 104,
                           "name": "Food Lovers",
                           "type": "user",
                           "folder": 358
                         } """

              , test "Shared" <|
                  \_ ->
                        Expect.ok <| decodeString decodeAudience """ {
                           "id": 104,
                           "name": "Food Lovers",
                           "type": "shared",
                           "folder": 358
                         } """

              , test "Curated" <|
                  \_ ->
                        Expect.ok <| decodeString decodeAudience """ {
                           "id": 104,
                           "name": "Food Lovers",
                           "type": "curated",
                           "folder": 358
                         } """
              ]

        , test "Invalid audience type" <|
            \_ ->
                Expect.err <| decodeString decodeAudience """ {
                           "id": 104,
                           "name": "Food Lovers",
                           "type": "some-unknown-type",
                           "folder": 358
                         } """

        , test "null folder" <|
            \_ ->
                case decodeString decodeAudience """ {
                           "id": 104,
                           "name": "Food Lovers",
                           "type": "shared",
                           "folder": null
                         } """ of
                    Ok audience ->
                        if audience.folder == Nothing then
                            Expect.pass
                        else
                            Expect.fail "unexpected folder"
                    _ ->
                        Expect.fail "test case parse failed"

        , test "missing folder" <|
            \_ ->
                case decodeString decodeAudience """ {
                           "id": 104,
                           "name": "Food Lovers",
                           "type": "shared"
                         } """ of
                    Ok audience ->
                        if audience.folder == Nothing then
                            Expect.pass
                        else
                            Expect.fail "unexpected folder"
                    _ ->
                        Expect.fail "test case parse failed"
        ]
