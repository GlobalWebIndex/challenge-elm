module Label exposing (Label(..))


import Data.Audience exposing (Audience)


type Label = Label { audiences : List Audience, name : String, id : Maybe Int }
