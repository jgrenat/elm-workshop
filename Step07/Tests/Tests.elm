module Step07.Tests.Tests exposing (..)

import Html exposing (div)
import Step07.UserStatus exposing (view, update, initialModel)
import Test.Runner.Html exposing (run)
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, tag, text)
import Test.Html.Event as Event
import Expect
import Html.Attributes exposing (href, type_)


main =
    describe "What we expect:"
        [ atFirstThereShouldBeNoMessage
        , whenFirstRadioButtonIsClickedUserShouldBeUnderage
        , whenSecondRadioButtonIsClickedUserShouldBeAdult
        ]
        |> run


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
