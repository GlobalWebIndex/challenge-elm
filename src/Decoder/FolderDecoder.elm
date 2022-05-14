module Decoder.FolderDecoder exposing (..)


import Json.Decode as Decode exposing (Decoder)

import Data.AudienceFolder exposing (AudienceFolder)


example : String
example = """   { "id": 357
                , "name": "Demographics"
                , "curated": true
                , "parent": null } """


debug = Decode.decodeString decodeFolder example


decode : String -> Result Decode.Error (List AudienceFolder)
decode = Decode.decodeString <| Decode.field "data" <| Decode.list decodeFolder


decodeFolder : Decoder AudienceFolder
decodeFolder =
    Decode.map3 AudienceFolder
        decodeId
        decodeName
        decodeParent


decodeId : Decoder Int
decodeId = Decode.field "id" Decode.int


decodeName : Decoder String
decodeName = Decode.field "name" Decode.string


decodeParent : Decoder (Maybe Int)
decodeParent = Decode.field "parent" (Decode.maybe Decode.int)
