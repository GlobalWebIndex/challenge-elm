module Main exposing (main)

import Browser
import Browser.Events
import Data.Audience
import Data.AudienceFolder
import Data.AudienceTree
import Dict
import Element as E -- elm-ui
import Element.Background as EBackground
import Element.Border as EBorder
import Element.Events as EEvents
import Element.Font as EFont
import Element.Input as EInput
import Html
import Html.Attributes
import Icons
import Json.Decode
import Palette
import Process
import Task
import Time


type alias History =
    { root : Data.AudienceTree.AudienceTree
    -- this list tracks the depth that we went to into an AudienceTree
    -- it takes the form of [ currentLevel, parent, grandparent, etc ]
    , points : List Data.AudienceTree.AudienceTree
    }

getCurrentPoint : History -> Data.AudienceTree.AudienceTree
getCurrentPoint history =
    case history.points of
        [] ->
            history.root
        x :: xs ->
            x

tail history =
    case history.points of
        [] ->
            { root = history.root
            , points = []
            }
        x :: xs ->
            { root = history.root
            , points = xs
            }

-- we could perhaps model this so that you can only make a "FolderClicked" Msg
-- or "SortBy" Msg only after the model has loaded up, but I don't think this is
-- too much of an issue


type Msg
    = FolderClicked Data.AudienceTree.AudienceTree
    | GoBack
    | FilterBy Data.Audience.AudienceType
    | GotAudiencesJSON String
    | GotAudienceFoldersJSON String
    | GotTime Time.Posix



-- we use dicts instead of lists because it gives us O(log n) time complexity
-- for insertion, removal and querying, as opposed to lists which would be O(n).
-- additional note: I chose to store audiences and audienceFolders separately because:
--    1. I don't know if on the server side the IDs of the Folders
--       and the IDs of the Audiences are kept separately. This way I
--       would make sure that there's no collisions between them
--    2. These two come from different API endpoints.
--       Audiences come from "/api/audiences" and audienceFolders come
--       from "api/audience_folders".
--       If we kept these as the same Dict, and only one result would come back,
--       the dict would look completely normal, but it wouldn't be. Things would
--       be missing.
--       So this way, it's either "everything came back, and we render the ui,
--       or we render some loading page or some error page "


type Model
    = Loading LoadingModel
    | Loaded LoadedModel
    | JsonError Json.Decode.Error


type alias LoadingModel =
    { audiences : Maybe (Dict.Dict Int Data.Audience.Audience)
    , audienceFolders : Maybe (Dict.Dict Int Data.AudienceFolder.AudienceFolder)
    , time : Maybe Time.Posix
    }


type alias LoadedModel =
    { categorizedAudiences : Data.AudienceTree.CategorizedAudiences
    , history : Maybe History -- if there's no history, we "filter" by shared

    -- according to "SECOND_STEP.md" there must be at least one category selected
    -- at any time
    , filterBy : Data.Audience.AudienceType
    }



-- we fake an http request with a delay


fakeHttpGet : Msg -> Float -> Cmd Msg
fakeHttpGet msg time =
    Task.perform (\_ -> msg) (Process.sleep time)


init : () -> ( Model, Cmd Msg )
init _ =
    let
        model_ =
            Loading
                { audiences = Nothing
                , audienceFolders = Nothing
                , time = Nothing
                }

        -- "load" these at different times, to show that the UI works right
        -- the user can't do anything with the audienceFolders and audiences
        -- until both of them load
        cmd_ =
            Cmd.batch
                [ fakeHttpGet (GotAudiencesJSON Data.Audience.audiencesJSON) 300
                , fakeHttpGet (GotAudienceFoldersJSON Data.AudienceFolder.audienceFoldersJSON) 200
                ]
    in
    ( model_, cmd_ )


initLoadedModel : Dict.Dict Int Data.Audience.Audience -> Dict.Dict Int Data.AudienceFolder.AudienceFolder -> LoadedModel
initLoadedModel loadedAudiences loadedAudienceFolders =
    let
        categorizedAudiences = Data.AudienceTree.constructCategorizedAudiences loadedAudiences loadedAudienceFolders
    in
        { categorizedAudiences = categorizedAudiences
        , history = Just { root = categorizedAudiences.authoredAudienceTree , points = [] }
        , filterBy = Data.Audience.Authored
        }


