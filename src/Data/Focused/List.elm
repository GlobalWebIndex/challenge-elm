module Data.Focused.List exposing (ListFocused, ListWithHole(..), expFunc, focus, focusAt, stepLeft, stepRight, walkLeft, walkRight)


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



-- it would be more suiting to use Nat instead of Int int the following functions
-- but I suspect that it is not usually used in the Elm community and the need to always
-- import it and use Nat.fromInt when providing arguments is probably not worth it


walkLeft : Int -> ListFocused a -> Maybe (ListFocused a)
walkLeft n lf =
    if n < 0 then
        walkRight -n lf

    else
        expFunc n (Maybe.andThen stepLeft) (Just lf)


walkRight : Int -> ListFocused a -> Maybe (ListFocused a)
walkRight n lf =
    if n < 0 then
        walkLeft -n lf

    else
        expFunc n (Maybe.andThen stepRight) (Just lf)


focusAt : Int -> List a -> Maybe (ListFocused a)
focusAt n =
    if n < 0 then
        \_ -> Nothing

    else
        focus >> Maybe.andThen (walkRight n)



-- TODO: rename expFunc and move elsewhere


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
