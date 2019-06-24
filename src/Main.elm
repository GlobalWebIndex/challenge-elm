module Main exposing (main)

import Array
import Browser
import Browser.Dom
import Data.Audience
import Data.AudienceFolder
import Html
import Html.Attributes
import Html.Events
import Lazy.Tree
import Lazy.Tree.Zipper
import Task



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type Node
    = Audience Data.Audience.Audience
    | AudienceFolder Data.AudienceFolder.AudienceFolder


type alias Model =
    -- An item of the `zipper` stores whether it is open, whether it is selected, and the audience/folder properties.
    { zipper : Lazy.Tree.Zipper.Zipper ( Bool, Bool, Node )

    -- If we are storing the user's selections in database, we can initialize their workspace.
    , filter : Array.Array ( Data.Audience.AudienceType, Bool )

    -- In order to remain the model tiny, `errors` is a list of error codes.
    , errors : List String
    }


root : ( Bool, Bool, Node )
root =
    ( True, True, AudienceFolder { id = -1, name = "Audiences", parent = Nothing } )


defaultModel : Model
defaultModel =
    { zipper = Lazy.Tree.singleton root |> Lazy.Tree.Zipper.fromTree
    , filter = Array.empty
    , errors = []
    }


init : ( Model, Cmd Msg )
init =
    ( case ( Data.AudienceFolder.audienceFolders, Data.Audience.audiences ) of
        ( Ok audienceFolders, Ok audiences ) ->
            defaultModel
                |> withZipper audienceFolders audiences
                |> withFilter

        ( Ok _, Err ( errorCode, _ ) ) ->
            defaultModel
                |> withErrors errorCode

        ( Err ( errorCode, _ ), Ok _ ) ->
            defaultModel
                |> withErrors errorCode

        ( Err ( errorCode1, _ ), Err ( errorCode2, _ ) ) ->
            defaultModel
                |> withErrors errorCode1
                |> withErrors errorCode2
    , Cmd.none
    )


withZipper : List Data.AudienceFolder.AudienceFolder -> List Data.Audience.Audience -> Model -> Model
withZipper audienceFolders audiences model =
    { model
        | zipper =
            List.append
                (audienceFolders
                    |> List.sortBy .name
                    |> List.map AudienceFolder
                )
                (audiences
                    |> List.sortBy .name
                    |> List.map Audience
                )
                |> List.map (\node -> ( False, False, node ))
                |> Lazy.Tree.fromList
                    (\parent ( _, _, node ) ->
                        case ( parent, node ) of
                            ( Just ( _, _, AudienceFolder afp ), AudienceFolder af ) ->
                                Just afp.id == af.parent

                            ( Just ( _, _, AudienceFolder afp ), Audience a ) ->
                                Just afp.id == a.folder

                            ( Nothing, AudienceFolder af ) ->
                                Nothing == af.parent

                            ( Nothing, Audience a ) ->
                                Nothing == a.folder

                            _ ->
                                False
                    )
                |> Lazy.Tree.Tree root
                |> Lazy.Tree.Zipper.fromTree
    }


withFilter : Model -> Model
withFilter model =
    { model | filter = Array.fromList Data.Audience.initialAudienceType }


withErrors : String -> Model -> Model
withErrors errorCode model =
    { model | errors = errorCode :: model.errors }



-- COMMANDS


scrollableListId : String
scrollableListId =
    "audience-list"


jumpToTop : String -> Cmd Msg
jumpToTop id =
    Browser.Dom.getViewportOf id
        |> Task.andThen (\_ -> Browser.Dom.setViewportOf id 0 0)
        |> Task.attempt (\_ -> TaskRun)



-- UPDATE


