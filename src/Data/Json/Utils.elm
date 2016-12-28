module Data.Json.Utils exposing (..)

import Json.Decode as JD


{-| Decodes an optional reference by id
-}
ref : JD.Decoder (Maybe Int)
ref =
    JD.oneOf
        [ JD.null Nothing
        , JD.map Just JD.int
        ]
