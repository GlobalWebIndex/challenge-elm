module Json.Decode.Applicative exposing (apply, unlift)

{-| Json.Decode.Applicative module

This module implements typeclass applicative (apply : m (a -> b) -> m a -> m b)
for Decoder functor

In terms of Monadic return (succeed) and bind (andThen) it's:
apply : Decoder (a -> b) -> Decoder a -> Decoder b
apply df da = andThen (\\a -> andThen (\\f -> succeed (f a)) df) da

-}

import Json.Decode exposing (Decoder, map2)
import Utility exposing (flip)


apply : Decoder a -> Decoder (a -> b) -> Decoder b
apply =
    map2 (|>)


unlift =
    flip apply
