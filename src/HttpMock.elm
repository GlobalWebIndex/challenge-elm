module HttpMock exposing (task)

import Error exposing (Error)
import Json.Decode as Decode exposing (Decoder)
import Task exposing (Task)


task : String -> Decoder a -> Task Error a
task jsonResponse decoder =
    case Decode.decodeString decoder jsonResponse of
        Err error ->
            Task.fail <| Error.DecoderError (Decode.errorToString error)

        Ok value ->
            Task.succeed value
