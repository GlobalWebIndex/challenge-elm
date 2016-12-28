module Data.Json.Audience exposing (audienceDecoder)

import Data.Json.Utils exposing (ref)
import Json.Decode as JD exposing (andThen, (:=))
import Data.Audience exposing (..)


{-|

Doing some data exploration with lodash (sorry for the heresy :-)
there are several types of audiences.

The transformation below:

    _.chain(a)
      .map(function (a) { return _.pick(a, "type", "curated", "shared"); })
      .map(function (a) { return JSON.stringify(a); })
      .reduce(function (a, b) { a[b]=(a[b] || 0) +1; return a; }, {})
      .value()

produces the following unique combinations along with its counts:

    {"type":"curated","curated":true,"shared":false} : 156
    {"type":"curated","curated":true,"shared":null}  : 7
    {"type":"shared","curated":false,"shared":true}  : 10
    {"type":"shared","curated":null,"shared":true}   : 30
    {"type":"user","curated":null,"shared":false}    : 9

I'll assume the type field is enough to distinguish the audience type where
the value "user" translates to Authored, "curated" to Curated and "shared"
to Shared.
-}
audienceTypeDecoder : JD.Decoder AudienceType
audienceTypeDecoder =
    let
        typeBuilder tag =
            case tag of
                "curated" ->
                    JD.succeed Curated

                "shared" ->
                    JD.succeed Shared

                "user" ->
                    JD.succeed Authored

                _ ->
                    JD.fail ("Invalid type: " ++ tag)
    in
        JD.string `andThen` typeBuilder


{-| Json decoder for an Audience value
-}
audienceDecoder : JD.Decoder Audience
audienceDecoder =
    JD.object4 Audience
        ("id" := JD.int)
        ("name" := JD.string)
        ("type" := audienceTypeDecoder)
        ("folder" := ref)
