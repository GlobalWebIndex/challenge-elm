module Data.AudienceTree exposing
    ( AudienceTree
    , DuplicatedIdFolder
    , Errors
    , audiences
    , children
    , fromAudiencesAndFolders
    , name
    )

import Data.Audience exposing (Audience)
import Data.AudienceFolder exposing (AudienceFolder)
import Dict exposing (Dict)


type AudienceTree
    = AudienceTree AudienceTreeInternal


type alias AudienceTreeInternal =
    { name : String
    , children : List AudienceTree
    , audiences : List String
    }


children : AudienceTree -> List AudienceTree
children (AudienceTree a) =
    a.children


name : AudienceTree -> String
name (AudienceTree a) =
    a.name


audiences : AudienceTree -> List String
audiences (AudienceTree a) =
    a.audiences


type alias Errors =
    { duplicatedFolderIds : List DuplicatedIdFolder
    , missingFolderId : List MissingParentAudience
    , missingFolderParentId : List MissingParentFolder
    }


{-| Build the audience tree from the lists of audiences and audience folders.
It will always succeed to build some Tree, even if some ids are inconsistent.
E.g. if an audience folder references a non-existing folder, this audience is directly
added to the root, and this audience is added to the `missingFolderId` field.
-}
fromAudiencesAndFolders : List Audience -> List AudienceFolder -> ( AudienceTree, Errors )
fromAudiencesAndFolders audiences_ folders =
    let
        step3result =
            step1 folders
                |> step2 audiences_
                |> step3
    in
    ( step3result.audienceTree
    , { duplicatedFolderIds = step3result.duplicatedFolderIds
      , missingFolderId = step3result.missingFolderId
      , missingFolderParentId = step3result.missingFolderParentId
      }
    )



-- STEP 1
--
-- Transform the list of `AudienceFolder` into a dictionnary `Id -> PendingFolder`
-- each `PendingFolder` being "empty": only name and parent are provided.
--
-- It would be problematic if multiple folders share the same id `I`. If an audience
-- belongs to `I`, to what folder should we put it? If we encounter
-- such a case, only the first folder is kept and we keep track of those problematic folders
-- in the `duplicatedFolderIds` list.


type alias Step1Result =
    { root : PendingRootFolder
    , otherFolders : Dict Int PendingFolder
    , duplicatedFolderIds : List DuplicatedIdFolder
    }



-- A PendingFolder is a temporary value used to build the final tree.
-- It will accumulate all the audiences belonging to it (during the "STEP 2")


type alias PendingFolder =
    { id : Int
    , name : String
    , audiences : List String
    , parent : Maybe Int
    }


type alias DuplicatedIdFolder =
    { name : String
    , duplicates : PendingFolder
    }


type alias PendingRootFolder =
    { name : String
    , audiences : List String
    }


step1 : List AudienceFolder -> Step1Result
step1 folders =
    List.foldl
        (\folder ( others, duplicated ) ->
            case Dict.get folder.id others of
                Nothing ->
                    ( Dict.insert folder.id
                        { id = folder.id
                        , name = folder.name
                        , audiences = []
                        , parent = folder.parent
                        }
                        others
                    , duplicated
                    )

                Just pendingFolder ->
                    ( others
                    , { name = folder.name
                      , duplicates = pendingFolder
                      }
                        :: duplicated
                    )
        )
        ( Dict.empty, [] )
        folders
        |> (\( others, duplicated ) ->
                { root =
                    { name = "Root"
                    , audiences = []
                    }
                , otherFolders = others
                , duplicatedFolderIds = duplicated
                }
           )



