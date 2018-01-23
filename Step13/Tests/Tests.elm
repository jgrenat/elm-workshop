module Step13.Tests.Tests exposing (..)

import Fuzz
import Http exposing (Error(NetworkError))
import Step13.GamePage as GamePage exposing (Game, Model, Msg(..), Question, RemoteData(..))
import Test.Runner.Html exposing (run)
import Test exposing (Test, describe, fuzz, test)
import Expect
import Html.Attributes exposing (href)
import Testable.Cmd
import Testable
import Testable.TestContext exposing (..)
import Testable.Http exposing (ok, serverError)
import Json.Encode as Encode


questionsUrl : String
questionsUrl =
    "https://opentdb.com/api.php?amount=5&type=multiple"


expectedRequest =
    Testable.Http.getRequest questionsUrl


gamePageComponent : Component Msg Model
gamePageComponent =
    Component GamePage.init GamePage.update GamePage.view


main =
    describe "What we expect:"
        [ theInitMethodShouldFetchQuestions
        , theInitModelShouldBeLoading
        , theInitMethodRequestShouldBeAGETRequestToProperUrl
        , whenTheCategoriesAreLoadingAMessageShouldSaySo
        , whenInitRequestFailTheCategoriesShouldBeOnError
        , whenInitRequestFailThereShouldBeAnError
        , whenInitRequestCompletesTheModelShouldBeUpdated
        , whenInitRequestCompletesTheResultShouldBeDisplayed
        ]
        |> run


theInitMethodShouldFetchQuestions : Test
theInitMethodShouldFetchQuestions =
    test "The init method should return a `Cmd` (ideally to fetch questions, but this is not covered by this test)." <|
        \() ->
            Expect.notEqual Testable.Cmd.none (Tuple.second GamePage.init)


theInitModelShouldBeLoading : Test
theInitModelShouldBeLoading =
    test "The init model should indicates that the questions are loading" <|
        \() ->
            Expect.equal (Model Loading) (Tuple.first GamePage.init)


theInitMethodRequestShouldBeAGETRequestToProperUrl : Test
theInitMethodRequestShouldBeAGETRequestToProperUrl =
    test ("The request should be a GET request to the url \"" ++ questionsUrl ++ "\"") <|
        \() ->
            gamePageComponent
                |> startForTest
                |> assertHttpRequest expectedRequest


whenTheCategoriesAreLoadingAMessageShouldSaySo : Test
whenTheCategoriesAreLoadingAMessageShouldSaySo =
    test ("When the request is loading, the following message should be displayed: \"Loading the questions...\"") <|
        \() ->
            gamePageComponent
                |> startForTest
                |> assertText (String.contains "Loading the questions..." >> Expect.true "The message is not displayed")


whenInitRequestFailTheCategoriesShouldBeOnError : Test
whenInitRequestFailTheCategoriesShouldBeOnError =
    test ("When the request fails, the model should keep track of that") <|
        \() ->
            gamePageComponent
                |> startForTest
                |> resolveHttpRequest expectedRequest serverError
                |> assertCurrentModel (Model OnError)


whenInitRequestFailThereShouldBeAnError : Test
whenInitRequestFailThereShouldBeAnError =
    test ("When the request fails, the following error message should be displayed: \"An unknown error occurred while loading the questions\"") <|
        \() ->
            gamePageComponent
                |> startForTest
                |> resolveHttpRequest expectedRequest serverError
                |> assertText (String.contains "An unknown error occurred while loading the questions" >> Expect.true "The message is not displayed")


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

                        questionsJson =
                            Encode.encode 0 (questionsListEncoder randomQuestions)
                    in
                        gamePageComponent
                            |> startForTest
                            |> resolveHttpRequest expectedRequest (ok questionsJson)
                            |> assertCurrentModel expectedModel


whenInitRequestCompletesTheResultShouldBeDisplayed : Test
whenInitRequestCompletesTheResultShouldBeDisplayed =
    fuzz randomQuestionsFuzz ("When the request completes, the first question should be displayed") <|
        \randomQuestions ->
            let
                questionsJson =
                    Encode.encode 0 (questionsListEncoder randomQuestions)
            in
                case randomQuestions of
                    [] ->
                        Expect.pass

                    firstQuestion :: _ ->
                        gamePageComponent
                            |> startForTest
                            |> resolveHttpRequest expectedRequest (ok questionsJson)
                            |> assertText (String.contains firstQuestion.question >> Expect.true "The first question is not displayed")


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


questionsListEncoder : List Question -> Encode.Value
questionsListEncoder categories =
    categories
        |> List.map questionEncoder
        |> Encode.list
        |> \questions -> Encode.object [ ( "results", questions ) ]


questionEncoder : Question -> Encode.Value
questionEncoder question =
    let
        incorrectAnswers =
            question.answers
                |> List.drop 1
                |> List.map Encode.string
    in
        Encode.object
            [ ( "question", Encode.string question.question )
            , ( "correct_answer", Encode.string question.correctAnswer )
            , ( "incorrect_answers", Encode.list incorrectAnswers )
            , ( "categories", Encode.string "Science & Nature" )
            , ( "type", Encode.string "multiple" )
            , ( "difficulty", Encode.string "medium" )
            ]
