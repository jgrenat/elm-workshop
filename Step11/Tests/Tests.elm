module Step11.Tests.Tests exposing (suite)

import Expect exposing (Expectation)
import Fuzz
import Html exposing (Html, div)
import Random
import Step11.ParsingRoute exposing (Page(..), RemoteData(..), parseUrlToPageAndCommand)
import Test exposing (Test, concat, fuzz, test)
import Test.Runner.Html exposing (defaultConfig, hidePassedTests, viewResults)
import Url exposing (Protocol(..), Url)
import Utils.Utils exposing (testStyles)


main : Html msg
main =
    div []
        [ testStyles
        , viewResults (Random.initialSeed 1000 |> defaultConfig |> hidePassedTests) suite
        ]


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
    { fakeHomeUrl | path = "categories" }


fakeResultUrl : Int -> Url
fakeResultUrl score =
    { fakeHomeUrl | path = "result/" ++ String.fromInt score }


suite : Test
suite =
    concat
        [ shouldProperlyParseHomePage
        , shouldProperlyParseCategoriesPage
        , shouldProperlyParseResultPage
        ]


shouldProperlyParseHomePage : Test
shouldProperlyParseHomePage =
    test "Should parse home URL into HomePage with no command" <|
        \() ->
            Expect.equal ( HomePage, Cmd.none ) (parseUrlToPageAndCommand fakeHomeUrl)


shouldProperlyParseCategoriesPage : Test
shouldProperlyParseCategoriesPage =
    test "Should parse categories URL into CategoriesPage with loading categories and with a command" <|
        \() ->
            Expect.all
                [ Tuple.first >> Expect.equal (CategoriesPage Loading)
                , Tuple.second >> Expect.notEqual Cmd.none
                ]
                (parseUrlToPageAndCommand fakeCategoriesUrl)


shouldProperlyParseResultPage : Test
shouldProperlyParseResultPage =
    fuzz (Fuzz.intRange 0 5) "Should parse result URL into ResultPage with given score and with no command" <|
        \score ->
            Expect.equal ( ResultPage score, Cmd.none ) (parseUrlToPageAndCommand (fakeResultUrl score))
