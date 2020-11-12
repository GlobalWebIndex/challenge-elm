
module Json.Decode.Helpers exposing ( collapseError )

import Json.Decode as D exposing ( Decoder )

collapseError : Decoder (Result e a) -> (e -> String) -> Decoder a
collapseError decoder stringOfErrorMessage =
  D.andThen (\mx ->
      case mx of
        Ok x -> D.succeed x
        Err e -> D.fail (stringOfErrorMessage e)
    )
    decoder
