module Decoder.AudienceDecoder exposing (..)


import Json.Decode as Decode exposing (Decoder)


import Data.Audience exposing ( AudienceType(..), Audience)


example = """{
                "id": 104,
                "name": "Food Lovers",
                "expression": {
                    "or": [
                        {
                            "options": [
                                "q25_6"
                            ],
                            "question": "q25"
                        }
                    ]
                },
                "curated": true,
                "type": "curated",
                "shared": false,
                "category": "Audiences",
                "folder": 358
            }"""


debug = Decode.decodeString decodeAudience example


decode : String -> Result Decode.Error (List Audience)
decode = Decode.decodeString <| Decode.field "data" decodeAudiences


decodeAudiences : Decoder (List Audience)
decodeAudiences = Decode.list decodeAudience


decodeAudience : Decoder Audience
decodeAudience = 
  Decode.map4 Audience
    decodeId
    decodeName
    decodeType
    decodeFolder


decodeId : Decoder Int
decodeId = Decode.field "id" Decode.int


decodeName : Decoder String
decodeName = Decode.field "name" Decode.string


decodeType : Decoder AudienceType
decodeType = Decode.field "type" decodeAudienceType


decodeAudienceType : Decoder AudienceType
decodeAudienceType =
  Decode.string |> Decode.andThen
                    (\ str -> case str of
                                "user" -> Decode.succeed Authored
                                "curated" -> Decode.succeed Curated
                                "shared" -> Decode.succeed Shared
                                tag -> Decode.fail <| "Invalid Audience Type: '" ++ tag ++ "'")


decodeFolder : Decoder (Maybe Int)
decodeFolder = Decode.field "folder" (Decode.maybe Decode.int)
