module Main exposing (main)

import Data.Audience as Audience exposing (Audience)
import Data.AudienceFolder as AudienceFolder exposing (AudienceFolder)
import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Json.Decode as JD exposing (Decoder)


{-| Because of the fixtures, we don't need a full fledged `Html.program`.
-}
main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = init
        , update = update
        , view = view
        }


type alias Model =
    { {- We could use RoseTree and/or a zipper, but I went with the dead-easy
         way of filtering the dict (or flat list in my first attempt) each time.
         Might reconsider this if dealing with performance issues!

         ---

         `Nothing` here means the root folder. We also might create a custom
         union type to make our intentions more clear:

             type Location = Root | Folder Int

         Some helper functions (`map` + `withDefault` or conversion to `Maybe`
         come to mind) would then be benefitial.
      -}
      currentFolder : Maybe Int
    }


type Msg
    = OpenFolder (Maybe Int)


{-| We could have this data in model, and in a real app we probably would
(because this data wouldn't be a constant fixture but something fetched from
the API). But given the constraints, it's nice to factor this out of the model.

---

I went with `Dict Int Audience` approach over a `List` approach - there was some
`List.filter`ing when I tried that one initially. So, changed that into `Dict`.

-}
audiences : Dict Int Audience
audiences =
    Audience.audiencesJSON
        |> JD.decodeString Audience.audiencesDecoder
        |> Result.withDefault []
        |> List.map (\audience -> ( audience.id, audience ))
        |> Dict.fromList


{-| The same as with `audiences`.
-}
audienceFolders : Dict Int AudienceFolder
audienceFolders =
    AudienceFolder.audienceFoldersJSON
        |> JD.decodeString AudienceFolder.audienceFoldersDecoder
        |> Result.withDefault []
        |> List.map (\audienceFolder -> ( audienceFolder.id, audienceFolder ))
        |> Dict.fromList


init : Model
init =
    { currentFolder = Nothing
    }


{-| Could factor each Msg handler into its own function, but it is currently so
small that it probably wouldn't be worth it. Depends on the team code style.
-}
update : Msg -> Model -> Model
update msg model =
    case msg of
        OpenFolder folderId ->
            { model | currentFolder = folderId }


{-| Gives a bit more meaning to the Dict.get, and lets us not use `flip`.
-}
findFolder : Int -> Maybe AudienceFolder
findFolder folderId =
    audienceFolders
        |> Dict.get folderId


view : Model -> Html Msg
view model =
    let
        {- This filtering would be unnecessary if we parsed the input data into a RoseTree. -}
        visibleAudiences : List Audience
        visibleAudiences =
            audiences
                |> Dict.filter (\_ audience -> audience.folder == model.currentFolder)
                |> Dict.values

        {- The same as with `visibleAudiences`. -}
        visibleAudienceFolders : List AudienceFolder
        visibleAudienceFolders =
            audienceFolders
                |> Dict.filter (\_ audienceFolder -> audienceFolder.parent == model.currentFolder)
                |> Dict.values
    in
    Html.ul []
        (viewBackButton model.currentFolder
            ++ viewAudienceFolders visibleAudienceFolders
            ++ viewAudiences visibleAudiences
        )


{-| Only show the back button if we're not in root.
-}
viewBackButton : Maybe Int -> List (Html Msg)
viewBackButton currentFolder =
    currentFolder
        |> Maybe.andThen findFolder
        |> Maybe.map
            (\folder ->
                let
                    {- Experimented with a few ways to get both the current
                       folder and the parent folder name, and this `let` inside
                       the inner function was what I ended up with.

                       It can be juggled to look nicer but perform duplicate
                       computations. ¯\_(ツ)_/¯ Again, depends on team code style.
                    -}
                    parentFolderName : String
                    parentFolderName =
                        folder.parent
                            |> Maybe.andThen findFolder
                            |> Maybe.map .name
                            |> Maybe.withDefault "Root"
                in
                [ Html.li
                    [ Html.Attributes.style
                        [ ( "padding", "8px" )
                        , ( "margin-bottom", "2px" )
                        , ( "background-color", "#003" )
                        , ( "color", "#ddf" )
                        ]
                    , Html.Events.onClick (OpenFolder folder.parent)
                    ]
                    [ Html.text ("<< Go up to " ++ parentFolderName) ]
                ]
            )
        |> Maybe.withDefault []



-- The rest of the view functions have nothing interesting going on in them.


viewAudienceFolders : List AudienceFolder -> List (Html Msg)
viewAudienceFolders audienceFolders =
    audienceFolders
        |> List.map viewAudienceFolder


viewAudienceFolder : AudienceFolder -> Html Msg
viewAudienceFolder folder =
    Html.li
        [ Html.Attributes.style
            [ ( "padding", "8px" )
            , ( "margin-bottom", "2px" )
            , ( "background-color", "#aae" )
            ]
        , Html.Events.onClick (OpenFolder (Just folder.id))
        ]
        [ Html.text folder.name ]


viewAudiences : List Audience -> List (Html Msg)
viewAudiences audiences =
    audiences
        |> List.map viewAudience


viewAudience : Audience -> Html Msg
viewAudience audience =
    Html.li
        [ Html.Attributes.style
            [ ( "padding", "8px" )
            , ( "margin-bottom", "2px" )
            , ( "background-color", "#ccf" )
            ]
        ]
        [ Html.text audience.name ]
