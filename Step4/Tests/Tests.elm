module Step4.Tests.Tests exposing (..)

import Fuzz exposing (intRange)
import Html exposing (div)
import Step4.ResultPage exposing (resultPage)
import Test.Runner.Html exposing (run)
import Test exposing (Test, describe, fuzz, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (tag, text)


main =
    describe "What we expect:"
        [ aParagraphShouldNowAppear
        , congratsMessageWhenGoodScore
        , supportMessageWhenBadScore
        ]
        |> run


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
