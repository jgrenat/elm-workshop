module Step14.Solution.Main exposing (Category, Game, Model, Msg(..), Question, RemoteData(..), Route(..), answersDecoder, categoriesDecoder, correctAnswerDecoder, displayAnswer, displayCategoriesList, displayCategoriesPage, displayCategory, displayGamePage, displayHomepage, displayPage, displayResultPage, displayTestsAndView, gamePage, getCategoriesRequest, getCategoriesUrl, getQuestionsRequest, init, initialCommand, initialModel, main, matcher, parseLocation, questionDecoder, questionsDecoder, questionsUrl, update, view)

import Html exposing (Html, a, button, div, h1, h2, iframe, li, text, ul)
import Html.Attributes exposing (class, href, src, style)
import Http
import Json.Decode as Decode
import Navigation exposing (Location)
import Result exposing (Result)
import UrlParser exposing (..)


questionsUrl : String
questionsUrl =
    "https://opentdb.com/api.php?amount=5&type=multiple"


getCategoriesUrl : String
getCategoriesUrl =
    "https://opentdb.com/api_category.php"


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init, update = update, view = displayTestsAndView, subscriptions = \model -> Sub.none }


type Msg
    = OnCategoriesFetched (Result Http.Error (List Category))
    | OnQuestionsFetched (Result Http.Error (List Question))
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
    | GameRoute (RemoteData Game)
    | CategoriesRoute
    | ResultRoute Int


type alias Question =
    { question : String
    , correctAnswer : String
    , answers : List String
    }


type alias Game =
    { currentQuestion : Question
    , remainingQuestions : List Question
    }


matcher : Parser (Route -> a) a
matcher =
    oneOf
        [ map HomepageRoute top
        , map CategoriesRoute (s "categories")
        , map (GameRoute Loading) (s "game")
        , map ResultRoute (s "result" </> int)
        ]


parseLocation : Location -> Route
parseLocation location =
    parseHash matcher location
        |> Maybe.withDefault HomepageRoute


initialModel : Route -> Model
initialModel route =
    Model Loading route


initialCommand : Route -> Cmd Msg
initialCommand route =
    let
        getCategoriesCmd =
            Http.send OnCategoriesFetched getCategoriesRequest

        getQuestionsCmd =
            Http.send OnQuestionsFetched getQuestionsRequest
    in
    case route of
        GameRoute Loading ->
            Cmd.batch [ getQuestionsCmd, getCategoriesCmd ]

        _ ->
            getCategoriesCmd


init : Location -> ( Model, Cmd Msg )
init location =
    let
        route =
            parseLocation location
    in
    ( initialModel route, initialCommand route )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnCategoriesFetched (Ok categories) ->
            ( { model | categories = Loaded categories }, Cmd.none )

        OnCategoriesFetched (Err err) ->
            ( { model | categories = OnError }, Cmd.none )

        OnQuestionsFetched (Ok (firstQuestion :: remainingQuestions)) ->
            if model.route /= GameRoute Loading then
                ( model, Cmd.none )

            else
                let
                    game =
                        Game firstQuestion remainingQuestions
                in
                ( { model | route = GameRoute (Loaded game) }, Cmd.none )

        OnQuestionsFetched _ ->
            if model.route /= GameRoute Loading then
                ( model, Cmd.none )

            else
                ( { model | route = GameRoute OnError }, Cmd.none )

        OnLocationChange location ->
            let
                route =
                    parseLocation location

                command =
                    if route == GameRoute Loading then
                        Http.send OnQuestionsFetched getQuestionsRequest

                    else
                        Cmd.none
            in
            ( { model | route = parseLocation location }, command )


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

        GameRoute data ->
            displayGamePage data


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


getQuestionsRequest : Http.Request (List Question)
getQuestionsRequest =
    Http.get questionsUrl questionsDecoder


questionsDecoder : Decode.Decoder (List Question)
questionsDecoder =
    Decode.field "results" (Decode.list questionDecoder)


questionDecoder : Decode.Decoder Question
questionDecoder =
    Decode.map3
        Question
        (Decode.field "question" Decode.string)
        correctAnswerDecoder
        answersDecoder


correctAnswerDecoder : Decode.Decoder String
correctAnswerDecoder =
    Decode.field "correct_answer" Decode.string


answersDecoder : Decode.Decoder (List String)
answersDecoder =
    Decode.map2
        (::)
        correctAnswerDecoder
        (Decode.field "incorrect_answers" (Decode.list Decode.string))


displayGamePage : RemoteData Game -> Html Msg
displayGamePage data =
    case data of
        Loading ->
            text "Loading the questions..."

        OnError ->
            text "An unknown error occurred while loading the questions."

        Loaded game ->
            div [] [ gamePage game.currentQuestion ]


gamePage : Question -> Html msg
gamePage question =
    div []
        [ h2 [ class "question" ] [ text question.question ]
        , ul [ class "answers" ] (List.map displayAnswer question.answers)
        ]


displayAnswer : String -> Html msg
displayAnswer answer =
    li [] [ a [ class "btn btn-primary" ] [ text answer ] ]


displayTestsAndView : Model -> Html Msg
displayTestsAndView model =
    div []
        [ div [ class "jumbotron" ] [ view model ]
        ]
