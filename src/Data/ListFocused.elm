module Data.ListFocused exposing (ListFocused, ListWithHole(..), expFunc, focus, focusIn, stepLeft, stepRight, walkLeft, walkRight)


type ListWithHole a
    = ListWithHole (List a) (List a)


type alias ListFocused a =
    ( ListWithHole a, a )


focus : List a -> Maybe (ListFocused a)
focus list =
    case list of
        [] ->
            Nothing

        x :: xs ->
            Just ( ListWithHole [] xs, x )


stepLeft : ListFocused a -> Maybe (ListFocused a)
stepLeft ( ListWithHole leftOfHole rightOfHole, focused ) =
    case List.reverse leftOfHole of
        [] ->
            Nothing

        x :: xs ->
            Just ( ListWithHole (List.reverse xs) (focused :: rightOfHole), x )


stepRight : ListFocused a -> Maybe (ListFocused a)
stepRight ( ListWithHole leftOfHole rightOfHole, focused ) =
    case rightOfHole of
        [] ->
            Nothing

        x :: xs ->
            Just ( ListWithHole (leftOfHole ++ [ focused ]) xs, x )


walkLeft : Int -> ListFocused a -> Maybe (ListFocused a)
walkLeft n lf =
    expFunc n (Maybe.andThen stepLeft) (Just lf)


walkRight : Int -> ListFocused a -> Maybe (ListFocused a)
walkRight n lf =
    expFunc n (Maybe.andThen stepRight) (Just lf)


focusIn : Int -> List a -> Maybe (ListFocused a)
focusIn n =
    focus >> Maybe.andThen (walkRight n)



-- rename


expFunc : Int -> (a -> a) -> a -> a
expFunc times f x =
    case times of
        0 ->
            x

        n ->
            if n > 0 then
                expFunc (n - 1) f (f x)

            else
                x
