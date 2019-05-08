module Step08.Tests.Tests exposing (main)

import Expect
import Fuzz
import Html exposing (Html, div)
import Http exposing (Error(..))
import Random
import Step08.CategoriesPage as CategoriesPage exposing (Model, Msg(..), RemoteData(..))
import Test exposing (Test, concat, fuzz, test)
import Test.Html.Selector as Selector
import Test.Runner.Html exposing (defaultConfig, hidePassedTests, viewResults)
import TestContext exposing (SimulatedEffect(..), TestContext, createWithSimulatedEffects, expectViewHas, update)
import Utils.Utils exposing (testStyles)


categoriesUrl : String
categoriesUrl =
    "https://opentdb.com/api_category.php"


categoriesPageProgram : TestContext Msg Model (Cmd Msg)
categoriesPageProgram =
    createWithSimulatedEffects
        { init = CategoriesPage.init
        , update = CategoriesPage.update
        , view = CategoriesPage.view
        , deconstructEffect = \_ -> [ HttpRequest { method = "get", url = categoriesUrl } ]
        }


main : Html a
main =
    div []
        [ testStyles
        , viewResults (Random.initialSeed 1000 |> defaultConfig |> hidePassedTests) suite
        ]


suite : Test
suite =
    concat
        [ theInitMethodShouldFetchCategories
        , theInitModelShouldBeLoading
        , whenTheCategoriesAreLoadingAMessageShouldSaySo
        , whenInitRequestFailTheCategoriesShouldBeOnError
        , whenInitRequestFailThereShouldBeAnError
        , whenInitRequestCompletesTheModelShouldBeUpdated
        , whenInitRequestCompletesTheResultShouldBeDisplayed
        ]


theInitMethodShouldFetchCategories : Test
theInitMethodShouldFetchCategories =
    test "The init method should return a `Cmd` (ideally to fetch categories, but this is not covered by this test)." <|
        \() ->
            Expect.false "The init method should return a Cmd" (Tuple.second CategoriesPage.init == Cmd.none)


theInitModelShouldBeLoading : Test
theInitModelShouldBeLoading =
    test "The init model should indicates that the categories are loading" <|
        \() ->
            Expect.equal (Model Loading) (Tuple.first CategoriesPage.init)


whenTheCategoriesAreLoadingAMessageShouldSaySo : Test
whenTheCategoriesAreLoadingAMessageShouldSaySo =
    test "When the request is loading, the following message should be displayed: \"Loading the categories...\"" <|
        \() ->
            categoriesPageProgram
                |> expectViewHas [ Selector.containing [ Selector.text "Loading the categories..." ] ]


whenInitRequestFailTheCategoriesShouldBeOnError : Test
whenInitRequestFailTheCategoriesShouldBeOnError =
    test "When the request fails, the model should keep track of that and there should be no command sent" <|
        \() ->
            let
                model =
                    CategoriesPage.update (OnCategoriesFetched (Err NetworkError)) (Model Loading)
            in
            Expect.equal ( Model OnError, Cmd.none ) model


whenInitRequestFailThereShouldBeAnError : Test
whenInitRequestFailThereShouldBeAnError =
    test "When the request fails, the following error message should be displayed: \"An error occurred while loading the categories\"" <|
        \() ->
            categoriesPageProgram
                |> update (OnCategoriesFetched (Err NetworkError))
                |> expectViewHas [ Selector.containing [ Selector.text "An error occurred while loading the categories" ] ]


whenInitRequestCompletesTheModelShouldBeUpdated : Test
whenInitRequestCompletesTheModelShouldBeUpdated =
    fuzz Fuzz.string "When the request completes, the model should store the string returned and there should be no command sent" <|
        \randomResponse ->
            let
                model =
                    CategoriesPage.update (OnCategoriesFetched (Ok randomResponse)) (Model Loading)
            in
            Expect.equal ( Model (Loaded randomResponse), Cmd.none ) model


whenInitRequestCompletesTheResultShouldBeDisplayed : Test
whenInitRequestCompletesTheResultShouldBeDisplayed =
    fuzz Fuzz.string "When the request completes, the resulting string should be displayed" <|
        \randomResponse ->
            categoriesPageProgram
                |> update (OnCategoriesFetched (Ok randomResponse))
                |> expectViewHas [ Selector.containing [ Selector.text randomResponse ] ]
