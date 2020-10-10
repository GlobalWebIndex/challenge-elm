module Data.AudienceTree exposing 
    ( AudienceTree
    , CategorizedAudiences
    , constructCategorizedAudiences
    , getAudiences
    , getName
    , getSubFolders
    )


import Dict
import Data.Audience
import Data.AudienceFolder

getAudiences : AudienceTree -> List Data.Audience.Audience
getAudiences (AudienceNode data) =
    data.audiences

getSubFolders : AudienceTree -> Dict.Dict Int AudienceTree
getSubFolders (AudienceNode data) =
    data.subFolders

getName : AudienceTree -> String
getName (AudienceNode data) =
    data.title


type Branch leaf node = Branch leaf (List node)


-- we could use an alias, but we do this because even though they're all basically 
-- the same type of record, we want the compiler to tell us if we somehow 
-- accidentally put an "AuthoredAudience" into a "AudienceTree CuratedAudience".
-- type AuthoredAudience =
--     AuthoredAudience 
--         { title : String }

-- type CuratedAudience =
--     CuratedAudience
--         { title : String }

-- type SharedAudience =
--     SharedAudience
--         { title : String }

type AudienceTree =
    AudienceNode
        { id : Int
        , title : String
        , subFolders : Dict.Dict Int AudienceTree
        , audiences : List Data.Audience.Audience
        }

type alias CategorizedAudiences =
    { authoredAudienceTree : AudienceTree
    , curatedAudienceTree : AudienceTree
    , sharedAudiences : List Data.Audience.Audience
    }


updateSubFolders : Int -> (Maybe AudienceTree -> Maybe AudienceTree) -> AudienceTree -> AudienceTree
updateSubFolders key alter (AudienceNode tree) =
    AudienceNode
        { tree
            | subFolders = Dict.update key alter tree.subFolders
        }

addAudience : Data.Audience.Audience -> AudienceTree -> AudienceTree
addAudience audience (AudienceNode tree) =
    AudienceNode
        { tree
            | audiences = audience :: tree.audiences
        }

getAudienceTree : Int -> AudienceTree -> Maybe AudienceTree
getAudienceTree key (AudienceNode tree) =
    Dict.get key tree.subFolders

insertSubFolder : Int -> AudienceTree -> AudienceTree -> AudienceTree
insertSubFolder key audienceTree (AudienceNode tree) =
    AudienceNode
        { tree
            | subFolders = Dict.insert key audienceTree tree.subFolders
        }

addBranchToCategory : (Branch Data.Audience.Audience Data.AudienceFolder.AudienceFolder) -> CategorizedAudiences -> CategorizedAudiences
addBranchToCategory ( Branch audience audienceFolders ) categorized =
    case audience.type_ of
        Data.Audience.Authored ->
            { categorized
                | authoredAudienceTree = attachBranch ((Branch audience) audienceFolders) categorized.authoredAudienceTree
            }
        Data.Audience.Curated ->
            { categorized
                | curatedAudienceTree = attachBranch ((Branch audience) audienceFolders) categorized.curatedAudienceTree
            }
        Data.Audience.Shared ->
            { categorized
                | sharedAudiences = audience :: categorized.sharedAudiences
            }

rootAudienceFolder : AudienceTree
rootAudienceFolder =
    AudienceNode
        { id = 0
        , title = "root"
        , subFolders = Dict.empty
        , audiences = []
        }

{-
    the way audiences come from the server is in the form of each
    individual file pointing to its (potential) parent folder (which, in
    turn, may have its own parent, and so forth).
    therefore, we build branches out of each audience, and then
    build a tree out of those branches afterwards.

    this may have been easier to do on the frontend if the data that came 
    from the server was, for example, in the form of
    """
        {
            "authoredAudiencesTree" : {
                "subFolders" : [
                    "subFolder1Name" : {
                        "subFolders" : [],
                        "audiences" : []
                    },
                    "subFolder2Name" : { 
                        "subFolders" : [],
                        "audiences" : []
                    }
                ],
                "audiences" : [
                    { "name" : "audience1" },
                    { "name" : "meatheads" },
                ]
            },
            "curatedAudiencesTree" : { -- this would be the name of the folder, which in this case is the root folder
                "subFolders" : [],
                "audiences" : [
                    { "name" : "curated audience1" },
                    { "name" : "petrolheads" }
                ]
            },
            "sharedAudiences" : [ -- this is a list because "SECOND_STEP.md" said we should display a flattened list of audiences in the case when we filter them by type
                { "name" : "shared audience 1" },
                { "name" : "shared audience 2" },
                { "name" : "shared audience 3" }
            ]
        }
"""
-}


