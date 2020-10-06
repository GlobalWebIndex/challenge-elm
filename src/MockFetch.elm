module MockFetch exposing (mockFetch)

import Json.Decode as D exposing (Decoder)
import Process
import Task


mockFetch : String -> (Result D.Error a -> msg) -> Decoder a -> Cmd msg
mockFetch data toMsg decoder =
    Process.sleep 500
        |> Task.andThen
            (\_ ->
                Task.succeed <| D.decodeString decoder data
            )
        |> Task.perform toMsg
