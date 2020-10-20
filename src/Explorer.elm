module Explorer exposing
    ( Zipper, createRoot
    , subFiles, subFolders
    , addFiles, addFolders
    , goUp, goTo
    , currentFolder, expandFolder
    )

{-| A Multiway tree with a focus, representing the currently opened folder.
The tree can be built from a list, with folder references.


# Structure

@docs Zipper, createRoot


# Build

@docs createRoot


# Current level

@docs current, subFiles, subFolders


# Modification

@docs addFiles, addFolders


# Navigation

@docs goUp, goTo, expand

-}


{-| Multiway tree structure, representing a file system
-}
type Explorer a b
    = Root (List (Explorer a b)) Expanded
    | Folder a (List (Explorer a b)) Expanded
    | File b


{-| As we navigate in the tree we collect crumbs to be able to rebuild the tree
-}
type Crumb a b
    = Crumb a (List (Explorer a b)) (List (Explorer a b))
    | RootCrumb (List (Explorer a b)) (List (Explorer a b))


{-| As we navigate in the tree we caching the filesystem
Expanded represent whether we visited a folder
-}
type Expanded
    = Expanded
    | NotExpanded


{-| Multiway tree structure with a focus on a folder
-}
type Zipper a b
    = Zipper (Explorer a b) (List (Crumb a b))


{-| List with a reference. The list has left side and right side and a reference to an element in a list
-}
type alias ListWithRef a =
    ( List a, a, List a )


type alias ListWithR a =
    ( List a, Maybe a, List a )


{-| Creates the root of the file explorer from folders and files, focusing on the root

      create ["folder 1"] ["file 2", "file 3"] ==
        Zipper (Root [ File ("file 3"),
                     , File ("file 2"),
                     , Folder { id = 3 } [] NotExpanded,
                     ]
                Expanded) []

-}
createRoot : List a -> List b -> Zipper a b
createRoot rootFolders rootfiles =
    Zipper (Root [] Expanded) []
        |> addFolders rootFolders
        |> addFiles rootfiles


{-| Get the value of the current folder, where the focus is

      create [1] [2, 3] |> current == Nothing

      Zipper (Folder 1 [] NotExpanded) [RootCrumb [File 3,File 2] []] |> current == 1

      Zipper (File 2) [RootCrumb [File 3] [Folder 1 [] NotExpanded]] == Nothing

-}
currentFolder : Zipper a b -> Maybe a
currentFolder (Zipper parent breadcrumbs) =
    case parent of
        Root _ _ ->
            Nothing

        Folder x _ _ ->
            Just x

        File y ->
            Nothing


{-| Get list of zippers with focus on all the children elements

      createRoot [1] [2, 3] |> subFolders ==
        [ Zipper (File 3) [RootCrumb [] [File 2, Folder 1 [] NotExpanded]]
        , Zipper (File 2) [RootCrumb [File 3] [Folder 1 [] NotExpanded]]
        , Zipper (Folder 1 [] NotExpanded) [RootCrumb [File 3, File 2] []]
        ]

-}
subZippers : Zipper a b -> List (Zipper a b)
subZippers (Zipper parent breadcrumbs) =
    case parent of
        Root children crumbs ->
            children
                |> allRef
                |> List.map (goToRootChild breadcrumbs)

        Folder x children crumbs ->
            children
                |> allRef
                |> List.map (goToChild x breadcrumbs)

        File y ->
            []


subFolders : Zipper a b -> List a
subFolders (Zipper parent _) =
    case parent of
        Root children _ ->
            List.filterMap toFolder children

        Folder _ children _ ->
            List.filterMap toFolder children

        File _ ->
            []


toFolder : Explorer a b -> Maybe a
toFolder explorer =
    case explorer of
        Folder x _ _ ->
            Just x

        _ ->
            Nothing


goToRootChild : List (Crumb a b) -> ListWithRef (Explorer a b) -> Zipper a b
goToRootChild breadcrumbs ( leftSide, itemToGo, rightSide ) =
    Zipper itemToGo (RootCrumb leftSide rightSide :: breadcrumbs)


goToChild : a -> List (Crumb a b) -> ListWithRef (Explorer a b) -> Zipper a b
goToChild x breadcrumbs ( leftSide, itemToGo, rightSide ) =
    Zipper itemToGo (Crumb x leftSide rightSide :: breadcrumbs)


{-| Get all sub files

      createRoot [1] [2,3] |> subFiles == [3,2]

-}
subFiles : Zipper a b -> List b
subFiles (Zipper parent _) =
    case parent of
        Root children _ ->
            List.filterMap toFile children

        Folder _ children _ ->
            List.filterMap toFile children

        File _ ->
            []


toFile : Explorer a b -> Maybe b
toFile explorer =
    case explorer of
        File x ->
            Just x

        _ ->
            Nothing


