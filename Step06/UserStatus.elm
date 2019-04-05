module Step06.UserStatus exposing (initialModel, main, update, view)

import Browser
import Html exposing (Html, div, input, label, p, text)
import Html.Attributes exposing (class, for, id, name, type_)
import Html.Events exposing (onClick)
import Utils.Utils exposing (styles, testsIframe)


{-| This line creates a program with everything it needs (see the README)
You don't need to modify it.
-}
main =
    Browser.sandbox { init = initialModel, view = view, update = update }


{-| Modify this union type to fit our needs.
It should contain three values: NotSpecified, UnderAge and Adult.
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


{-| Don't modify this function, it displays everything you need and also displays the tests.
-}
view : UserStatus -> Html Msg
view userStatus =
    div []
        [ div [ class "jumbotron" ]
            [ userStatusForm
            , p [] [ statusMessage userStatus ]
            ]
        , displayTestsAndStyle
        ]


{-| You will need to modify the messages sent by those inputs.
You can see how `onClick` is used to send a message `UserStatusSelected` with a value of `ModifyThisType`.
Once you have changed the UserStatus type, you can change the messages here
-}
userStatusForm : Html Msg
userStatusForm =
    div [ class "mb-3" ]
        [ input
            [ id "underage"
            , name "status"
            , type_ "radio"
            , onClick (UserStatusSelected ModifyThisType)
            ]
            [ text "I'm underage" ]
        , label [ class "mr-3", for "underage" ] [ text "I'm underage" ]
        , input
            [ id "adult"
            , name "status"
            , type_ "radio"
            , onClick (UserStatusSelected ModifyThisType)
            ]
            [ text "I'm an adult!" ]
        , label [ for "adult" ] [ text "I'm an adult" ]
        ]


{-| Customize this message according to the user status. If the status is not specified, just return an empty text.
-}
statusMessage : UserStatus -> Html Msg
statusMessage userStatus =
    case userStatus of
        ModifyThisType ->
            text "Personalize the message according to the user status"


{-| Update the model according to the message received
-}
update : Msg -> UserStatus -> UserStatus
update message userStatus =
    case message of
        UserStatusSelected newUserStatus ->
            userStatus



-----------------------------------------------------------------------------------------
-- You don't need to worry about the code below, this function only displays the tests --
-----------------------------------------------------------------------------------------


displayTestsAndStyle : Html Msg
displayTestsAndStyle =
    div [] [ styles, testsIframe ]
