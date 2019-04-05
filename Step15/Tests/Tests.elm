module Step15.Tests.Tests exposing (afterAnsweringLastQuestionWeShouldBeRedirectedToProperResult, afterAnsweringLastQuestionWeShouldBeRedirectedToResult, afterClickingTheProperAnswerTheModelShouldBeUpdated, afterClickingTheWrongAnswerTheModelShouldBeUpdated, categoriesUrl, fakeGameLocation, initialModel, main, questionsUrl, randomQuestionFuzz, randomTwoQuestionsListFuzz, whenQuestionsAreLoadedTheFirstQuestionShouldBeDisplayed)

import ElmEscapeHtml exposing (unescape)
import Expect exposing (Expectation)
import Fuzz exposing (intRange)
import Http exposing (Error(..))
import Json.Encode as Encode
import Step15.Main exposing (init)
import Step15.Types exposing (AnsweredQuestion, Game, Model, Msg(..), Question, QuestionStatus(..), RemoteData(..), Route(..))
import Step15.Update exposing (update)
import Step15.View exposing (view)
import Test exposing (Test, describe, fuzz, test)
import Test.Html.Event exposing (Event, click, simulate, toResult)
import Test.Html.Query as Query
import Test.Html.Selector exposing (tag, text)
import Test.Runner.Html exposing (run)


fakeGameLocation =
    { href = "http://localhost:8080/Step15/index.html#game"
    , host = "localhost"
    , hostname = "localhost"
    , protocol = "http:"
    , origin = "http://localhost:8080/Step15/"
    , port_ = "8000"
    , pathname = "/Step15/index.html"
    , search = ""
    , hash = "#game"
    , username = ""
    , password = ""
    }


categoriesUrl : String
categoriesUrl =
    "https://opentdb.com/api_category.php"


questionsUrl : String
questionsUrl =
    "https://opentdb.com/api.php?amount=5&type=multiple"


main =
    describe "What we expect:"
        [ whenQuestionsAreLoadedTheFirstQuestionShouldBeDisplayed
        , afterClickingTheProperAnswerTheModelShouldBeUpdated
        , afterClickingTheWrongAnswerTheModelShouldBeUpdated
        , afterAnsweringLastQuestionWeShouldBeRedirectedToResult
        ]
        |> run


initialModel =
    init fakeGameLocation


whenQuestionsAreLoadedTheFirstQuestionShouldBeDisplayed : Test
whenQuestionsAreLoadedTheFirstQuestionShouldBeDisplayed =
    fuzz randomTwoQuestionsListFuzz "When questions are loaded, the first question should be displayed" <|
        \randomQuestions ->
            case randomQuestions of
                [ question1, question2 ] ->
                    let
                        updatedView =
                            init fakeGameLocation
                                |> Tuple.first
                                |> update (OnQuestionsFetched <| Ok [ question1, question2 ])
                                |> Tuple.first
                                |> view
                    in
                    updatedView
                        |> Query.fromHtml
                        |> Query.has [ text (unescape question1.question) ]

                _ ->
                    Expect.pass


afterClickingTheProperAnswerTheModelShouldBeUpdated : Test
afterClickingTheProperAnswerTheModelShouldBeUpdated =
    fuzz randomTwoQuestionsListFuzz "After clicking the proper answer, model should indicate that it's correct and go to next question" <|
        \randomQuestions ->
            case randomQuestions of
                [ question1, question2 ] ->
                    let
                        initialModel =
                            init fakeGameLocation
                                |> Tuple.first
                                |> update (OnQuestionsFetched <| Ok [ question1, question2 ])
                                |> Tuple.first

                        modelAfterClickOnProperAnswer =
                            view initialModel
                                |> Query.fromHtml
                                |> Query.findAll [ tag "a" ]
                                |> Query.first
                                |> simulate click
                                |> toResult
                                |> Result.map (\msg -> update msg initialModel)
                                |> Result.map Tuple.first

                        expectedGame =
                            Game [ AnsweredQuestion question1 Correct ] question2 []
                    in
                    case modelAfterClickOnProperAnswer of
                        Err _ ->
                            Expect.fail "A click on an answer should generate a message to update the model"

                        Ok model ->
                            Expect.equal (Model Loading <| GameRoute (Loaded expectedGame)) model

                _ ->
                    Expect.pass


