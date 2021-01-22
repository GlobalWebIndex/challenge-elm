module Error exposing (Error(..), message, title)


type Error
    = DecoderError String


title : Error -> String
title error =
    case error of
        DecoderError _ ->
            "Decoder Error"


message : Error -> String
message error =
    case error of
        DecoderError e ->
            e
