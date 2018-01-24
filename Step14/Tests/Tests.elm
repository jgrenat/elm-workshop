module Step14.Tests.Tests exposing (..)

import Fuzz exposing (intRange)
import Http exposing (Error(NetworkError))
import Step14.Main exposing (Msg(OnCategoriesFetched, OnLocationChange), categoriesDecoder, init, update, view)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, text)
import Test.Html.Event exposing (simulate, toResult, click)
import Test.Runner.Html exposing (run)
import Test exposing (Test, describe, fuzz, test)
import Expect exposing (Expectation)
import Html.Attributes exposing (href, type_)
import Json.Encode as Encode
import Testable.Html.Selectors exposing (tag)


fakeLocation =
    { href = "http://localhost:8080/Step14/index.html"
    , host = "localhost"
    , hostname = "localhost"
    , protocol = "http:"
    , origin = "http://localhost:8080/Step14/"
    , port_ = "8000"
    , pathname = "/Step14/index.html"
    , search = ""
    , hash = ""
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
        [ atLoadingCategoriesShouldBeFetched
        , atBasePathHomepageShouldBeDisplayed
        , whenGoingToCategoriesPathCategoriesShouldBeDisplayed
        , whenGoingToResultPathResultShouldBeDisplayed
        , whenGoingToResultPathResultShouldBeDisplayedWithProperScore
        , whenGoingToGamePathGamePageShouldBeDisplayed
        , whenGoingToGamePathQuestionsShouldBeFetched
        ]
        |> run


expectedGetCategoriesCmd =
    Http.get categoriesUrl categoriesDecoder
        |> Http.send OnCategoriesFetched


atLoadingCategoriesShouldBeFetched : Test
atLoadingCategoriesShouldBeFetched =
    test "When loading the page, the categories should be fetched" <|
        \() ->
            Expect.notEqual Cmd.none (init fakeLocation |> Tuple.second)


atBasePathHomepageShouldBeDisplayed : Test
atBasePathHomepageShouldBeDisplayed =
    test "When loading the page, the homepage should appear" <|
        \() ->
            let
                initialModel =
                    init fakeLocation |> Tuple.first
            in
                view initialModel
                    |> Query.fromHtml
                    |> Expect.all
                        [ Query.has [ text "Quiz Game" ]
                        , Query.has [ text "Play random questions" ]
                        , Query.has [ text "Play from a category" ]
                        ]


whenGoingToCategoriesPathCategoriesShouldBeDisplayed : Test
whenGoingToCategoriesPathCategoriesShouldBeDisplayed =
    test "When we go on the categories link (/#categories), the categories page should be displayed" <|
        \() ->
            let
                initialModel =
                    init fakeLocation
                        |> Tuple.first

                newLocation =
                    { fakeLocation | hash = "#categories" }

                updatedView =
                    update (OnLocationChange newLocation) initialModel
                        |> Tuple.first
                        |> view
            in
                updatedView
                    |> Query.fromHtml
                    |> Expect.all
                        [ Query.has [ text "Categories are loading" ]
                        , Query.hasNot [ text "Play from a category" ]
                        ]


whenGoingToResultPathResultShouldBeDisplayed : Test
whenGoingToResultPathResultShouldBeDisplayed =
    test "When we go to the path \"#result/{score}\", the result page should be displayed" <|
        \() ->
            let
                initialModel =
                    init fakeLocation
                        |> Tuple.first

                newLocation =
                    { fakeLocation | hash = "#result/3" }

                updatedView =
                    update (OnLocationChange newLocation) initialModel
                        |> Tuple.first
                        |> view
            in
                updatedView
                    |> Query.fromHtml
                    |> Expect.all
                        [ Query.has [ text "Your score" ]
                        , Query.hasNot [ text "Play from a category" ]
                        ]


whenGoingToResultPathResultShouldBeDisplayedWithProperScore : Test
whenGoingToResultPathResultShouldBeDisplayedWithProperScore =
    fuzz (intRange 0 5) "When we go to the path \"#result/{score}\", the result page should be displayed with the proper result" <|
        \score ->
            let
                initialModel =
                    init fakeLocation
                        |> Tuple.first

                newLocation =
                    { fakeLocation | hash = "#result/" ++ (toString score) }

                updatedView =
                    update (OnLocationChange newLocation) initialModel
                        |> Tuple.first
                        |> view
            in
                updatedView
                    |> Query.fromHtml
                    |> Query.has [ (toString score) ++ " / 5" |> text ]


whenGoingToGamePathGamePageShouldBeDisplayed : Test
whenGoingToGamePathGamePageShouldBeDisplayed =
    test "When we go to the path \"#game\", the game page should be displayed" <|
        \() ->
            let
                initialModel =
                    init fakeLocation
                        |> Tuple.first

                newLocation =
                    { fakeLocation | hash = "#game" }

                updatedView =
                    update (OnLocationChange newLocation) initialModel
                        |> Tuple.first
                        |> view
            in
                updatedView
                    |> Query.fromHtml
                    |> Query.has [ text "Loading the questions" ]


whenGoingToGamePathQuestionsShouldBeFetched : Test
whenGoingToGamePathQuestionsShouldBeFetched =
    test "When we go to the path \"#game\", questions should be fetched" <|
        \() ->
            let
                initialModel =
                    init fakeLocation
                        |> Tuple.first

                newLocation =
                    { fakeLocation | hash = "#game" }

                updatedCommand =
                    update (OnLocationChange newLocation) initialModel
                        |> Tuple.second
            in
                Expect.notEqual Cmd.none updatedCommand
