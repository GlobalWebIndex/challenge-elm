module Data.Decoded exposing (audiencesList, audienceFolderList)


import Decoder.AudienceDecoder as AD
import Decoder.FolderDecoder as FD

import Data.Audience exposing (audiencesJSON)
import Data.AudienceFolder exposing (audienceFoldersJSON)


audiencesList = case AD.decode audiencesJSON of
                    Ok aud -> aud
                    _ -> []


audienceFolderList = case FD.decode audienceFoldersJSON of
                        Ok folds -> folds
                        _ -> []

