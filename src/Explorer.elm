module Explorer exposing (Zipper, addFiles, addFolders, createRoot, goTo, goUp)


type Explorer a b
    = Root (List (Explorer a b))
    | Folder a (List (Explorer a b))
    | File b


type Crumb a b
    = Crumb a (List (Explorer a b)) (List (Explorer a b))
    | RootCrumb (List (Explorer a b)) (List (Explorer a b))


type Zipper a b
    = Zipper (Explorer a b) (List (Crumb a b))


type alias WithId a =
    { a | id : Int }


type alias ListWithRef a =
    ( List a, Maybe a, List a )


createRoot : Zipper a b
createRoot =
    Zipper (Root []) []


createFolder : a -> Explorer a b
createFolder x =
    Folder x []


createFile : b -> Explorer a b
createFile x =
    File x


current : Zipper a b -> Maybe a
current (Zipper parent breadcrumbs) =
    case parent of
        Root _ ->
            Nothing

        Folder x _ ->
            Just x

        File y ->
            Nothing


subFolders : Zipper a b -> List a
subFolders (Zipper parent _) =
    case parent of
        Root children ->
            List.filterMap toFolder children

        Folder _ children ->
            List.filterMap toFolder children

        File y ->
            []


toFolder : Explorer a b -> Maybe a
toFolder eplorer =
    case eplorer of
        Folder x _ ->
            Just x

        _ ->
            Nothing


subFiles : Zipper a b -> List b
subFiles (Zipper parent _) =
    case parent of
        Root children ->
            List.filterMap toFile children

        Folder _ children ->
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


goUp : Zipper a b -> Zipper a b
goUp (Zipper parent breadcrumbs) =
    case breadcrumbs of
        [] ->
            Zipper parent breadcrumbs

        (RootCrumb rightUncles leftUncles) :: rest ->
            Zipper (Root (rightUncles ++ [ parent ] ++ leftUncles)) rest

        (Crumb x rightUncles leftUncles) :: rest ->
            Zipper (Folder x (rightUncles ++ [ parent ] ++ leftUncles)) rest


goTo : Int -> Zipper (WithId a) (WithId b) -> Zipper (WithId a) (WithId b)
goTo id (Zipper folder breadcrumbs) =
    case folder of
        Root children ->
            let
                ( left, ref, rest ) =
                    break (\f -> f == id) children
            in
            case ref of
                Just itemToGo ->
                    Zipper itemToGo (RootCrumb left rest :: breadcrumbs)

                Nothing ->
                    Zipper folder breadcrumbs

        -- shouldn't happen
        Folder x children ->
            let
                ( left, ref, rest ) =
                    break (\f -> f == id) children
            in
            case ref of
                Just itemToGo ->
                    Zipper itemToGo (Crumb x left rest :: breadcrumbs)

                Nothing ->
                    Zipper folder breadcrumbs

        -- shouldn't happen
        File _ ->
            Zipper folder breadcrumbs


addFolders : List a -> Zipper a b -> Zipper a b
addFolders folders (Zipper folder breadcrumbs) =
    folders
        |> List.map (\x -> Folder x [])
        |> List.foldl addEntry (Zipper folder breadcrumbs)


addFiles : List b -> Zipper a b -> Zipper a b
addFiles files (Zipper folder breadcrumbs) =
    files
        |> List.map (\x -> File x)
        |> List.foldl addEntry (Zipper folder breadcrumbs)


addEntry : Explorer a b -> Zipper a b -> Zipper a b
addEntry x (Zipper folder breadcrumbs) =
    case folder of
        Root children ->
            Zipper (Root (x :: children)) breadcrumbs

        Folder f children ->
            Zipper (Folder f (x :: children)) breadcrumbs

        File y ->
            Zipper folder breadcrumbs


break : (Int -> Bool) -> List (Explorer (WithId a) (WithId b)) -> ListWithRef (Explorer (WithId a) (WithId b))
break fn list =
    breakFn fn list ( [], Nothing, [] )


breakFn : (Int -> Bool) -> List (Explorer (WithId a) (WithId b)) -> ListWithRef (Explorer (WithId a) (WithId b)) -> ListWithRef (Explorer (WithId a) (WithId b))
breakFn fn list ( accL, ref, accR ) =
    case list of
        first :: rest ->
            if fn (name first) then
                ( List.reverse accL, Just first, rest )

            else
                breakFn fn rest ( first :: accL, Nothing, accR )

        [] ->
            ( accL, ref, accR )


name : Explorer (WithId a) (WithId b) -> Int
name browser =
    case browser of
        Root _ ->
            -1

        Folder x _ ->
            x.id

        File y ->
            y.id