-- STEP 2
--
-- In this step, we add all the audiences to their corresponding PendingFolder.
-- If the folder indicated in the audience record doesn't exist, the audience
-- is assigned to root and we keep track of this audience in the
-- `missingFolderId` list.
--
-- This step has to be performed AFTER the previous one (we have to know all the
-- folders ids). This is "softly constrained" by the fact that the `step2`
-- function takes `Step1Result` as argument (we might use some opaque type technique
-- to have a "hard constaint" about function call order but this would split the process
-- across multiple files which doesn't seem to worth it for such a small project).


type alias Step2Result =
    { root : PendingRootFolder
    , otherFolders : Dict Int PendingFolder
    , duplicatedFolderIds : List DuplicatedIdFolder
    , missingFolderId : List MissingParentAudience
    }


type alias MissingParentAudience =
    { name : String
    , parent : Int
    , id : Int
    }


step2 :
    List Audience
    -> Step1Result
    -> Step2Result
step2 audiences_ step1result =
    List.foldl
        (\audience ( root, others, missing ) ->
            case audience.folder of
                Nothing ->
                    ( { root | audiences = audience.name :: root.audiences }
                    , others
                    , missing
                    )

                Just parentId ->
                    case Dict.get parentId others of
                        Just pendingFolder ->
                            ( root
                            , Dict.insert parentId
                                (addAudienceToFolder audience pendingFolder)
                                others
                            , missing
                            )

                        Nothing ->
                            --  The folder doesn't exist. So we add the audience
                            -- in root and we trace the error
                            ( { root | audiences = audience.name :: root.audiences }
                            , others
                            , { name = audience.name
                              , id = audience.id
                              , parent = parentId
                              }
                                :: missing
                            )
        )
        ( step1result.root
        , step1result.otherFolders
        , []
        )
        audiences_
        |> (\( root, others, missing ) ->
                { root = root
                , otherFolders = others
                , missingFolderId = missing
                , duplicatedFolderIds = step1result.duplicatedFolderIds
                }
           )


addAudienceToFolder : Audience -> PendingFolder -> PendingFolder
addAudienceToFolder audience pendingFolder =
    { pendingFolder | audiences = audience.name :: pendingFolder.audiences }



-- STEP 3
--
-- We finally build the audience tree.
--
-- This has to be done AFTER the step 2. Again, this is "softly constrained" because
-- `rearrangePendingFolder` takes `Step2Result` as argument.
--
-- We also track the missing folder id when a parent doesn't exist. In this case
-- the folder is added to the root.
--
-- This step is a bit tricky if we don't want to pay a quadratic complexity.
-- It might be quite easier if we were able to mutate things but, hey, we can't in
-- elm!
--
-- The main idea of the algorithm is:
-- 1. Build a `Parent -> List Children` dictionary  (we can perform this in 1 pass,
--    complexity O(n ln(n)) since Dict accesses are logarithmic -- it would be O(n)
--    if elm used some kind of HasMap for Dict)
-- 2. Starting from the root, recursively build the children using the previous map.
--    The complexity still is O(n ln(n)).


type alias Step3Result =
    { audienceTree : AudienceTree
    , duplicatedFolderIds : List DuplicatedIdFolder
    , missingFolderId : List MissingParentAudience
    , missingFolderParentId : List MissingParentFolder
    }


type alias MissingParentFolder =
    { name : String
    , id : Int
    , parent : Int
    }


step3 : Step2Result -> Step3Result
step3 step2result =
    let
        childrenByParent =
            toChildrenByParent step2result
    in
    { audienceTree =
        AudienceTree
            { name = step2result.root.name
            , audiences = List.sort step2result.root.audiences
            , children = buildChildrenTree childrenByParent
            }
    , duplicatedFolderIds = step2result.duplicatedFolderIds
    , missingFolderId = step2result.missingFolderId
    , missingFolderParentId = childrenByParent.missingFolderParentId
    }


type alias ChildrenByParent =
    { rootChildren : List PendingFolder
    , otherChildren : Dict Int (List PendingFolder)
    , missingFolderParentId : List MissingParentFolder
    }


toChildrenByParent : Step2Result -> ChildrenByParent
toChildrenByParent step2result =
    let
        helper : PendingFolder -> ChildrenByParent -> ChildrenByParent
        helper pendingFolder acc =
            case pendingFolder.parent of
                Nothing ->
                    { acc | rootChildren = pendingFolder :: acc.rootChildren }

                Just parentId ->
                    if Dict.member parentId step2result.otherFolders then
                        { acc
                            | otherChildren =
                                Dict.update parentId
                                    (\maybeList ->
                                        case maybeList of
                                            Nothing ->
                                                Just [ pendingFolder ]

                                            Just list ->
                                                Just (pendingFolder :: list)
                                    )
                                    acc.otherChildren
                        }

                    else
                        { acc
                            | rootChildren = pendingFolder :: acc.rootChildren
                            , missingFolderParentId =
                                { name = pendingFolder.name
                                , id = pendingFolder.id
                                , parent = parentId
                                }
                                    :: acc.missingFolderParentId
                        }
    in
    List.foldl
        helper
        { rootChildren = []
        , otherChildren = Dict.empty
        , missingFolderParentId = []
        }
        (Dict.values step2result.otherFolders)


buildChildrenTree : ChildrenByParent -> List AudienceTree
buildChildrenTree childrenByParent =
    childrenByParent.rootChildren
        |> List.map
            (\pendingFolder ->
                AudienceTree
                    { name = pendingFolder.name
                    , children =
                        Dict.get pendingFolder.id childrenByParent.otherChildren
                            |> Maybe.withDefault []
                            |> (\folders ->
                                    buildChildrenTree { childrenByParent | rootChildren = folders }
                               )
                            |> List.sortBy name
                    , audiences = List.sort pendingFolder.audiences
                    }
            )
        |> List.sortBy name
