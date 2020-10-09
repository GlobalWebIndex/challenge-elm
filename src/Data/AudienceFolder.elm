module Data.AudienceFolder exposing
    ( AudienceFolder, audienceFoldersJSON
    , Folders(..), isParentId, roots
    )

{-| Data.AudienceFolder module

This module implements everything related to audience folder resource.


# Interface

@docs AudienceFolder, audienceFoldersJSON

-}

-- Type definition


{-| Basic type of AudienceFolder record
-}
type alias AudienceFolder =
    { id : Int
    , name : String
    , parent : Maybe Int
    }


type Folders
    = Folders (List AudienceFolder)


roots : List AudienceFolder -> List AudienceFolder
roots allAudienceFolders =
    List.filter isRoot allAudienceFolders


isRoot : AudienceFolder -> Bool
isRoot folder =
    case folder.parent of
        Just _ ->
            False

        Nothing ->
            True


isParentId : Int -> AudienceFolder -> Bool
isParentId id folder =
    case folder.parent of
        Just fId ->
            if fId == id then
                True

            else
                False

        Nothing ->
            False



-- Fixtures


{-| Fixtures for audienceFolders
In real world something like this is returned by `GET /api/audience_folders`
-}
audienceFoldersJSON : String
audienceFoldersJSON =
    """
    {
        "data": [
            {
                "id": 357,
                "name": "Demographics",
                "curated": true,
                "parent": null
            },
            {
                "id": 358,
                "name": "Marketing Personas",
                "curated": true,
                "parent": null
            },
            {
                "id": 383,
                "name": "Reports",
                "curated": true,
                "parent": null
            },
            {
                "id": 3110,
                "name": "New Group",
                "curated": false,
                "parent": null
            },
            {
                "id": 3111,
                "name": "New Group 2",
                "curated": false,
                "parent": 3110
            }
        ]
    }
    """
