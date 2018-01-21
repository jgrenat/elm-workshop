module Step9.Tests.Tests exposing (..)

import Fuzz
import Http exposing (Error(NetworkError))
import Step9.CategoriesPage as CategoriesPage exposing (Msg(..), RemoteData(..), Model)
import Test.Runner.Html exposing (run)
import Test exposing (Test, describe, fuzz, test)
import Expect
import Html.Attributes exposing (href)
import Testable.Cmd
import Testable
import Testable.TestContext exposing (..)
import Testable.Http


categoriesUrl : String
categoriesUrl =
    "https://opentdb.com/api_category.php"


categoriesPageComponent : Component Msg Model
categoriesPageComponent =
    Component CategoriesPage.init CategoriesPage.update CategoriesPage.view


main =
    describe "What we expect:"
        [ theInitMethodShouldFetchCategories
        , theInitModelShouldBeLoading
        , theInitMethodRequestShouldBeAGETRequestToProperUrl
        , whenTheCategoriesAreLoadingAMessageShouldSaySo
        , whenInitRequestFailTheCategoriesShouldBeOnError
        , whenInitRequestFailThereShouldBeAnError
        , whenInitRequestCompletesTheModelShouldBeUpdated
        , whenInitRequestCompletesTheResultShouldBeDisplayed
        ]
        |> run


theInitMethodShouldFetchCategories : Test
theInitMethodShouldFetchCategories =
    test "The init method should return a `Cmd` (ideally to fetch categories, but this is not covered by this test)." <|
        \() ->
            Expect.notEqual Testable.Cmd.none (Tuple.second CategoriesPage.init)


theInitModelShouldBeLoading : Test
theInitModelShouldBeLoading =
    test "The init model should indicates that the categories are loading" <|
        \() ->
            Expect.equal (Model Loading) (Tuple.first CategoriesPage.init)


theInitMethodRequestShouldBeAGETRequestToProperUrl : Test
theInitMethodRequestShouldBeAGETRequestToProperUrl =
    test ("The request should be a GET request to the url \"" ++ categoriesUrl ++ "\"") <|
        \() ->
            categoriesPageComponent
                |> startForTest
                |> assertHttpRequest (Testable.Http.getRequest categoriesUrl)


whenTheCategoriesAreLoadingAMessageShouldSaySo : Test
whenTheCategoriesAreLoadingAMessageShouldSaySo =
    test ("When the request is loading, the following message should be displayed: \"Loading the categories...\"") <|
        \() ->
            categoriesPageComponent
                |> startForTest
                |> assertText (String.contains "Loading the categories..." >> Expect.true "The message is not displayed")


whenInitRequestFailTheCategoriesShouldBeOnError : Test
whenInitRequestFailTheCategoriesShouldBeOnError =
    test ("When the request fails, the model should keep track of that and there should be no command sent") <|
        \() ->
            let
                model =
                    CategoriesPage.update (OnCategoriesFetched (Err NetworkError)) (Model Loading)
            in
                Expect.equal ( Model OnError, Testable.Cmd.none ) model


whenInitRequestFailThereShouldBeAnError : Test
whenInitRequestFailThereShouldBeAnError =
    test ("When the request fails, the following error message should be displayed: \"An error occurred while loading the categories\"") <|
        \() ->
            categoriesPageComponent
                |> startForTest
                |> update (OnCategoriesFetched (Err NetworkError))
                |> assertText (String.contains "An error occurred while loading the categories" >> Expect.true "The message is not displayed")


whenInitRequestCompletesTheModelShouldBeUpdated : Test
whenInitRequestCompletesTheModelShouldBeUpdated =
    fuzz (Fuzz.string) ("When the request completes, the model should store the string returned and there should be no command sent") <|
        \randomResponse ->
            let
                model =
                    CategoriesPage.update (OnCategoriesFetched (Ok randomResponse)) (Model Loading)
            in
                Expect.equal ( Model (Loaded randomResponse), Testable.Cmd.none ) model


whenInitRequestCompletesTheResultShouldBeDisplayed : Test
whenInitRequestCompletesTheResultShouldBeDisplayed =
    fuzz (Fuzz.string) ("When the request completes, the resulting string should be displayed") <|
        \randomResponse ->
            categoriesPageComponent
                |> startForTest
                |> update (OnCategoriesFetched (Ok randomResponse))
                |> assertText (String.contains randomResponse >> Expect.true "The result of the request is not displayed")
