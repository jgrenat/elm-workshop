module Step02.Tests.Tests exposing (main)

import Fuzz exposing (intRange)
import Html exposing (Html, div)
import Html.Attributes exposing (href)
import Random
import Step02.ResultPage exposing (resultPage)
import Test exposing (Test, concat, fuzz, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, class, classes, tag, text)
import Test.Runner.Html exposing (defaultConfig, viewResults)


main : Html a
main =
    viewResults (Random.initialSeed 1000 |> defaultConfig) suite


suite : Test
suite =
    concat
        [ divHasProperClassTest
        , titleIsPresent
        , scoreIsPresent
        , replayLinkIsPresent
        , replayLinkShouldHaveProperClasses
        , replayLinkGoToHome
        ]


divHasProperClassTest : Test
divHasProperClassTest =
    test "The div should have a class 'score'" <|
        \() ->
            div [] [ resultPage 3 ]
                |> Query.fromHtml
                |> Query.find [ tag "div" ]
                |> Query.has [ class "score" ]


titleIsPresent : Test
titleIsPresent =
    test "'Your score' is displayed into a h1 tag" <|
        \() ->
            resultPage 3
                |> Query.fromHtml
                |> Query.find [ tag "h1" ]
                |> Query.has [ text "Your score" ]


scoreIsPresent : Test
scoreIsPresent =
    fuzz (intRange 0 5) "The proper score is displayed inside the h1 tag" <|
        \randomScore ->
            resultPage randomScore
                |> Query.fromHtml
                |> Query.find [ tag "h1" ]
                |> Query.has [ text (String.fromInt randomScore) ]


replayLinkIsPresent : Test
replayLinkIsPresent =
    test "There is a link with the text 'Replay'" <|
        \() ->
            resultPage 3
                |> Query.fromHtml
                |> Query.find [ tag "a" ]
                |> Query.has [ text "Replay" ]


replayLinkShouldHaveProperClasses : Test
replayLinkShouldHaveProperClasses =
    test "The replay link should have classes 'btn btn-primary'" <|
        \() ->
            resultPage 3
                |> Query.fromHtml
                |> Query.find [ tag "a" ]
                |> Query.has [ classes [ "btn", "btn-primary" ] ]


replayLinkGoToHome : Test
replayLinkGoToHome =
    test "The replay link should go to '#'" <|
        \() ->
            resultPage 3
                |> Query.fromHtml
                |> Query.find [ tag "a" ]
                |> Query.has [ attribute (href "#") ]
