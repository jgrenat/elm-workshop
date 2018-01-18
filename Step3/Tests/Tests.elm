module Step3.Tests.Tests exposing (..)

import Fuzz exposing (intRange)
import Html exposing (div)
import Step3.ResultPage exposing (resultPage)
import Test.Runner.Html exposing (run)
import Test exposing (Test, describe, fuzz, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, class, classes, tag, text)
import Expect
import Html.Attributes exposing (href)


main =
    describe "What we expect:"
        [ divHasProperClassTest
        , titleIsPresent
        , scoreIsPresent
        , replayLinkIsPresent
        , replayLinkShouldHaveProperClasses
        , replayLinkGoToHome
        ]
        |> run


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
                |> Query.has [ text (toString randomScore) ]


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
