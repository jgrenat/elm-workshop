module Step10.Tests.Tests exposing (..)

import Fuzz
import Http exposing (Error(NetworkError))
import Step10.CategoriesPage as CategoriesPage exposing (Category, Model, Msg(..), RemoteData(..))
import Test.Runner.Html exposing (run)
import Test exposing (Test, describe, fuzz, test)
import Expect exposing (Expectation)
import Html.Attributes exposing (href)
import Testable.Cmd
import Testable
import Testable.TestContext exposing (..)
import Testable.Http
import Json.Encode as Encode
import Testable.Html.Selectors exposing (tag)


categoriesUrl : String
categoriesUrl =
    "https://opentdb.com/api_category.php"


expectedRequest =
    Testable.Http.getRequest categoriesUrl


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
        , whenInitRequestCompletesTheResultsShouldBeDisplayed
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
                |> assertHttpRequest expectedRequest


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
    fuzz randomCategoriesFuzz ("When the request completes, the model should store the decoded categories") <|
        \randomCategories ->
            let
                categoriesJson =
                    Encode.encode 0 (categoriesListEncoder randomCategories)

                expectedModel =
                    Model (Loaded randomCategories)
            in
                categoriesPageComponent
                    |> startForTest
                    |> resolveHttpRequest expectedRequest (Testable.Http.ok categoriesJson)
                    |> assertCurrentModel expectedModel


whenInitRequestCompletesTheResultsShouldBeDisplayed : Test
whenInitRequestCompletesTheResultsShouldBeDisplayed =
    fuzz randomCategoriesFuzz ("When the request completes, the categories should be displayed") <|
        \randomCategories ->
            let
                categoriesJson =
                    Encode.encode 0 (categoriesListEncoder randomCategories)

                allCategoriesNamesArePresent : List Category -> String -> Expectation
                allCategoriesNamesArePresent categories =
                    List.map
                        (\category ->
                            String.contains category.name
                                >> Expect.true ("Category \"" ++ category.name ++ "\" should be present in the HTML")
                        )
                        categories
                        |> (::) (\content -> Expect.pass)
                        |> Expect.all
            in
                case randomCategories of
                    -- Not asserting empty array because findAll makes it fail
                    [] ->
                        Expect.pass

                    _ ->
                        categoriesPageComponent
                            |> startForTest
                            |> resolveHttpRequest expectedRequest (Testable.Http.ok categoriesJson)
                            |> assertText (allCategoriesNamesArePresent randomCategories)


randomCategoriesFuzz : Fuzz.Fuzzer (List Category)
randomCategoriesFuzz =
    Fuzz.map2 Category Fuzz.int Fuzz.string
        |> Fuzz.list


categoriesListEncoder : List Category -> Encode.Value
categoriesListEncoder categories =
    categories
        |> List.map
            (\category ->
                Encode.object
                    [ ( "id", Encode.int category.id )
                    , ( "name", Encode.string category.name )
                    ]
            )
        |> Encode.list
        |> \categories -> Encode.object [ ( "trivia_categories", categories ) ]
