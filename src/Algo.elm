module Algo exposing (..)
import Data.Audience exposing (Audience)
import Data.AudienceFolder exposing (AudienceFolder)

import Basics.Extra exposing (flip)



type SimpleFolder
  = SimpleFolder (List Audience) (List SimpleFolder) { id : Maybe Int, name : Maybe String, parent : Maybe Int }




build = flip buildSimple <| Nothing


-- this function will start with folder which do not belong anywhere
-- and items which do not belong anywhere
-- it will filter them out and put them into the current level
-- then it will take what's left and call buildSimple2 for each folder it found in the previous step
-- giving at the id for that particular folder
buildSimple : (List Audience, List AudienceFolder) -> Maybe Int -> (Maybe Int, Maybe String) -> SimpleFolder
buildSimple (audiences, audienceFolders) parent (current, n) =
  let
      (myAudiences, audiencesLeft) = List.partition (.folder >> ((==) current)) audiences
      (myAudienceFolders, foldersLeft) = List.partition (.parent >> ((==) current)) audienceFolders
      simpleFolders = List.map (buildSimple (audiencesLeft, foldersLeft) current) <| List.map (\ {id, name} -> (Just id, Just name)) myAudienceFolders
      node = SimpleFolder myAudiences simpleFolders { id = current, name = n, parent = parent }
  in  node
