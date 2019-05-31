module Json.Decode.Applicative exposing (apply, with)

{-| Json.Decode.Applicative module

This module implements typeclass applicative (apply : m (a -> b) -> a -> b)
for Decoder functor based on the monadic return (succeed) and bind (andThen)

-}

import Json.Decode exposing (Decoder, andThen, succeed)


apply : Decoder (a -> b) -> Decoder a -> Decoder b
apply df da =
    andThen (\a -> andThen (\f -> succeed (f a)) df) da


with da df =
    apply df da