constructCategorizedAudiences : Dict.Dict Int Data.Audience.Audience -> Dict.Dict Int Data.AudienceFolder.AudienceFolder -> CategorizedAudiences
constructCategorizedAudiences audiences audienceFolders =
    let
        initCategorizedAudiences : CategorizedAudiences
        initCategorizedAudiences =
            { authoredAudienceTree = rootAudienceFolder
            , curatedAudienceTree = rootAudienceFolder
            , sharedAudiences = []
            }
    in
        Dict.values audiences
            |> List.map (constructBranch audienceFolders)
            |> List.foldl addBranchToCategory initCategorizedAudiences

-- lord forgive me
attachBranch : Branch Data.Audience.Audience Data.AudienceFolder.AudienceFolder -> AudienceTree -> AudienceTree
attachBranch (Branch audience audienceFolders) audienceTree =
    -- when this function is first called for a branch, this `audienceTree` is the root
    case audienceFolders of
        [] ->
            addAudience audience audienceTree
        x :: xs ->
            case getAudienceTree x.id audienceTree of
                Just tree ->
                    updateSubFolders 
                        x.id
                        (\maybeSubFolder ->
                            case maybeSubFolder of
                                Just subFolder ->
                                    Just (attachBranch (Branch audience xs) subFolder )
                                Nothing ->
                                    Nothing
                        )
                        tree
                Nothing ->
                    -- this means we still have audience folders in the branch, 
                    -- but the branch from this particular point forward doesn't
                    -- exist in the tree (so we have to create it)
                    let
                        added = (insertSubFolder x.id (folderToAudienceTree x) audienceTree)
                    in
                        updateSubFolders 
                            x.id
                            (\maybeSubFolder ->
                                case maybeSubFolder of
                                    Just subFolder ->
                                        Just (attachBranch (Branch audience xs) subFolder)
                                    Nothing ->
                                        Nothing
                            )
                            (Maybe.withDefault (folderToAudienceTree x) (Just added))

folderToAudienceTree : Data.AudienceFolder.AudienceFolder -> AudienceTree
folderToAudienceTree folder =
    AudienceNode
        { id = folder.id
        , title = folder.name
        , subFolders = Dict.empty
        , audiences = []
        }

dig : List Data.AudienceFolder.AudienceFolder -> Int -> Dict.Dict Int Data.AudienceFolder.AudienceFolder -> List Data.AudienceFolder.AudienceFolder
dig acc id dict =
    let
        l =
            case Dict.get id dict of
                Nothing ->
                    -- this would only happen if something that called this function
                    -- said "hey, my parent has id 13!", and we check for id 13, and 
                    -- it's not there.
                    -- if we really trust the backend, this shouldn't happen, but we
                    -- could just return a "Result" here to make sure we know what's up
                    acc
                Just value ->
                    case value.parent of
                        Nothing ->
                            (value :: acc)
                        Just parentId ->
                            -- BIG WARNING: if we have "folder1 points to folder2" 
                            -- and "folder2 points to folder1", we get infinite recursion
                            dig (value :: acc) parentId dict
    in
        -- since we construct the branch from -- Leaf -> Parent -> Parent -> etc..
        -- but we need Parent -> Parent -> Leaf
        List.reverse l

constructBranch : Dict.Dict Int Data.AudienceFolder.AudienceFolder -> Data.Audience.Audience -> Branch Data.Audience.Audience Data.AudienceFolder.AudienceFolder
constructBranch audienceFolders audience =
    case audience.folder of
        Nothing ->
            Branch audience []
        Just id ->
            -- the way we use this goes like this:
            -- Branch leaf [ Grandparent -> Parent -> Child -> etc ]
            Branch audience (dig [] id audienceFolders)