type Msg
    = FolderTreeTraversedDown (Lazy.Tree.Zipper.Zipper ( Bool, Bool, Node ))
    | FolderTreeTraversedUpwards Int
    | AudenceTypeToggled Data.Audience.AudienceType Bool
    | JumpedToTop String
    | TaskRun


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FolderTreeTraversedDown zipper ->
            ( { model | zipper = Lazy.Tree.Zipper.updateItem (\( isOpen, isSelected, node ) -> ( True, isSelected, node )) zipper }
            , jumpToTop scrollableListId
            )

        FolderTreeTraversedUpwards level ->
            case Lazy.Tree.Zipper.upwards level model.zipper of
                Just parentZipper ->
                    ( { model | zipper = Lazy.Tree.Zipper.update (Lazy.Tree.map (\( isOpen, isSelected, node ) -> ( False, isSelected, node ))) parentZipper }
                    , jumpToTop scrollableListId
                    )

                Nothing ->
                    ( model, Cmd.none )

        AudenceTypeToggled audienceType isSelected ->
            -- We do not update the zipper here, it is a lazy structure.
            -- We will update it in our `view` functions whenever a folder is opened.
            ( { model | filter = Array.set ((Data.Audience.fromAudienceType >> .index) audienceType) ( audienceType, isSelected ) model.filter }
            , Cmd.none
            )

        JumpedToTop id ->
            ( model, jumpToTop id )

        TaskRun ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html.Html Msg
view { zipper, filter, errors } =
    Html.section []
        [ Html.div [ Html.Attributes.class "sidebar" ]
            (if errors == [] then
                widgetView filter zipper

             else
                errorView errors
            )
        , Html.div [ Html.Attributes.class "main" ] []
        ]


widgetView : Array.Array ( Data.Audience.AudienceType, Bool ) -> Lazy.Tree.Zipper.Zipper ( Bool, Bool, Node ) -> List (Html.Html Msg)
widgetView filter zipper =
    let
        selectedAudienceTypes : List Data.Audience.AudienceType
        selectedAudienceTypes =
            filter |> Array.toList |> List.filter (\( _, selected ) -> selected) |> List.map Tuple.first
    in
    [ Html.div [ Html.Attributes.class "search" ] []
    , Html.div
        [ Html.Attributes.class "browser" ]
        [ Html.div
            [ Html.Attributes.class "breadcrumbs" ]
            [ Html.ul []
                (zipper
                    |> Lazy.Tree.Zipper.indexedBreadcrumbs
                    |> List.append [ ( 0, Lazy.Tree.Zipper.current zipper ) ]
                    |> List.reverse
                    |> List.map breadcrumbView
                )
            ]
        , Html.div
            [ Html.Attributes.id scrollableListId
            , Html.Attributes.class "forest"
            ]
            [ Html.ul []
                (zipper
                    |> Lazy.Tree.Zipper.openAll
                    |> List.map (levelView selectedAudienceTypes)
                )
            ]
        ]
    , Html.div [ Html.Attributes.class "drop" ] []
    , Html.div
        [ Html.Attributes.class "filter" ]
        [ filter
            |> Array.map (audienceTypeButtonView (List.length selectedAudienceTypes))
            |> Array.toList
            |> Html.ul []
        ]
    ]


levelView : List Data.Audience.AudienceType -> Lazy.Tree.Zipper.Zipper ( Bool, Bool, Node ) -> Html.Html Msg
levelView selectedAudienceTypes zipper =
    let
        ( isOpen, isSelected, node ) =
            zipper
                -- This is the point where we refreshing our zipper's state.
                -- I have tried to move it to the `update` function but it was so messy.
                -- Finally I have realized that the `isSelected` property has no effect on the data itself,
                -- it is about displaying that data, it is like a CSS hover effect.
                -- I have find my peace with this solution :)
                |> zipperChecker selectedAudienceTypes
                |> Lazy.Tree.Zipper.current

        class : String
        class =
            case node of
                AudienceFolder _ ->
                    "folder"

                Audience _ ->
                    "item"

        events : List (Html.Attribute Msg)
        events =
            case node of
                AudienceFolder _ ->
                    [ Html.Events.onClick (FolderTreeTraversedDown zipper) ]

                Audience _ ->
                    []
    in
    if isSelected then
        Html.li
            [ Html.Attributes.class class ]
            [ Html.a events [ Html.text (getNodeName node) ]
            , Html.ul []
                (if isOpen then
                    zipper |> Lazy.Tree.Zipper.openAll |> List.map (levelView selectedAudienceTypes)

                 else
                    []
                )
            ]

    else
        Html.text ""


