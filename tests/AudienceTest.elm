module AudienceTest exposing (..)

import Data.Audience exposing (audiencesDecoder, audiencesJSON)
import Expect
import Json.Decode as Decode
import Test exposing (..)


suite : Test
suite =
    describe "Parse audiences"
        [ test "Audiences length" <|
            \_ ->
                Decode.decodeString audiencesDecoder audiencesJSON
                    |> (\res ->
                            case res of
                                Result.Ok list ->
                                    list

                                Result.Err _ ->
                                    []
                       )
                    |> List.length
                    |> Expect.equal 212
        , test "Audiences id" <|
            \_ ->
                Decode.decodeString audiencesDecoder audiencesJSON
                    |> (\res ->
                            case res of
                                Result.Ok list ->
                                    Debug.log "Res list" list

                                Result.Err _ ->
                                    []
                       )
                    |> List.head
                    |> Maybe.map .id
                    |> Maybe.withDefault 0
                    |> (\firstId -> Expect.equal 104 firstId)
        ]
