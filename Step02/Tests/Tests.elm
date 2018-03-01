module Step02.Tests.Tests exposing (..)

import Fuzz exposing (intRange)
import Html exposing (div)
import Step02.HomePage exposing (homePage)
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
        , twoLinksAreDisplayed
        , theTwoLinksHaveProperClasses
        , aLinkToGameIsPresent
        , theGameLinkHasProperText
        , aLinkToCategoriesIsPresent
        , theCategoriesLinkHasProperText
        ]
        |> run


divHasProperClassTest : Test
divHasProperClassTest =
    test "The div should have a class 'gameOptions'" <|
        \() ->
            div [] [ homePage ]
                |> Query.fromHtml
                |> Query.find [ tag "div" ]
                |> Query.has [ class "gameOptions" ]


titleIsPresent : Test
titleIsPresent =
    test "There should be a h1 tag containing the text 'Quiz Game'" <|
        \() ->
            homePage
                |> Query.fromHtml
                |> Query.find [ tag "h1" ]
                |> Query.has [ text "Quiz Game" ]


twoLinksAreDisplayed : Test
twoLinksAreDisplayed =
    test "Two links are displayed" <|
        \() ->
            homePage
                |> Query.fromHtml
                |> Query.findAll [ tag "a" ]
                |> Query.count (Expect.equal 2)


theTwoLinksHaveProperClasses : Test
theTwoLinksHaveProperClasses =
    test "The two links have the classes 'btn btn-primary'" <|
        \() ->
            homePage
                |> Query.fromHtml
                |> Query.findAll [ tag "a" ]
                |> Query.each (Query.has [ classes [ "btn", "btn-primary" ] ])


aLinkToGameIsPresent : Test
aLinkToGameIsPresent =
    test "The first link goes to '#game'" <|
        \() ->
            homePage
                |> Query.fromHtml
                |> Query.findAll [ tag "a" ]
                |> Query.first
                |> Query.has [ attribute (href "#game") ]


theGameLinkHasProperText : Test
theGameLinkHasProperText =
    test "The first link has text 'Play random questions'" <|
        \() ->
            homePage
                |> Query.fromHtml
                |> Query.findAll [ tag "a" ]
                |> Query.first
                |> Query.has [ text "Play random questions" ]


aLinkToCategoriesIsPresent : Test
aLinkToCategoriesIsPresent =
    test "The second link goes to '#categories'" <|
        \() ->
            homePage
                |> Query.fromHtml
                |> Query.findAll [ tag "a" ]
                |> Query.index 1
                |> Query.has [ attribute (href "#categories") ]


theCategoriesLinkHasProperText : Test
theCategoriesLinkHasProperText =
    test "The second link has text 'Play from a category'" <|
        \() ->
            homePage
                |> Query.fromHtml
                |> Query.findAll [ tag "a" ]
                |> Query.index 1
                |> Query.has [ text "Play from a category" ]
