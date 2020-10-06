module Request exposing
    ( Request(..)
    , andMap
    , map
    , map2
    )


type Request a
    = Loading
    | Success a
    | Failure


map : (a -> b) -> Request a -> Request b
map f ra =
    case ra of
        Success a ->
            Success <| f a

        Loading ->
            Loading

        Failure ->
            Failure


andMap : Request a -> Request (a -> b) -> Request b
andMap ra rf =
    case ( ra, rf ) of
        ( Success a, Success f ) ->
            Success <| f a

        ( Loading, _ ) ->
            Loading

        ( _, Loading ) ->
            Loading

        ( Failure, _ ) ->
            Failure

        ( _, Failure ) ->
            Failure


map2 : (a -> b -> c) -> Request a -> Request b -> Request c
map2 f ra rb =
    Success f
        |> andMap ra
        |> andMap rb