breadcrumbView : ( Int, ( Bool, Bool, Node ) ) -> Html.Html Msg
breadcrumbView ( level, ( _, _, breadcrumb ) ) =
    let
        events : List (Html.Attribute Msg)
        events =
            if level > 0 then
                [ Html.Events.onClick (FolderTreeTraversedUpwards level) ]

            else
                [ Html.Events.onClick (JumpedToTop scrollableListId) ]
    in
    Html.li
        [ Html.Attributes.classList [ ( "folder", True ), ( "parent", level == 0 ) ] ]
        [ Html.a events [ Html.text (getNodeName breadcrumb) ] ]


audienceTypeButtonView : Int -> ( Data.Audience.AudienceType, Bool ) -> Html.Html Msg
audienceTypeButtonView selectedAudienceTypesCount ( audienceType, isSelected ) =
    let
        audienceTypeInfo : Data.Audience.AudienceTypeInfo msg
        audienceTypeInfo =
            Data.Audience.fromAudienceType audienceType
    in
    if selectedAudienceTypesCount == 1 && isSelected then
        Html.li
            [ Html.Attributes.classList [ ( "selected", isSelected ) ]
            , Html.Attributes.style "cursor" "default"
            ]
            [ Html.i [] [ audienceTypeInfo.icon ]
            , Html.text audienceTypeInfo.text
            ]

    else
        Html.li
            [ Html.Attributes.classList [ ( "selected", isSelected ) ]
            , Html.Attributes.style "cursor" "pointer"
            , Html.Events.onClick (AudenceTypeToggled audienceType (not isSelected))
            ]
            [ Html.i [] [ audienceTypeInfo.icon ]
            , Html.text audienceTypeInfo.text
            ]


errorView : List String -> List (Html.Html Msg)
errorView errors =
    [ Html.h4 [] [ Html.text "We are sorry." ]
    , Html.p [] [ Html.text "There is a problem with this widget, but the rest of the site is safe to use." ]
    , Html.p []
        [ Html.text
            ("If you are willing to report this problem, please create an issue ticket with the following "
                ++ (if List.length errors == 1 then
                        "code"

                    else
                        "codes"
                   )
                ++ ":"
            )
        ]
    , Html.hr [] []
    ]
        ++ [ errors
                |> List.map (\error -> Html.li [] [ Html.code [] [ Html.text error ] ])
                |> Html.ul []
           ]
        ++ [ Html.p [] [ Html.text "Link to the issue tracker: ... " ] ]



-- HELPERS


zipperChecker : List Data.Audience.AudienceType -> Lazy.Tree.Zipper.Zipper ( Bool, Bool, Node ) -> Lazy.Tree.Zipper.Zipper ( Bool, Bool, Node )
zipperChecker selections zipper =
    Lazy.Tree.Zipper.updateItem
        (\( isOpen, isSelected, node ) ->
            ( isOpen
            , Lazy.Tree.Zipper.isInZipper (audienceTypeChecker selections) zipper
            , node
            )
        )
        zipper


audienceTypeChecker : List Data.Audience.AudienceType -> ( Bool, Bool, Node ) -> Bool
audienceTypeChecker selections ( _, _, node ) =
    case node of
        AudienceFolder _ ->
            -- The folders are always selected, so they are always visible.
            True

        Audience a ->
            List.member a.type_ selections


getNodeName : Node -> String
getNodeName node =
    case node of
        AudienceFolder af ->
            af.name

        Audience a ->
            a.name