afterClickingTheWrongAnswerTheModelShouldBeUpdated : Test
afterClickingTheWrongAnswerTheModelShouldBeUpdated =
    fuzz randomTwoQuestionsListFuzz "After clicking the wrong answer, model should indicate that it's incorrect and go to next question" <|
        \randomQuestions ->
            case randomQuestions of
                [ question1, question2 ] ->
                    let
                        initialModel =
                            init fakeGameLocation
                                |> Tuple.first
                                |> update (OnQuestionsFetched <| Ok [ question1, question2 ])
                                |> Tuple.first

                        modelAfterClickOnWrongAnswer =
                            view initialModel
                                |> Query.fromHtml
                                |> Query.findAll [ tag "a" ]
                                |> Query.index 1
                                |> simulate click
                                |> toResult
                                |> Result.map (\msg -> update msg initialModel)
                                |> Result.map Tuple.first

                        expectedGame =
                            Game [ AnsweredQuestion question1 Incorrect ] question2 []
                    in
                    case modelAfterClickOnWrongAnswer of
                        Err _ ->
                            Expect.fail "A click on an answer should generate a message to update the model"

                        Ok model ->
                            Expect.equal (Model Loading <| GameRoute (Loaded expectedGame)) model

                _ ->
                    Expect.pass


afterAnsweringLastQuestionWeShouldBeRedirectedToResult : Test
afterAnsweringLastQuestionWeShouldBeRedirectedToResult =
    fuzz randomTwoQuestionsListFuzz "After answering the last question, we should be redirect to result page" <|
        \randomQuestions ->
            case randomQuestions of
                [ question1, question2 ] ->
                    let
                        initialModel =
                            Game [ AnsweredQuestion question1 Correct ] question2 []
                                |> Loaded
                                |> GameRoute
                                |> Model Loading

                        modelAfterClickOnAnswer =
                            view initialModel
                                |> Query.fromHtml
                                |> Query.findAll [ tag "a" ]
                                |> Query.index 1
                                |> simulate click
                                |> toResult
                                |> Result.map (\msg -> update msg initialModel)
                                |> Result.map Tuple.first
                    in
                    case modelAfterClickOnAnswer of
                        Err _ ->
                            Expect.fail "A click on an answer should generate a message to update the model"

                        Ok { route } ->
                            case route of
                                ResultRoute _ ->
                                    Expect.pass

                                _ ->
                                    Expect.fail "The user should be redirected to the score page"

                _ ->
                    Expect.pass


afterAnsweringLastQuestionWeShouldBeRedirectedToProperResult : Test
afterAnsweringLastQuestionWeShouldBeRedirectedToProperResult =
    fuzz randomTwoQuestionsListFuzz "After answering the last question, we should be redirect to result page with the proper score" <|
        \randomQuestions ->
            case randomQuestions of
                [ question1, question2 ] ->
                    let
                        initialModel =
                            Game [ AnsweredQuestion question1 Correct ] question2 []
                                |> Loaded
                                |> GameRoute
                                |> Model Loading

                        modelAfterClickOnWrongAnswer =
                            view initialModel
                                |> Query.fromHtml
                                |> Query.findAll [ tag "a" ]
                                |> Query.index 1
                                |> simulate click
                                |> toResult
                                |> Result.map (\msg -> update msg initialModel)
                                |> Result.map Tuple.first
                    in
                    case modelAfterClickOnWrongAnswer of
                        Err _ ->
                            Expect.fail "A click on an answer should generate a message to update the model"

                        Ok { route } ->
                            case route of
                                ResultRoute 1 ->
                                    Expect.pass

                                _ ->
                                    Expect.fail "The user should be redirected to the score page with score 1"

                _ ->
                    Expect.pass


randomTwoQuestionsListFuzz : Fuzz.Fuzzer (List Question)
randomTwoQuestionsListFuzz =
    Fuzz.map2
        (List.singleton >> (\b a -> (::) a b))
        randomQuestionFuzz
        randomQuestionFuzz


randomQuestionFuzz : Fuzz.Fuzzer Question
randomQuestionFuzz =
    Fuzz.map5
        (\question answer1 answer2 answer3 answer4 ->
            Question question answer1 [ answer1, answer2, answer3, answer4 ]
        )
        Fuzz.string
        Fuzz.string
        Fuzz.string
        Fuzz.string
        Fuzz.string