tryLoadingModelToLoaded : LoadingModel -> Model
tryLoadingModelToLoaded loadingM =
    case ( loadingM.audiences, loadingM.audienceFolders ) of
        ( Just loadedAudiences, Just loadedAudienceFolders ) ->
            Loaded (initLoadedModel loadedAudiences loadedAudienceFolders)

        _ ->
            Loading loadingM



-- normally, here I would return a tuple of type (Model, Cmd Msg), but since
-- in this app there's no Cmd s to run, I decided to simplify everything
-- and just return the Model


update : Msg -> Model -> Model
update msg model =
    case ( msg, model ) of
        ( GotAudiencesJSON json, Loading loadingModel ) ->
            let
                audiencesDecoder : Json.Decode.Decoder (List Data.Audience.Audience)
                audiencesDecoder =
                    Json.Decode.field "data" <|
                        Json.Decode.list Data.Audience.audienceDecoder
            in
            case Json.Decode.decodeString audiencesDecoder json of
                Err err ->
                    JsonError err

                Ok audiencesList ->
                    tryLoadingModelToLoaded
                        { loadingModel
                            | audiences = Just (audiencesToDict audiencesList)
                        }

        ( GotAudienceFoldersJSON json, Loading loadingModel ) ->
            let
                audienceFoldersDecoder : Json.Decode.Decoder (List Data.AudienceFolder.AudienceFolder)
                audienceFoldersDecoder =
                    Json.Decode.field "data" <|
                        Json.Decode.list Data.AudienceFolder.audienceFolderDecoder
            in
            case Json.Decode.decodeString audienceFoldersDecoder json of
                Err err ->
                    JsonError err

                Ok audienceFoldersList ->
                    tryLoadingModelToLoaded
                        { loadingModel
                            | audienceFolders = Just (audienceFoldersToDict audienceFoldersList)
                        }

        ( FolderClicked sel, Loaded loadedModel ) ->
            Loaded
                <| case loadedModel.history of
                    Nothing ->
                        loadedModel
                    Just hs ->
                        { loadedModel
                            | history = Just { hs | points = sel :: hs.points }
                        }

        ( GoBack, Loaded loadedModel ) ->
            Loaded
                <| case loadedModel.history of
                    Nothing ->
                        loadedModel
                    Just hs ->
                        { loadedModel
                            | history = Just (tail hs)
                        }

        ( FilterBy audienceType, Loaded loadedModel ) ->
            Loaded
                { loadedModel
                    | filterBy = audienceType
                    , history = 
                        case audienceType of
                            Data.Audience.Authored ->
                                Just { root = loadedModel.categorizedAudiences.authoredAudienceTree, points = [] }
                            Data.Audience.Curated ->
                                Just { root = loadedModel.categorizedAudiences.curatedAudienceTree, points = [] }
                            Data.Audience.Shared ->
                                Nothing
                }

        ( GotTime time, Loading loadingModel ) ->
            Loading
                { loadingModel
                    | time = Just time
                }

        ( _, _ ) ->
            model



