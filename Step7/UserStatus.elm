module Step7.UserStatus exposing (..)

import Html exposing (Html, a, beginnerProgram, div, h1, iframe, input, li, p, text, ul)
import Html.Attributes exposing (class, href, selected, src, style, type_)
import Html.Events exposing (onClick)


{-| This line creates a program with everything it needs (see the README)
-}
main =
    beginnerProgram { model = initialModel, view = view, update = update }


{-| Modify this union type to fit our needs.
It should contain three values: NotSpecified, UnderAge et Adult.
-}
type UserStatus
    = ModifyThisType


{-| Don't modify this union type, it already contains the only message we need.
-}
type Msg
    = UserStatusSelected UserStatus


{-| Once the type UserStatus is fixed, you'll be able to initialize properly the model here.
-}
initialModel : UserStatus
initialModel =
    ModifyThisType


{-| Don't modify this function, it displays everything you need, and it also displays the tests.
-}
view : UserStatus -> Html Msg
view userStatus =
    div []
        [ div [ class "jumbotron" ]
            [ userStatusForm
            , p [] [ message userStatus ]
            ]
        , displayTests
        ]


{-| You will need to modify the messages sent by those inputs.
You can see how `onClick` is used to send a message `UserStatusSelected` with a value of `ModifyThisType`.
Once you have changed the UserStatus type, you can change the messages here
-}
userStatusForm : UserStatus -> Html Msg
userStatusForm userStatus =
    div [ class "mb-3" ]
        [ input [ type_ "radio", onClick (UserStatusSelected ModifyThisType) ] [ text "I'm underage" ]
        , input [ type_ "radio", onClick (UserStatusSelected ModifyThisType) ] [ text "I'm an adult!" ]
        ]


{-| Customize this message according to the user status. If the status is not specified, just return an empty text.
-}
message : UserStatus -> Html Msg
message userStatus =
    case userStatus of
        ModifyThisType ->
            text "Personnalize the message according to the user status"


{-| Update the model according to the Msg received.
A case...of will be useful here!
-}
update : Msg -> UserStatus -> UserStatus
update userStatus =
    userStatus



-----------------------------------------------------------------------------------------
-- You don't need to worry about the code below, this function only displays the tests --
-----------------------------------------------------------------------------------------


displayTests : Html Msg
displayTests =
    iframe [ src "./Tests/index.html", class "mt-2 w-75 mx-auto d-block", style [ ( "height", "500px" ) ] ] []
