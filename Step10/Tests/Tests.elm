module Step11.Tests.Tests exposing (suite)

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation exposing (Key)
import Expect exposing (Expectation)
import Fuzz exposing (intRange)
import Random
import Step10.Routing exposing (Category, Model, Msg(..), RemoteData(..), init, update, view)
import Test exposing (Test, concat, fuzz, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (text)
import Test.Runner.Html exposing (defaultConfig, hidePassedTests, viewResults)
import Url exposing (Protocol(..), Url)


type Msg
    = Noop


main : Program () Key Msg
main =
    let
        testsView key =
            Document
                "Tests for step 10"
                [ viewResults (Random.initialSeed 1000 |> defaultConfig |> hidePassedTests) (suite key)
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


fakeUrl : Url
fakeUrl =
    { protocol = Http
    , host = "localhost"
    , port_ = Just 80
    , path = "/"
    , query = Nothing
    , fragment = Just "/home"
    }


suite : Key -> Test
suite key =
    concat
        [ atLoadingCategoriesShouldBeFetched key
        , atLoadingHomepageShouldBeDisplayed key
        , whenGoingToCategoriesLinkCategoriesShouldBeDisplayed key
        , whenGoingToResultLinkResultShouldBeDisplayed key
        , whenGoingToResultLinkResultShouldBeDisplayedWithProperScore key
        ]


atLoadingCategoriesShouldBeFetched : Key -> Test
atLoadingCategoriesShouldBeFetched key =
    test "When loading the page, the categories should be fetched" <|
        \() ->
            Expect.notEqual Cmd.none (init () fakeUrl key |> Tuple.second)


atLoadingHomepageShouldBeDisplayed : Key -> Test
atLoadingHomepageShouldBeDisplayed key =
    test "When loading the page, the homepage should appear" <|
        \() ->
            let
                initialModel =
                    init () fakeUrl key |> Tuple.first
            in
            view initialModel
                |> Query.fromHtml
                |> Expect.all
                    [ Query.has [ text "Quiz Game" ]
                    , Query.has [ text "Play from a category" ]
                    , Query.has [ text "Show me the results page" ]
                    ]


whenGoingToCategoriesLinkCategoriesShouldBeDisplayed : Key -> Test
whenGoingToCategoriesLinkCategoriesShouldBeDisplayed key =
    test "When we go on the categories link (/#categories), the categories page should be displayed" <|
        \() ->
            let
                initialModel =
                    init () fakeUrl key
                        |> Tuple.first

                newLocation =
                    { fakeUrl | fragment = Just "categories" }

                updatedView =
                    update (OnUrlChange newLocation) initialModel
                        |> Tuple.first
                        |> view
            in
            updatedView
                |> Query.fromHtml
                |> Expect.all
                    [ Query.has [ text "Categories are loading" ]
                    , Query.hasNot [ text "Play from a category" ]
                    ]


whenGoingToResultLinkResultShouldBeDisplayed : Key -> Test
whenGoingToResultLinkResultShouldBeDisplayed key =
    test "When we click on the second link, the result page should be displayed" <|
        \() ->
            let
                initialModel =
                    init () fakeUrl key
                        |> Tuple.first

                newLocation =
                    { fakeUrl | fragment = Just "result/3" }

                updatedView =
                    update (OnUrlChange newLocation) initialModel
                        |> Tuple.first
                        |> view
            in
            updatedView
                |> Query.fromHtml
                |> Expect.all
                    [ Query.has [ text "Your score" ]
                    , Query.hasNot [ text "Play from a category" ]
                    ]


whenGoingToResultLinkResultShouldBeDisplayedWithProperScore : Key -> Test
whenGoingToResultLinkResultShouldBeDisplayedWithProperScore key =
    fuzz (intRange 0 5) "When we click on the second link, the result page should be displayed with the proper result" <|
        \score ->
            let
                initialModel =
                    init () fakeUrl key
                        |> Tuple.first

                newLocation =
                    { fakeUrl | fragment = Just <| "result/" ++ String.fromInt score }

                updatedView =
                    update (OnUrlChange newLocation) initialModel
                        |> Tuple.first
                        |> view
            in
            updatedView
                |> Query.fromHtml
                |> Query.has [ String.fromInt score ++ " / 5" |> text ]
