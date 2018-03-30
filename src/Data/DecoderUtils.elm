module Data.DecoderUtils exposing (..)

import Json.Decode exposing (Decoder, Value, decodeValue, keyValuePairs, value)


partialDecodeField : Decoder (List ( String, Value ))
partialDecodeField =
    keyValuePairs value


fromResultRecord : (String -> b -> Decoder b) -> ( String, Value ) -> b -> b
fromResultRecord decoder ( name, value ) record =
    case decodeValue (decoder name record) value of
        Ok newRecord ->
            newRecord

        Err error ->
            Debug.log ("[Warning]: " ++ error ++ " for name = " ++ name ++ ", value = " ++ toString value) record
