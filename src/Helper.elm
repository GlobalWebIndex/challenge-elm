module Helper exposing (..)

trim: String -> Int -> String
trim string len =
    if String.length string > len then
       String.slice 0 len string ++ ".."
    else
        string