{-| Navigate to the parent folder

      createRoot [1] [2, 3] |> subFolders |> List.head |> Maybe.map(goUp) ==
        Just (Zipper (Root [File 3,File 2,Folder 1 [] NotExpanded] Expanded) [])

-}
goUp : Zipper a b -> Zipper a b
goUp (Zipper parent breadcrumbs) =
    case breadcrumbs of
        [] ->
            Zipper parent breadcrumbs

        (RootCrumb rightUncles leftUncles) :: rest ->
            Zipper (Root (rightUncles ++ [ parent ] ++ leftUncles) Expanded) rest

        (Crumb x rightUncles leftUncles) :: rest ->
            Zipper (Folder x (rightUncles ++ [ parent ] ++ leftUncles) Expanded) rest


{-| -}
goTo : a -> Zipper a b -> Zipper a b
goTo child (Zipper folder breadcrumbs) =
    case folder of
        Root children _ ->
            let
                ( left, ref, rest ) =
                    findChild ((==) child) children
            in
            case ref of
                Just itemToGo ->
                    goToRootChild breadcrumbs ( left, itemToGo, rest )

                -- shouldn't happen
                Nothing ->
                    Zipper folder breadcrumbs

        Folder x children _ ->
            let
                ( left, ref, rest ) =
                    findChild ((==) child) children
            in
            case ref of
                Just itemToGo ->
                    goToChild x breadcrumbs ( left, itemToGo, rest )

                -- shouldn't happen
                Nothing ->
                    Zipper folder breadcrumbs

        File _ ->
            Zipper folder breadcrumbs


{-| Fetch files and folders if it was not expanded yet, if it was we just return with the zipper
-}
expandFolder : (() -> List a) -> (() -> List b) -> Zipper a b -> Zipper a b
expandFolder folders files (Zipper folder breadcrumbs) =
    case folder of
        Root children expanded ->
            Zipper folder breadcrumbs

        Folder x children expanded ->
            case expanded of
                Expanded ->
                    Zipper folder breadcrumbs

                NotExpanded ->
                    Zipper folder breadcrumbs
                        |> setExpanded
                        |> addFolders (folders ())
                        |> addFiles (files ())

        File _ ->
            Zipper folder breadcrumbs


setExpanded : Zipper a b -> Zipper a b
setExpanded (Zipper folder breadcrumbs) =
    case folder of
        Root children _ ->
            Zipper (Root children Expanded) breadcrumbs

        Folder x children _ ->
            Zipper (Folder x children Expanded) breadcrumbs

        File y ->
            Zipper folder breadcrumbs


{-| Append folders to the current folder
-}
addFolders : List a -> Zipper a b -> Zipper a b
addFolders folders zipper =
    folders
        |> List.map (\x -> Folder x [] NotExpanded)
        |> List.foldl addEntry zipper


{-| Add files to the current folder
-}
addFiles : List b -> Zipper a b -> Zipper a b
addFiles files zipper =
    files
        |> List.map File
        |> List.foldl addEntry zipper


addEntry : Explorer a b -> Zipper a b -> Zipper a b
addEntry x (Zipper folder breadcrumbs) =
    case folder of
        Root children expanded ->
            Zipper (Root (x :: children) expanded) breadcrumbs

        Folder f children expanded ->
            Zipper (Folder f (x :: children) expanded) breadcrumbs

        File y ->
            Zipper folder breadcrumbs


{-| Reference all element of the given list

    allRef [ 1, 2, 3 ] =
        [ ( [], 1, [ 2, 3 ] )
        , ( [ 1 ], 2, [ 3 ] )
        , ( [ 1, 2 ], 3, [] )
        ]

-}
allRef : List a -> List (ListWithRef a)
allRef list =
    allRefHelp list []


allRefHelp : List a -> List (ListWithRef a) -> List (ListWithRef a)
allRefHelp list acc =
    case list of
        [] ->
            List.reverse acc

        first :: rest ->
            case acc of
                [] ->
                    allRefHelp rest [ ( [], first, rest ) ]

                ( leftS, f, nf :: r ) :: accRest ->
                    allRefHelp rest (( leftS ++ [ f ], nf, r ) :: acc)

                ( leftS, f, [] ) :: accRest ->
                    List.reverse acc


findChild : (a -> Bool) -> List (Explorer a b) -> ListWithR (Explorer a b)
findChild fn list =
    findChildHelp fn list ( [], Nothing, [] )


findChildHelp : (a -> Bool) -> List (Explorer a b) -> ListWithR (Explorer a b) -> ListWithR (Explorer a b)
findChildHelp fn children ( accL, child, accR ) =
    case children of
        first :: rest ->
            case currentFolder (Zipper first []) of
                Just x ->
                    if fn x then
                        ( List.reverse accL, Just first, rest )

                    else
                        findChildHelp fn rest ( first :: accL, Nothing, accR )

                Nothing ->
                    findChildHelp fn rest ( first :: accL, Nothing, accR )

        [] ->
            ( accL, child, accR )
