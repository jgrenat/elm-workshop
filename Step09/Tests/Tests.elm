module Step09.Tests.Tests exposing (main)

import Expect exposing (Expectation)
import Fuzz
import Html exposing (Html)
import Http exposing (Error(..))
import Json.Decode as Decode
import Json.Encode as Encode
import Random
import Step09.CategoriesPage as CategoriesPage exposing (Category, Model, Msg(..), RemoteData(..), getCategoriesDecoder)
import Test exposing (Test, concat, fuzz, test)
import Test.Html.Selector as Selector exposing (Selector)
import Test.Runner.Html exposing (defaultConfig, hidePassedTests, viewResults)
import TestContext exposing (SimulatedEffect(..), TestContext, createWithSimulatedEffects, expectModel, expectViewHas, simulateLastEffect, update)


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
    viewResults (Random.initialSeed 1000 |> defaultConfig |> hidePassedTests) suite


suite : Test
suite =
    concat
        [ theInitMethodShouldFetchCategories
        , theInitModelShouldBeLoading
        , whenTheCategoriesAreLoadingAMessageShouldSaySo
        , whenInitRequestFailTheCategoriesShouldBeOnError
        , whenInitRequestFailThereShouldBeAnError
        , theDecoderShouldProperlyDecodeCategoriesList
        , whenInitRequestCompletesTheModelShouldBeUpdated
        , whenInitRequestCompletesTheResultsShouldBeDisplayed
        ]


theInitMethodShouldFetchCategories : Test
theInitMethodShouldFetchCategories =
    test "The init method should return a `Cmd` (ideally to fetch categories, but this is not covered by this test)." <|
        \() ->
            Expect.false "The init method should return a command" (Tuple.second CategoriesPage.init == Cmd.none)


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


theDecoderShouldProperlyDecodeCategoriesList : Test
theDecoderShouldProperlyDecodeCategoriesList =
    fuzz randomCategoriesFuzz "The decoder should properly decode the categories list" <|
        \randomCategories ->
            let
                encodedCategories =
                    encodeCategoriesList randomCategories
            in
            Decode.decodeValue getCategoriesDecoder encodedCategories
                |> Expect.equal (Ok randomCategories)


whenInitRequestCompletesTheModelShouldBeUpdated : Test
whenInitRequestCompletesTheModelShouldBeUpdated =
    fuzz randomCategoriesFuzz "When the request completes, the model should store the decoded categories" <|
        \randomCategories ->
            let
                expectedModel =
                    Model (Loaded randomCategories)
            in
            categoriesPageProgram
                |> simulateLastEffect (\_ -> randomCategories |> Ok |> OnCategoriesFetched |> List.singleton |> Ok)
                |> expectModel (Expect.equal expectedModel)


whenInitRequestCompletesTheResultsShouldBeDisplayed : Test
whenInitRequestCompletesTheResultsShouldBeDisplayed =
    fuzz randomCategoriesFuzz "When the request completes, the categories should be displayed" <|
        \randomCategories ->
            let
                allCategoriesNamesArePresent : List Selector
                allCategoriesNamesArePresent =
                    randomCategories
                        |> List.map .name
                        |> List.map Selector.text
                        |> List.map List.singleton
                        |> List.map Selector.containing
                        |> Debug.log "test"
            in
            case randomCategories of
                -- Not asserting empty array because findAll makes it fail
                [] ->
                    Expect.pass

                _ ->
                    categoriesPageProgram
                        |> simulateLastEffect (\_ -> randomCategories |> Ok |> OnCategoriesFetched |> List.singleton |> Ok)
                        |> expectViewHas allCategoriesNamesArePresent


randomCategoriesFuzz : Fuzz.Fuzzer (List Category)
randomCategoriesFuzz =
    Fuzz.map2 Category Fuzz.int Fuzz.string
        |> Fuzz.list


encodeCategoriesList : List Category -> Encode.Value
encodeCategoriesList categories =
    categories
        |> Encode.list
            (\category ->
                Encode.object
                    [ ( "id", Encode.int category.id )
                    , ( "name", Encode.string category.name )
                    ]
            )
        |> (\encodedCategories -> Encode.object [ ( "trivia_categories", encodedCategories ) ])
