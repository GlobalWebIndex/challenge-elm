module Data.Expression exposing (..)

import Data.DecoderUtils exposing (fromResultRecord, partialDecodeField)
import Json.Decode exposing (..)
import Json.Decode.Extra exposing ((|:), parseInt)


orJson : String
orJson =
    """
    {
        "or": [
            {
                "options": [
                    "q2157_8"
                ],
                "question": "q2157"
            }
        ]
    }
"""


orNotJson : String
orNotJson =
    """
    {
        "or": [
            {
                "options": [
                    "r2021e_46"
                ],
                "question": "r2021e",
                "not": true
            }
        ]
    }
"""


andJson : String
andJson =
    """
    {
        "and": [
            {
                "options": [
                    "q126i_22"
                ],
                "question": "q126i"
            }
        ]
    }
"""


recursiveMoreJson : String
recursiveMoreJson =
    """
    {
        "and": [
            {
                "options": [
                    "q25_6"
                ],
                "question": "q25",
                "not": true
            },
            {
                "or": [
                    {
                        "options": [
                            "r2021d_2"
                        ],
                        "question": "r2021d"
                    },
                    {
                        "options": [
                            "r2021e_2"
                        ],
                        "question": "r2021e"
                    }
                ]
            },
            {
                "options": [
                    "q8_2",
                    "q8_3",
                    "q8_4"
                ],
                "question": "q8"
            },
            {
                "and": [
                    {
                        "options": [
                            "r2021d_46"
                        ],
                        "question": "r2021d",
                        "not": true
                    },
                    {
                        "options": [
                            "r2021e_46"
                        ],
                        "question": "r2021e",
                        "not": true
                    }
                ]
            },
            {
                "options": [
                    "q311_4",
                    "q311_3",
                    "q311_2",
                    "q311_1"
                ],
                "question": "q311",
                "suffixes": [
                    2
                ]
            },
            {
                "options": [
                    "q2021a_2",
                    "q2021a_4",
                    "q2021a_5",
                    "q2021a_25",
                    "q2021a_28",
                    "q2021a_38",
                    "q2021a_42",
                    "q2021a_46"
                ],
                "question": "q2021a",
                "min_count": "4"
            }
        ]
    }
"""


recursiveJson : String
recursiveJson =
    """
    {
        "and": [
            {
                "options": [
                    "q25_6"
                ],
                "question": "q25",
                "not": true
            },
            {
                "or": [
                    {
                        "options": [
                            "r2021d_2"
                        ],
                        "question": "r2021d"
                    },
                    {
                        "options": [
                            "r2021e_2"
                        ],
                        "question": "r2021e"
                    }
                ]
            },
            {
                "options": [
                    "q8_2",
                    "q8_3",
                    "q8_4"
                ],
                "question": "q8"
            },
            {
                "and": [
                    {
                        "options": [
                            "r2021d_46"
                        ],
                        "question": "r2021d",
                        "not": true
                    },
                    {
                        "options": [
                            "r2021e_46"
                        ],
                        "question": "r2021e",
                        "not": true
                    }
                ]
            },
            {
                "options": [
                    "q311_4",
                    "q311_3",
                    "q311_2",
                    "q311_1"
                ],
                "question": "q311"
            }
        ]
    }
"""


type Expression
    = RootOr (List BranchOrLeaf)
    | RootAnd (List BranchOrLeaf)


defaultExpression : Expression
defaultExpression =
    RootOr []


expressionDecoder : Decoder Expression
expressionDecoder =
    oneOf
        [ field "or"
            (map
                RootOr
                (list branchOrLeafDecoder)
            )
        , field "and"
            (map
                RootAnd
                (list branchOrLeafDecoder)
            )
        ]


branchOrLeafDecoder : Decoder BranchOrLeaf
branchOrLeafDecoder =
    oneOf
        [ field "and"
            (map
                Or
                (list
                    (lazy (\_ -> branchOrLeafDecoder))
                )
            )
        , field "or"
            (map
                And
                (list
                    (lazy (\_ -> branchOrLeafDecoder))
                )
            )
        , map Item optionsQuestionNotDecoder
        ]


optionsQuestionJson : String
optionsQuestionJson =
    """
    {
        "options": [
            "q25_6"
        ],
        "question": "q25"
    }
"""


type alias OptionsQuestionNot =
    { options : List String
    , question : String
    , not : Maybe Bool
    , minCount : Maybe Int
    , suffixes : List Int
    }


defaultOptionsQuestionNot : OptionsQuestionNot
defaultOptionsQuestionNot =
    OptionsQuestionNot [] "" Nothing Nothing []


type BranchOrLeaf
    = Item OptionsQuestionNot
    | Or (List BranchOrLeaf)
    | And (List BranchOrLeaf)


serverResponseMy : String
serverResponseMy =
    """
    {
        "options": [
            "option1",
            "option2",
            "option3"
        ],
        "question": "some qestion",
        "not": true,
        "min_count": "3",
        "suffixes": [
            1,
            2,
            3
        ],
        "somefield": 1
    }
"""


feedNameL : (String -> OptionsQuestionNot -> Decoder OptionsQuestionNot) -> List ( String, Value ) -> OptionsQuestionNot
feedNameL decoder elements =
    List.foldl (fromResultRecord decoder) defaultOptionsQuestionNot elements


optionsQuestionNotDecoder : Decoder OptionsQuestionNot
optionsQuestionNotDecoder =
    map (feedNameL decodeField) partialDecodeField


decodeField : String -> OptionsQuestionNot -> Decoder OptionsQuestionNot
decodeField name record =
    case name of
        "options" ->
            succeed (\value -> { record | options = value }) |: list string

        "question" ->
            succeed (\value -> { record | question = value }) |: string

        "not" ->
            succeed (\value -> { record | not = value }) |: maybe bool

        "min_count" ->
            succeed (\value -> { record | minCount = value }) |: maybe parseInt

        "suffixes" ->
            succeed (\value -> { record | suffixes = value }) |: list int

        _ ->
            fail <| "Unhandled field " ++ name



-- TODO: Tests
-- , div [] [ text <| toString <| decodeString expressionDecoder orJson ]
-- , div [] [ text <| toString <| decodeString expressionDecoder orNotJson ]
-- , div [] [ text <| toString <| decodeString expressionDecoder andJson ]
-- , div [] [ text <| toString <| decodeString expressionDecoder recursiveJson ]
-- , div [] [ text <| toString <| decodeString expressionDecoder recursiveMoreJson ]
-- , div [] [ text <| toString <| decodeString optionsQuestionNotDecoder serverResponseMy ]
