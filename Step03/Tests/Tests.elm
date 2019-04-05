module Step03.Tests.Tests exposing (main)

import Fuzz exposing (intRange)
import Html exposing (Html)
import Random
import Step03.ResultPage exposing (resultPage)
import Test exposing (Test, concat, fuzz, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (tag, text)
import Test.Runner.Html exposing (defaultConfig, viewResults)


main : Html a
main =
    viewResults (Random.initialSeed 1000 |> defaultConfig) suite


suite : Test
suite =
    concat
        [ aParagraphShouldNowAppear
        , congratsMessageWhenGoodScore
        , supportMessageWhenBadScore
        ]


aParagraphShouldNowAppear : Test
aParagraphShouldNowAppear =
    test "There should be a new paragraph in the page" <|
        \() ->
            resultPage 3
                |> Query.fromHtml
                |> Query.has [ tag "p" ]


congratsMessageWhenGoodScore : Test
congratsMessageWhenGoodScore =
    fuzz (intRange 0 3) "With a score between 0 and 3, the paragraph should contain: \"Keep going, I'm sure you can do better!\"" <|
        \score ->
            resultPage score
                |> Query.fromHtml
                |> Query.find [ tag "p" ]
                |> Query.has [ text "Keep going, I'm sure you can do better!" ]


supportMessageWhenBadScore : Test
supportMessageWhenBadScore =
    fuzz (intRange 4 5) "With a score between 4 and 5, the paragraph should contain: \"Congrats, this is really good!\"" <|
        \score ->
            resultPage score
                |> Query.fromHtml
                |> Query.find [ tag "p" ]
                |> Query.has [ text "Congrats, this is really good!" ]
