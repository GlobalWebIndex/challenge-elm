module Data.List.Utility exposing (splitFilter)


splitFilter : (a -> Bool) -> List a -> ( List a, List a )
splitFilter check =
    List.foldl
        (\x ->
            (if check x then
                Tuple.mapFirst

             else
                Tuple.mapSecond
            )
                (\xs -> x :: xs)
        )
        ( [], [] )
