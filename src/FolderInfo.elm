module FolderInfo exposing (FolderInfo(..))

import Data.Audience exposing (Audience)


type FolderInfo
    = Info { audiences : List Audience, name : String, id : Maybe Int }
