module Step14.Main exposing (Category, Model, Msg(..), RemoteData(..), Route(..), categoriesDecoder, displayCategoriesList, displayCategoriesPage, displayCategory, displayHomepage, displayPage, displayResultPage, displayTestsAndView, getCategoriesRequest, getCategoriesUrl, init, initialModel, main, matcher, parseLocation, update, view)

import Html exposing (Html, a, button, div, h1, iframe, li, text, ul)
import Html.Attributes exposing (class, href, src, style)
import Http
import Json.Decode as Decode
import Navigation exposing (Location)
import Result exposing (Result)
import UrlParser exposing (..)


getCategoriesUrl : String
getCategoriesUrl =
    "https://opentdb.com/api_category.php"


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init, update = update, view = displayTestsAndView, subscriptions = \model -> Sub.none }


type Msg
    = OnCategoriesFetched (Result Http.Error (List Category))
    | OnLocationChange Location


type alias Model =
    { categories : RemoteData (List Category)
    , route : Route
    }


type alias Category =
    { id : Int, name : String }


type RemoteData a
    = Loading
    | Loaded a
    | OnError


type Route
    = HomepageRoute
    | CategoriesRoute
    | ResultRoute Int


matcher : Parser (Route -> a) a
matcher =
    oneOf
        [ map HomepageRoute top
        , map CategoriesRoute (s "categories")
        , map ResultRoute (s "result" </> int)
        ]


parseLocation : Location -> Route
parseLocation location =
    parseHash matcher location
        |> Maybe.withDefault HomepageRoute


initialModel : Location -> Model
initialModel location =
    let
        route =
            parseLocation location
    in
    Model Loading route


init : Location -> ( Model, Cmd Msg )
init location =
    ( initialModel location, Http.send OnCategoriesFetched getCategoriesRequest )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnCategoriesFetched (Ok categories) ->
            ( { model | categories = Loaded categories }, Cmd.none )

        OnCategoriesFetched (Err err) ->
            ( { model | categories = OnError }, Cmd.none )

        OnLocationChange location ->
            ( { model | route = parseLocation location }, Cmd.none )


categoriesDecoder : Decode.Decoder (List Category)
categoriesDecoder =
    Decode.map2 Category (Decode.field "id" Decode.int) (Decode.field "name" Decode.string)
        |> Decode.list
        |> Decode.field "trivia_categories"


getCategoriesRequest : Http.Request (List Category)
getCategoriesRequest =
    Http.get getCategoriesUrl categoriesDecoder


view : Model -> Html Msg
view model =
    div []
        [ displayPage model ]


displayPage : Model -> Html Msg
displayPage model =
    case model.route of
        HomepageRoute ->
            displayHomepage model

        ResultRoute score ->
            displayResultPage score

        CategoriesRoute ->
            displayCategoriesPage model.categories


displayHomepage : Model -> Html Msg
displayHomepage model =
    div [ class "gameOptions" ]
        [ h1 [] [ text "Quiz Game" ]
        , a [ class "btn btn-primary", href "#game" ] [ text "Play random questions" ]
        , a [ class "btn btn-primary", href "#categories" ] [ text "Play from a category" ]
        ]


displayCategoriesPage : RemoteData (List Category) -> Html Msg
displayCategoriesPage categories =
    div []
        [ h1 [] [ text "Play within a given category" ]
        , displayCategoriesList categories
        ]


displayResultPage : Int -> Html Msg
displayResultPage score =
    div [ class "score" ]
        [ h1 [] [ text ("Your score: " ++ toString score ++ " / 5") ]
        , a [ class "btn btn-primary", href "#" ] [ text "Replay" ]
        ]


displayCategoriesList : RemoteData (List Category) -> Html Msg
displayCategoriesList categoriesRemote =
    case categoriesRemote of
        Loaded categories ->
            List.map displayCategory categories
                |> ul [ class "categories" ]

        OnError ->
            text "An error occurred while fetching categories"

        Loading ->
            text "Categories are loading..."


displayCategory : Category -> Html Msg
displayCategory category =
    let
        path =
            "#game/category/" ++ toString category.id
    in
    li []
        [ a [ class "btn btn-primary", href path ] [ text category.name ]
        ]



------------------------------------------------------------------------------------------------------
-- Don't modify the code below, it displays the view and the tests and helps with testing your code --
------------------------------------------------------------------------------------------------------


displayTestsAndView : Model -> Html Msg
displayTestsAndView model =
    div []
        [ div [ class "jumbotron" ] [ view model ]
        , iframe [ src "./Tests/index.html", class "mt-5 w-75 mx-auto d-block", style "height" "500px" ] []
        ]
