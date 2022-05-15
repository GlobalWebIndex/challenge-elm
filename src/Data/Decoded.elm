module Data.Decoded exposing (audienceFolderList, audiencesList)

import Data.Audience exposing (audiencesJSON)
import Data.AudienceFolder exposing (audienceFoldersJSON)
import Decoder.AudienceDecoder as AD
import Decoder.FolderDecoder as FD


audiencesList =
    case AD.decode audiencesJSON of
        Ok aud ->
            aud

        _ ->
            []


audienceFolderList =
    case FD.decode audienceFoldersJSON of
        Ok folds ->
            folds

        _ ->
            []
