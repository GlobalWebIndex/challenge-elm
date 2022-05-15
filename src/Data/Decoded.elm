module Data.Decoded exposing (audienceFolderList, audiencesList)

import Data.Audience exposing (audiencesJSON)
import Data.AudienceFolder exposing (audienceFoldersJSON)
import Decoder.AudienceDecoder as AD
import Decoder.FolderDecoder as FD
import Data.AudienceFolder exposing (AudienceFolder)
import Data.Audience exposing (Audience)


{- NOTE:    I use this module just to put those two data structures somewhere.
            In real world, they would be hidden inside a corresponding effect-handling function which got the data.
 -}


audiencesList : List Audience
audiencesList =
    case AD.decode audiencesJSON of
        Ok aud ->
            aud

        _ ->
            []


audienceFolderList : List AudienceFolder
audienceFolderList =
    case FD.decode audienceFoldersJSON of
        Ok folds ->
            folds

        _ ->
            []
