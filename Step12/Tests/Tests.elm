module Step12.Tests.Tests exposing (main)

import Expect exposing (Expectation)
import Fuzz
import Html exposing (Html, div)
import Random
import Step12.GamePage exposing (Question, gamePage)
import Test exposing (Test, concat, fuzz)
import Test.Html.Query as Query
import Test.Html.Selector exposing (Selector, class, classes, tag, text)
import Test.Runner.Html exposing (defaultConfig, hidePassedTests, viewResults)
import Utils.Utils exposing (testStyles)


main : Html msg
main =
    div []
        [ testStyles
        , viewResults (Random.initialSeed 1000 |> defaultConfig |> hidePassedTests) testsSuite
        ]


testsSuite : Test
testsSuite =
    concat
        [ questionIsDisplayedIntoAH2Tag
        , theH2TagHasClassQuestion
        , answersAreDisplayedInsideAListWithClassAnswers
        , answersAreDisplayedInsideLiTags
        , answersHaveProperClasses
        ]


questionIsDisplayedIntoAH2Tag : Test
questionIsDisplayedIntoAH2Tag =
    fuzz questionFuzzer "The question is displayed inside an `h2` tag" <|
        \question ->
            gamePage question
                |> Query.fromHtml
                |> Query.find [ tag "h2" ]
                |> Query.has [ text question.question ]


theH2TagHasClassQuestion : Test
theH2TagHasClassQuestion =
    fuzz questionFuzzer "The `h2` tag has the class \"question\"" <|
        \question ->
            gamePage question
                |> Query.fromHtml
                |> Query.find [ tag "h2" ]
                |> Query.has [ class "question" ]


answersAreDisplayedInsideAListWithClassAnswers : Test
answersAreDisplayedInsideAListWithClassAnswers =
    fuzz questionFuzzer "The answers are displayed inside a `ul` tag with the class \"answers\"" <|
        \question ->
            gamePage question
                |> Query.fromHtml
                |> Query.find [ tag "ul" ]
                |> Query.has [ class "answers" ]


answersAreDisplayed : Test
answersAreDisplayed =
    fuzz questionFuzzer "The answers are displayed" <|
        \question ->
            let
                expectations : List (Query.Single msg -> Expectation)
                expectations =
                    List.map (text >> List.singleton >> Query.has) question.answers
            in
            gamePage question
                |> Query.fromHtml
                |> Expect.all expectations


answersAreDisplayedInsideLiTags : Test
answersAreDisplayedInsideLiTags =
    fuzz questionFuzzer "The answers are displayed each inside a `li`" <|
        \question ->
            gamePage question
                |> Query.fromHtml
                |> Query.findAll [ tag "li" ]
                |> Query.count (Expect.equal 4)


answersHaveProperClasses : Test
answersHaveProperClasses =
    fuzz questionFuzzer "The answers have a link with classes \"btn btn-primary\"" <|
        \question ->
            gamePage question
                |> Query.fromHtml
                |> Query.findAll [ tag "li" ]
                |> Query.each (Query.has [ tag "a", classes [ "btn", "btn-primary" ] ])


questionFuzzer : Fuzz.Fuzzer Question
questionFuzzer =
    Fuzz.map5
        (\question answer1 answer2 answer3 answer4 ->
            Question question
                answer1
                [ answer1
                , answer2
                , answer3
                , answer4
                ]
        )
        Fuzz.string
        Fuzz.string
        Fuzz.string
        Fuzz.string
        Fuzz.string
