module Step13.Tests.Tests exposing (main)

import Expect
import Fuzz
import Html exposing (Html)
import Http exposing (Error(..))
import Random
import Step13.GamePage as GamePage exposing (Game, Model, Msg(..), Question, RemoteData(..))
import Test exposing (Test, concat, fuzz, test)
import Test.Html.Selector as Selector
import Test.Runner.Html exposing (defaultConfig, hidePassedTests, viewResults)
import TestContext exposing (SimulatedEffect(..), TestContext, createWithSimulatedEffects, expectModel, expectViewHas, simulateLastEffect)


questionsUrl : String
questionsUrl =
    "https://opentdb.com/api.php?amount=5&type=multiple"


gamePageProgram : TestContext Msg Model (Cmd Msg)
gamePageProgram =
    createWithSimulatedEffects
        { init = GamePage.init
        , update = GamePage.update
        , view = GamePage.view
        , deconstructEffect = \_ -> [ HttpRequest { method = "GET", url = questionsUrl } ]
        }


main : Html a
main =
    viewResults (Random.initialSeed 1000 |> defaultConfig |> hidePassedTests) testsSuite


testsSuite : Test
testsSuite =
    concat
        [ theInitMethodShouldFetchQuestions
        , theInitModelShouldBeLoading
        , whenTheCategoriesAreLoadingAMessageShouldSaySo
        , whenInitRequestFailTheCategoriesShouldBeOnError
        , whenInitRequestFailThereShouldBeAnError
        , whenInitRequestCompletesTheModelShouldBeUpdated
        , whenInitRequestCompletesTheResultShouldBeDisplayed
        ]


theInitMethodShouldFetchQuestions : Test
theInitMethodShouldFetchQuestions =
    test "The init method should return a `Cmd` (ideally to fetch questions, but this is not covered by this test)." <|
        \() ->
            Expect.notEqual Cmd.none (Tuple.second GamePage.init)


theInitModelShouldBeLoading : Test
theInitModelShouldBeLoading =
    test "The init model should indicates that the questions are loading" <|
        \() ->
            Expect.equal (Model Loading) (Tuple.first GamePage.init)


whenTheCategoriesAreLoadingAMessageShouldSaySo : Test
whenTheCategoriesAreLoadingAMessageShouldSaySo =
    test "When the request is loading, the following message should be displayed: \"Loading the questions...\"" <|
        \() ->
            gamePageProgram
                |> expectViewHas [ Selector.containing [ Selector.text "Loading the questions..." ] ]


whenInitRequestFailTheCategoriesShouldBeOnError : Test
whenInitRequestFailTheCategoriesShouldBeOnError =
    test "When the request fails, the model should keep track of that" <|
        \() ->
            gamePageProgram
                |> simulateLastEffect (\_ -> Ok [ Err NetworkError |> OnQuestionsFetched ])
                |> expectModel (Expect.equal (Model OnError))


whenInitRequestFailThereShouldBeAnError : Test
whenInitRequestFailThereShouldBeAnError =
    test "When the request fails, the following error message should be displayed: \"An unknown error occurred while loading the questions\"" <|
        \() ->
            gamePageProgram
                |> simulateLastEffect (\_ -> Ok [ Err NetworkError |> OnQuestionsFetched ])
                |> expectViewHas [ Selector.containing [ Selector.text "An unknown error occurred while loading the questions" ] ]


whenInitRequestCompletesTheModelShouldBeUpdated : Test
whenInitRequestCompletesTheModelShouldBeUpdated =
    fuzz randomQuestionsFuzz "When the request completes, the model should store the questions returned" <|
        \randomQuestions ->
            case randomQuestions of
                [] ->
                    Expect.pass

                firstQuestion :: remainingQuestions ->
                    let
                        expectedModel =
                            Model (Loaded (Game firstQuestion remainingQuestions))
                    in
                    gamePageProgram
                        |> simulateLastEffect (\_ -> Ok [ Ok randomQuestions |> OnQuestionsFetched ])
                        |> expectModel (Expect.equal expectedModel)


whenInitRequestCompletesTheResultShouldBeDisplayed : Test
whenInitRequestCompletesTheResultShouldBeDisplayed =
    fuzz randomQuestionsFuzz "When the request completes, the first question should be displayed" <|
        \randomQuestions ->
            case randomQuestions of
                [] ->
                    Expect.pass

                firstQuestion :: _ ->
                    gamePageProgram
                        |> simulateLastEffect (\_ -> Ok [ Ok randomQuestions |> OnQuestionsFetched ])
                        |> expectViewHas [ Selector.containing [ Selector.text firstQuestion.question ] ]


randomQuestionsFuzz : Fuzz.Fuzzer (List Question)
randomQuestionsFuzz =
    Fuzz.map5
        (\question answer1 answer2 answer3 answer4 ->
            Question question answer1 [ answer1, answer2, answer3, answer4 ]
        )
        Fuzz.string
        Fuzz.string
        Fuzz.string
        Fuzz.string
        Fuzz.string
        |> Fuzz.list
