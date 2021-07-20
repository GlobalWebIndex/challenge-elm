module Data.DecodeUtil exposing (..)

import Json.Decode as Decode


{-| Decoder to decode json object that has "data" key with a list of objects
-}
dataListDecoder : Decode.Decoder a -> Decode.Decoder (List a)
dataListDecoder decoder =
    Decode.field "data" (Decode.list decoder)
