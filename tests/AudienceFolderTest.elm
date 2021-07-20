module AudienceFolderTest exposing (..)

import Data.AudienceFolder exposing (audienceFoldersDecoder, audienceFoldersJSON)
import Expect
import Json.Decode as Decode
import Test exposing (..)


suite : Test
suite =
    describe "Parse audiencefolders"
        [ test "Audiencefolders length" <|
            \_ ->
                Decode.decodeString audienceFoldersDecoder audienceFoldersJSON
                    |> (\res ->
                            case res of
                                Result.Ok list ->
                                    Debug.log "Parsed list" list

                                Result.Err _ ->
                                    []
                       )
                    |> List.length
                    |> Expect.equal 5
        , test "Audiences id" <|
            \_ ->
                Decode.decodeString audienceFoldersDecoder audienceFoldersJSON
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
                    |> (\firstId -> Expect.equal 357 firstId)
        ]
