module Step14.Tests.Tests exposing (main)

import Browser exposing (Document)
import Browser.Navigation exposing (Key)
import Expect exposing (Expectation)
import Fuzz exposing (intRange)
import Random
import Step14.Main exposing (Msg(..), init, update, view)
import Test exposing (Test, concat, fuzz, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (text)
import Test.Runner.Html exposing (defaultConfig, hidePassedTests, viewResults)
import Url exposing (Protocol(..), Url)
import Utils.Utils exposing (testStyles)


main : Program () Key ()
main =
    let
        testsView key =
            Document
                "Tests for step 14"
                [ testStyles
                , viewResults (Random.initialSeed 1000 |> defaultConfig |> hidePassedTests) (testsSuite key)
                ]

        init _ _ key =
            ( key, Cmd.none )

        update _ key =
            ( key, Cmd.none )
    in
    Browser.application
        { init = init
        , update = update
        , view = testsView
        , subscriptions = always Sub.none
        , onUrlRequest = always ()
        , onUrlChange = always ()
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


fakeResultUrl : Int -> Url
fakeResultUrl score =
    { fakeHomeUrl | fragment = Just ("result/" ++ String.fromInt score) }


fakeGameUrl : Url
fakeGameUrl =
    { fakeHomeUrl | fragment = Just "game" }


testsSuite : Key -> Test
testsSuite key =
    concat
        [ whenGoingToGamePathGamePageShouldBeDisplayed key
        , whenGoingToGamePathQuestionsShouldBeFetched key
        , atBasePathHomepageShouldBeDisplayed key
        , atLoadingCategoriesShouldNotBeFetched key
        , categoriesShouldBeLoaded key
        , whenGoingToCategoriesPathCategoriesShouldBeDisplayed key
        , whenGoingToResultPathResultShouldBeDisplayed key
        , whenGoingToResultPathResultShouldBeDisplayedWithProperScore key
        ]


atBasePathHomepageShouldBeDisplayed : Key -> Test
atBasePathHomepageShouldBeDisplayed key =
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
                    , Query.has [ text "Play random questions" ]
                    , Query.has [ text "Play from a category" ]
                    ]


atLoadingCategoriesShouldNotBeFetched : Key -> Test
atLoadingCategoriesShouldNotBeFetched key =
    test "When loading the page with home URL, nothing should be fetched" <|
        \() ->
            Expect.equal Cmd.none (init () fakeHomeUrl key |> Tuple.second)


categoriesShouldBeLoaded : Key -> Test
categoriesShouldBeLoaded key =
    test "When loading the page with categories URL, categories should be fetched" <|
        \() ->
            Expect.notEqual Cmd.none (init () fakeCategoriesUrl key |> Tuple.second)


whenGoingToCategoriesPathCategoriesShouldBeDisplayed : Key -> Test
whenGoingToCategoriesPathCategoriesShouldBeDisplayed key =
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


whenGoingToResultPathResultShouldBeDisplayed : Key -> Test
whenGoingToResultPathResultShouldBeDisplayed key =
    test "When we go to the path \"#result/{score}\", the result page should be displayed" <|
        \() ->
            let
                initialModel =
                    init () fakeHomeUrl key
                        |> Tuple.first

                updatedView =
                    update (OnUrlChange (fakeResultUrl 5)) initialModel
                        |> Tuple.first
                        |> view
            in
            updatedView
                |> Query.fromHtml
                |> Expect.all
                    [ Query.has [ text "Your score" ]
                    , Query.hasNot [ text "Play from a category" ]
                    ]


whenGoingToResultPathResultShouldBeDisplayedWithProperScore : Key -> Test
whenGoingToResultPathResultShouldBeDisplayedWithProperScore key =
    fuzz (intRange 0 5) "When we go to the path \"#result/{score}\", the result page should be displayed with the proper result" <|
        \score ->
            let
                initialModel =
                    init () fakeHomeUrl key
                        |> Tuple.first

                updatedView =
                    update (OnUrlChange (fakeResultUrl score)) initialModel
                        |> Tuple.first
                        |> view
            in
            updatedView
                |> Query.fromHtml
                |> Query.has [ String.fromInt score ++ " / 5" |> text ]


whenGoingToGamePathGamePageShouldBeDisplayed : Key -> Test
whenGoingToGamePathGamePageShouldBeDisplayed key =
    test "When we go to the path \"#game\", the game page should be displayed" <|
        \() ->
            let
                initialModel =
                    init () fakeHomeUrl key
                        |> Tuple.first

                updatedView =
                    update (OnUrlChange fakeGameUrl) initialModel
                        |> Tuple.first
                        |> view
            in
            updatedView
                |> Query.fromHtml
                |> Query.has [ text "Loading the questions" ]


whenGoingToGamePathQuestionsShouldBeFetched : Key -> Test
whenGoingToGamePathQuestionsShouldBeFetched key =
    test "When we go to the path \"#game\", questions should be fetched" <|
        \() ->
            let
                initialModel =
                    init () fakeHomeUrl key
                        |> Tuple.first

                updatedCommand =
                    update (OnUrlChange fakeGameUrl) initialModel
                        |> Tuple.second
            in
            Expect.notEqual Cmd.none updatedCommand
