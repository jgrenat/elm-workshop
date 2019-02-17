module Step06.Tests.Tests exposing (main)

import Expect
import Html exposing (Html)
import Html.Attributes exposing (type_)
import Random
import Step06.UserStatus exposing (initialModel, update, view)
import Test exposing (Test, concat, test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, text)
import Test.Runner.Html exposing (defaultConfig, viewResults)


main : Html a
main =
    viewResults (Random.initialSeed 1000 |> defaultConfig) suite


suite : Test
suite =
    concat
        [ atFirstThereShouldBeNoMessage
        , whenFirstRadioButtonIsClickedUserShouldBeUnderage
        , whenSecondRadioButtonIsClickedUserShouldBeAdult
        ]


atFirstThereShouldBeNoMessage : Test
atFirstThereShouldBeNoMessage =
    test "At first there should be no message displayed" <|
        \() ->
            Expect.all
                [ Query.hasNot [ text "You are underage" ]
                , Query.hasNot [ text "You are an adult" ]
                ]
                (view initialModel |> Query.fromHtml)


whenFirstRadioButtonIsClickedUserShouldBeUnderage : Test
whenFirstRadioButtonIsClickedUserShouldBeUnderage =
    test "When we click on the first radio button, a message \"You are underage\" should appear" <|
        \() ->
            let
                messageTriggered =
                    view initialModel
                        |> Query.fromHtml
                        |> Query.findAll [ attribute (type_ "radio") ]
                        |> Query.first
                        |> Event.simulate Event.click
                        |> Event.toResult

                updatedModel =
                    messageTriggered
                        |> Result.map (\msg -> update msg initialModel)

                updatedView =
                    updatedModel
                        |> Result.map (\model -> view model)
                        |> Result.map Query.fromHtml
            in
            Expect.all
                [ \result ->
                    result
                        |> Result.map (Query.has [ text "You are underage" ])
                        |> Result.withDefault (Expect.fail "\"You are underage\" should be present")
                , \result ->
                    Result.map (Query.hasNot [ text "You are an adult" ]) result
                        |> Result.withDefault (Expect.fail "\"You are an adult\" should not be present")
                ]
                updatedView


whenSecondRadioButtonIsClickedUserShouldBeAdult : Test
whenSecondRadioButtonIsClickedUserShouldBeAdult =
    test "When we click on the second radio button, a message \"You are an adult\" should appear" <|
        \() ->
            let
                messageTriggered =
                    view initialModel
                        |> Query.fromHtml
                        |> Query.findAll [ attribute (type_ "radio") ]
                        |> Query.index 1
                        |> Event.simulate Event.click
                        |> Event.toResult

                updatedModel =
                    messageTriggered
                        |> Result.map (\msg -> update msg initialModel)

                updatedView =
                    updatedModel
                        |> Result.map (\model -> view model)
                        |> Result.map Query.fromHtml
            in
            Expect.all
                [ \result ->
                    Result.map (Query.hasNot [ text "You are underage" ]) result
                        |> Result.withDefault (Expect.fail "\"You are underage\" should not be present")
                , \result ->
                    Result.map (Query.has [ text "You are an adult" ]) result
                        |> Result.withDefault (Expect.fail "\"You are an adult\" should be present")
                ]
                updatedView