-- View
{-
   I chose to go with the "mdgriffith/elm-ui" library instead of the "elm/html"
   because of a few reasons:
        1. Our UI can now be expressed in elm code, without having to write css.
           Css is very tricky to do layout of your page with, whereas with elm-ui
           Everything pertaining to layout is expressed in terms of rows and columns,
           and designing your page from the outside in.
        2. I'm very familiar with it, and have successfully used it in numerous
           projects so far
        3. I noticed you said that currently you use SCSS for css. By using elm-ui
           there's no intermediate step for compiling styling anymore. Everything
           is done directly in elm.
        4. It "makes more sense". This one is hard to explain, but basically:
           Doing something like:
           ```elm
               Element.column
                   [ -- attributes
                   ]
                   [ E.el [] <| E.text "1"
                   , E.el [] <| E.text "2"
                   , E.el [] <| E.text "3"
                   ]
           ```
           conveys much more meaning about what's going on. It's a vertical column
           of text elements. Whereas
           ```elm
               Html.div
                   [
                   ]
                   [ Html.div [] [ Html.text "1" ]
                   , Html.div [] [ Html.text "2" ]
                   , Html.div [] [ Html.text "3" ]
                   ]
           ```
           Says nothing about its layout. Are the elements going to be displayed
           verically or horisontally? Also, a "div" doesn't explain a lot about
           the fact that this is supposed to only hold one single piece of text.
           Should we be able to put more pieces of text in it? If yes, how are
           they going to be displayed? Vertically or horisonally?
           For all of this additional meaning, we have to scour our css files at
           the same time.

           And additionally, some things are so much more easily expressed with
           elm-ui.
           For example: an entire (working) empty page example that displays
           centered text:
           ```elm
           view = E.layout
               [
               ]
               <| E.el
                   [ E.centerX
                   , E.centerY
                   ]
                   <| E.text "hello"
           ```
           Which will center the text.
           With css, even a simple task like this is so unintuitive that there's a
           very popular thread on stack overflow on how to do it, with answers of
           varying complexity that I would argue are way too cryptic for the
           simplicity of the problem.
           [The thread](https://stackoverflow.com/questions/114543/how-to-horizontally-center-a-div)

   Possible counter arguments:
        1. What if the user has javascript disabled? Then the web page won't even
           display!

           Answer:
           My rebuttal to this is that since this is an aplication that requires
           javascript to even work, this is not an issue. No point in seeing
           the app if you can't use it.
           Also, even if we used elm/html, and we had css separately, if javascript
           doesn't run, no html nodes will even be created, so again, nothing will
           be displayed. So both approaches suffer from the same problem.

   It's difficult to convey through these arguments how much more joyful I am
   styling my app in elm-ui versus css, but it's such a big deal for me that this
   library was one of the main reasons I picked up elm.

   Also relevant, Matt Griffith's talk about the elm-ui library:
       https://www.youtube.com/watch?v=Ie-gqwSHQr0
-}


view : Model -> Html.Html Msg
view model =
    let
        content =
            case model of
                Loading loadingModel ->
                    viewLoading loadingModel

                Loaded loadedModel ->
                    viewDashboard loadedModel

                JsonError err ->
                    viewJsonError err
    in
    E.layout
        -- this is the root of the page
        [ EFont.family
            -- we set a font family that applies globally
            [ EFont.typeface Palette.font0
            ]
        , EFont.size Palette.fontSize0 -- and a size
        , EBackground.color Palette.white -- and the background color of the whole page
        ]
        -- we split the page into a column of the content and
        -- the color palette at the bottom
        <| E.column
            [ E.width E.fill
            , E.height E.fill
            ]
            [ E.el [ E.paddingXY 0 80, E.centerX, E.height E.fill ] content
            , E.row
                [ E.width E.fill
                , E.alignBottom
                ]
                <| List.map viewColor colors
            ]


sortButton : Data.Audience.AudienceType -> Data.Audience.AudienceType -> E.Element Msg
sortButton audienceType audienceTypeToSortBy =
    let
        -- the "label" is a row of the icon and the text
        label =
            E.row
                [ E.spacing 10
                , E.centerX
                , E.centerY
                ]
                [ E.el
                    [ E.width <| E.px 18
                    , E.height <| E.px 18
                    ]
                    <| E.html <| Data.Audience.audienceTypeToIcon audienceType
                , E.text <| Data.Audience.audienceTypeToString audienceType
                ]
    in
    EInput.button
        [ EBackground.color <|
            case audienceTypeToSortBy == audienceType of
                True ->
                    Palette.color3

                False ->
                    E.rgba 0 0 0 0
        , E.width <| E.px 110
        , E.height <| E.px 40
        , EBorder.rounded 5
        , EBorder.width 1
        , EBorder.color <| Palette.color3
        ]
        { label = label
        , onPress = Just (FilterBy audienceType)
        }



-- the panel on the right hand side of the dashboard


viewSortingPanel : Data.Audience.AudienceType -> E.Element Msg
viewSortingPanel currentlySortBy =
    let
        buttons =
            List.map
                (\btn -> sortButton btn currentlySortBy)
                [ Data.Audience.Authored
                , Data.Audience.Curated
                , Data.Audience.Shared
                ]
    in
    E.column
        [ E.paddingXY 20 20
        , EBorder.width 1
        , EBorder.color Palette.color5
        , EBackground.color Palette.gray5
        , EBorder.rounded 8
        , E.spacing 20
        , E.alignTop
        ]
        [ E.text "Sort by:"
        , E.row
            [ E.spacing 10
            ]
            buttons
        ]



-- the dashboard is just the file browser and the "sorting panel" one
-- next to the other


viewDashboard : LoadedModel -> E.Element Msg
viewDashboard model =
    let
        audienceFolders =
            case model.history of
                Just hs ->
                    getCurrentPoint hs
                        |> Data.AudienceTree.getSubFolders
                        |> Dict.values
                        |> List.foldl viewFolder []
                Nothing ->
                    []
        audiences =
            case model.history of
                Just hs ->
                    getCurrentPoint hs
                        |> Data.AudienceTree.getAudiences
                        |> List.foldl viewAudience []
                Nothing ->
                    Debug.log "" <| List.foldl viewAudience [] model.categorizedAudiences.sharedAudiences

        -- we would normally use an icon here that would represent "i" for
        -- "info", but a regular text element did the job well enough
        coolI : E.Element Msg
        coolI =
            E.el
                [ E.width <| E.px 15
                , E.height <| E.px 15
                , EFont.color Palette.color2
                ]
                <| E.el [ E.centerX, E.centerY ] <| E.text "i"

        -- according to "FIRST_STEP.md", we should only display the "back" button
        -- if we're not at the root of the tree
        upperLeftBackButtonOrText : E.Element Msg
        upperLeftBackButtonOrText =
            case model.history of
                Just hs ->
                    case hs.points of
                        [] ->
                            E.el
                                [ E.centerY
                                ]
                                <| E.text upperLeftText
                        els ->
                            EInput.button
                                [ E.centerY
                                , EBackground.color Palette.color4
                                , EBorder.rounded 3
                                , E.paddingXY 7 7
                                ]
                                { onPress = Just GoBack
                                , label = E.text "Go Back"
                                }

                Nothing ->
                    E.el
                        [ E.centerY
                        ]
                        <| E.text upperLeftText

        upperLeftText : String
        upperLeftText =
            case model.filterBy of
                Data.Audience.Shared ->
                    "Displaying Shared audiences from all folders"

                _ ->
                    "Click a folder to start browsing!"

        upperRightInfoElement : E.Element Msg
        upperRightInfoElement =
            E.row
                [ EBackground.color Palette.color4
                , E.padding 5
                , E.spacing 5
                , EBorder.roundEach { topRight = 99, bottomRight = 99, bottomLeft = 20, topLeft = 20 }
                , EFont.color Palette.gray0
                ]
                [ E.paragraph
                    [ E.paddingXY 5 0
                    ]
                    [ E.text "Currently sorting by "
                    , E.el
                        [ EFont.bold ]
                        <| E.text (Data.Audience.audienceTypeToString model.filterBy)
                    ]
                , wrapColorCircle Palette.color3 coolI
                ]

        -- the little panel above the file browser
        upperPanel : E.Element Msg
        upperPanel =
            E.row
                [ E.height <| E.px 50
                , E.paddingEach { top = 0, right = 7, bottom = 0, left = 20 }
                , EBackground.color Palette.gray4
                , E.width E.fill
                ]
                [ upperLeftBackButtonOrText
                , E.el [ E.alignRight ] upperRightInfoElement
                ]

        browser : E.Element Msg
        browser =
            E.column
                [ E.width E.fill
                , E.height E.fill
                , EBackground.color Palette.gray4
                , E.spacing 1
                , EBorder.rounded 7
                , EBorder.width 1
                , EBorder.color Palette.color5

                -- we do this, otherwise the elements inside aren't going to respect
                -- our rounded borders
                , E.htmlAttribute <| Html.Attributes.style "overflow" "hidden"
                ]
                [ upperPanel
                , E.column
                    [ E.width E.fill
                    , E.height E.fill
                    , E.spacing 1
                    ]
                    -- folders first, just like "FIRST_STEP.md" says
                    (audienceFolders ++ audiences )
                ]
    in
    E.row
        [ E.spacing 20
        ]
        [ E.el [ E.alignTop, E.width <| E.px 700 ] browser
        , viewSortingPanel model.filterBy
        ]


viewFolder : Data.AudienceTree.AudienceTree -> List (E.Element Msg) -> List (E.Element Msg)
viewFolder folder acc =
    let
        -- we view a "folder" as a row: the icon, and the name of the folder
        item =
            E.row
                [ E.paddingXY 15 10
                , EBackground.color Palette.gray5
                , EEvents.onClick (FolderClicked folder)
                , EFont.color Palette.gray0
                , E.width E.fill
                , E.spacing 15
                , E.htmlAttribute <| Html.Attributes.style "cursor" "pointer"
                , E.mouseOver <| [ EBackground.color <| E.rgb255 255 255 255 ]
                ]
                [ E.el
                    [ E.width <| E.px 18
                    , E.height <| E.px 18
                    ]
                    <| E.html <| Icons.folder "#6ea4fc"
                , E.text (Data.AudienceTree.getName folder)
                ]
    in
    item :: acc


viewAudience : Data.Audience.Audience -> List (E.Element Msg) -> List (E.Element Msg)
viewAudience audience acc =
    let
        -- we view an "audience" as a row: the icon, and the name of the audience
        item =
            E.row
                [ E.paddingXY 15 10
                , EBackground.color Palette.gray5
                , E.width E.fill
                , E.spacing 15
                , EFont.color Palette.gray0
                , E.mouseOver <| [ EBackground.color <| E.rgb255 255 255 255 ]
                ]
                [ E.el
                    [ E.width <| E.px 17
                    , E.height <| E.px 17
                    ]
                    <| E.html <| Data.Audience.audienceTypeToIcon audience.type_
                , E.text audience.name
                ]
    in
    item :: acc


viewColor : E.Color -> E.Element Msg
viewColor c =
    E.el
        [ E.width E.fill
        , E.height <| E.px 100
        , EBackground.color c
        , E.alignBottom
        ]
        E.none



-- this just wraps some element in a colored circle
wrapColorCircle : E.Color -> E.Element Msg -> E.Element Msg
wrapColorCircle color_ content_ =
    E.el
        [ E.padding 5
        , EBorder.rounded 99999
        , EBackground.color color_
        ]
        content_


colors : List E.Color
colors =
    [ Palette.color0
    , Palette.color1
    , Palette.color2
    , Palette.color3
    , Palette.color4
    , Palette.color5
    ]


viewLoading : LoadingModel -> E.Element Msg
viewLoading loadingModel =
    let
        currentTime =
            case loadingModel.time of
                Just t ->
                    toFloat (Time.posixToMillis t) / 70 -- this controls the speed of the animation
                Nothing ->
                    0

        -- we want each circle to "start" at evenly spaced sizes from one another
        -- so we use this step * (index of each color + 1) to do that
        step =
            toFloat 1 / toFloat (List.length colors)

        maxWidth =
            80

        circleColors =
            List.map viewCircle colors
                |> List.map (\v -> v maxWidth)
                |> List.indexedMap (\i v -> v (toFloat (i + 1) * step))
                |> List.map (\v -> v currentTime)
                |> List.foldl nest E.none
    in
    E.column
        [ E.spacing 20
        , E.centerY
        ]
        [ circleColors
        , E.el
            [ E.centerX
            , E.centerY
            , EFont.size Palette.fontSize3
            , EFont.bold
            , EFont.color Palette.gray0
            ]
            <| E.text "Loading..."
        ]



-- food for thought: Correct me if I'm wrong, but I think E.Element, under this
-- "nest" operation is a monoid

-- 1. identity element
-- the identity element is "E.none"

-- 2. associativity
-- ((thing1 `nest` thing2) `nest` thing3) == (thing1 `nest` (thing2 `nest` thing3))

-- 3. is a magma since the operation between these two things returns another thing
-- of the same type

-- we use this to "nest" circles into one another
nest : E.Element Msg -> E.Element Msg -> E.Element Msg
nest thing1 thing2 =
    -- we can't use "E.row" or "E.column" since we don't want them displayed in
    -- a row or a column, but one in front of the other
    E.el
        [ E.inFront thing2
        , E.centerY
        , E.centerX
        ]
        <| thing1



-- in a production setting I would actually use svg for this sort of thing


viewCircle : E.Color -> Float -> Float -> Float -> E.Element Msg
viewCircle color_ width startingPoint currentPosition =
    let
        w =
            round <| width * abs (sin (currentPosition * startingPoint))
    in
    E.el
        [ E.width <| E.px (round width)
        , E.height <| E.px (round width)
        ]
        <| E.el
            [ EBackground.color color_
            , E.width <| E.px w
            , E.height <| E.px w
            , E.centerX
            , E.centerY
            , E.htmlAttribute <| Html.Attributes.style "border-radius" "50%"
            ]
            <| E.none



{-
   Note on error reporting:
   When I saw these ids that represent "parents" or "folders" I thought a lot
   could go wrong.
   What if we have a folder whose parent id actually points to an "audience"? Or
   an audience whose "folder" id actually points to another "audience"?
   What if there there's cyclical references? folder 1 points to folder 2 and vice versa?
   What if we have a "parent" or "folder" id that points to a folder or parent that
   doesn't exist?

   Initially I thought "ok, cool maybe we can do something in elm to address this".
   But then I realized that that would probably make the app much slower. Having to
   to check for all of these potential errors would bring a lot of complexity
   code-wise and also time-complexity wise. So instead I concluded that this may be
   better addressed on the backend by writing very good tests.
   This way our frontend is faster, easier to understand and our tests for these issues
   only live in one place: the backend.

   Additionally, this made me think that since there are so many things that could go
   wrong by having this model of references between the audiences and audienceFolders,
   maybe this would even better be addressed not by writing really good tests on the
   backend, but instead by data modelling and representing these relationships in a
   better way, thus making these invalid states impossible to even represent, so we
   wouldn't even need to test for them.

   Relevant: Richard Feldman's talk "Making Impossible States Impossible"
   https://www.youtube.com/watch?v=IcgmSRJHu_8

   Just for the record: In production code I wouldn't write these sorts of very long
   comments. I'd instead probably open up an issue or ping the team on slack.
-}

-- I haven't spent much time styling this because this is something the user shouldn't
-- even see. No point in styling it just for it to look cute for the developers
viewJsonError : Json.Decode.Error -> E.Element Msg
viewJsonError err =
    let
        formattedErrText =
            Json.Decode.errorToString err
                |> String.replace "\\n" "\n"
                |> String.replace "\\\"" "\""
    in
    E.el
        [ EBackground.color <| E.rgb255 240 80 105
        , E.width E.fill
        , E.paddingXY 20 20
        , EBorder.rounded 7
        ]
        <|
            E.el
                [ E.centerX
                , E.centerY
                ]
                <| E.text formattedErrText



-- intermediate representation for "audience"s and "audienceFolder"s , so we
-- can easily make dicts out of them

-- audiencesToDict : List Data.Audience.Audience -> Dict.Dict Int FormattedAudience
audiencesToDict audiences =
    audiences
        |> List.map (\a -> ( a.id, a ))
        |> Dict.fromList


-- audienceFoldersToDict : List Data.AudienceFolder.AudienceFolder -> Dict.Dict Int FormattedAudienceFolder
audienceFoldersToDict folders =
    folders
        |> List.map (\f -> ( f.id, f ))
        |> Dict.fromList


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Loading _ ->
            Browser.Events.onAnimationFrame (\posix -> GotTime posix)

        _ ->
            Sub.none


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , subscriptions = subscriptions
        , update = \msg model -> ( update msg model, Cmd.none )
        , init = init
        }
