module Step11.Tests.Tests exposing (..)

import Fuzz exposing (intRange)
import Http exposing (Error(NetworkError))
import Step11.Routing exposing (Category, Model, Msg(..), RemoteData(..), categoriesDecoder, init, update, view)
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
    { href = "http://localhost:8080/Step11/index.html"
    , host = "localhost"
    , hostname = "localhost"
    , protocol = "http:"
    , origin = "http://localhost:8080/Step11/"
    , port_ = "8000"
    , pathname = "/Step11/index.html"
    , search = ""
    , hash = ""
    , username = ""
    , password = ""
    }


categoriesUrl : String
categoriesUrl =
    "https://opentdb.com/api_category.php"


expectedRequest =
    Http.get categoriesUrl categoriesDecoder


main =
    describe "What we expect:"
        [ atLoadingCategoriesShouldBeFetched
        , atLoadingHomepageShouldBeDisplayed
        , whenGoingToCategoriesLinkCategoriesShouldBeDisplayed
        , whenGoingToResultLinkResultShouldBeDisplayed
        , whenGoingToResultLinkResultShouldBeDisplayedWithProperScore
        ]
        |> run


atLoadingCategoriesShouldBeFetched : Test
atLoadingCategoriesShouldBeFetched =
    test "When loading the page, the categories should be fetched" <|
        \() ->
            Expect.notEqual Cmd.none (init fakeLocation |> Tuple.second)


atLoadingHomepageShouldBeDisplayed : Test
atLoadingHomepageShouldBeDisplayed =
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
                        , Query.has [ text "Play from a category" ]
                        , Query.has [ text "Show me the results page" ]
                        ]


whenGoingToCategoriesLinkCategoriesShouldBeDisplayed : Test
whenGoingToCategoriesLinkCategoriesShouldBeDisplayed =
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


whenGoingToResultLinkResultShouldBeDisplayed : Test
whenGoingToResultLinkResultShouldBeDisplayed =
    test "When we click on the second link, the result page should be displayed" <|
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


whenGoingToResultLinkResultShouldBeDisplayedWithProperScore : Test
whenGoingToResultLinkResultShouldBeDisplayedWithProperScore =
    fuzz (intRange 0 5) "When we click on the second link, the result page should be displayed with the proper result" <|
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
