module Step10.Tests.Tests exposing (suite)

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation exposing (Key)
import Expect exposing (Expectation)
import Random
import Step10.Routing exposing (Category, Model, Msg(..), RemoteData(..), init, update, view)
import Test exposing (Test, concat, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (text)
import Test.Runner.Html exposing (defaultConfig, hidePassedTests, viewResults)
import Url exposing (Protocol(..), Url)
import Utils.Utils exposing (testStyles)


type Msg
    = Noop


main : Program () Key Msg
main =
    let
        testsView key =
            Document
                "Tests for step 10"
                [ testStyles
                , viewResults (Random.initialSeed 1000 |> defaultConfig |> hidePassedTests) (suite key)
                ]

        init _ _ key =
            ( key, Cmd.none )

        update msg key =
            ( key, Cmd.none )
    in
    Browser.application
        { init = init
        , update = update
        , view = testsView
        , subscriptions = always Sub.none
        , onUrlRequest = always Noop
        , onUrlChange = always Noop
        }


fakeHomeUrl : Url
fakeHomeUrl =
    { protocol = Http
    , host = "localhost"
    , port_ = Just 80
    , path = "/"
    , query = Nothing
    , fragment = Nothing
    }


fakeCategoriesUrl : Url
fakeCategoriesUrl =
    { fakeHomeUrl | fragment = Just "categories" }


suite : Key -> Test
suite key =
    concat
        [ atLoadingHomepageShouldBeDisplayed key
        , atLoadingCategoriesPageShouldBeDisplayed key
        , whenClickingToCategoriesLinkCategoriesShouldBeDisplayed key
        , atLoadingCategoriesShouldNotBeFetched key
        , atLoadingCategoriesShouldBeFetched key
        ]


atLoadingHomepageShouldBeDisplayed : Key -> Test
atLoadingHomepageShouldBeDisplayed key =
    test "When loading the page with home URL, the homepage should appear" <|
        \() ->
            let
                initialModel =
                    init () fakeHomeUrl key |> Tuple.first
            in
            view initialModel
                |> Query.fromHtml
                |> Expect.all
                    [ Query.has [ text "Quiz Game" ]
                    , Query.has [ text "Play from a category" ]
                    ]


atLoadingCategoriesPageShouldBeDisplayed : Key -> Test
atLoadingCategoriesPageShouldBeDisplayed key =
    test "When loading the page with categories URL, the categories page should appear" <|
        \() ->
            let
                initialModel =
                    init () fakeCategoriesUrl key |> Tuple.first
            in
            view initialModel
                |> Query.fromHtml
                |> Expect.all
                    [ Query.has [ text "Categories are loading" ]
                    , Query.hasNot [ text "Play from a category" ]
                    ]


whenClickingToCategoriesLinkCategoriesShouldBeDisplayed : Key -> Test
whenClickingToCategoriesLinkCategoriesShouldBeDisplayed key =
    test "When we go on the categories link (/#categories), the categories page should be displayed" <|
        \() ->
            let
                initialModel =
                    init () fakeHomeUrl key
                        |> Tuple.first

                updatedView =
                    update (OnUrlChange fakeCategoriesUrl) initialModel
                        |> Tuple.first
                        |> view
            in
            updatedView
                |> Query.fromHtml
                |> Expect.all
                    [ Query.has [ text "Categories are loading" ]
                    , Query.hasNot [ text "Play from a category" ]
                    ]


atLoadingCategoriesShouldNotBeFetched : Key -> Test
atLoadingCategoriesShouldNotBeFetched key =
    test "When loading the page with the home URL, the categories should not be fetched" <|
        \() ->
            Expect.equal Cmd.none (init () fakeHomeUrl key |> Tuple.second)


atLoadingCategoriesShouldBeFetched : Key -> Test
atLoadingCategoriesShouldBeFetched key =
    test "When loading the page with the categories URL, the categories should be fetched" <|
        \() ->
            Expect.notEqual Cmd.none (init () fakeCategoriesUrl key |> Tuple.second)
