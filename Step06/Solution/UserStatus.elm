module Step06.Solution.UserStatus exposing (initialModel, main, update, view)

import Browser
import Html exposing (Html, div, input, label, p, text)
import Html.Attributes exposing (class, for, id, name, type_)
import Html.Events exposing (onClick)


main =
    Browser.sandbox { init = initialModel, view = view, update = update }


type UserStatus
    = Underage
    | Adult
    | Unknown


type Msg
    = UserStatusSelected UserStatus


initialModel : UserStatus
initialModel =
    Unknown


view : UserStatus -> Html Msg
view userStatus =
    div []
        [ div [ class "jumbotron" ]
            [ userStatusForm
            , p [] [ statusMessage userStatus ]
            ]
        ]


userStatusForm : Html Msg
userStatusForm =
    div [ class "mb-3" ]
        [ input
            [ id "underage"
            , name "status"
            , type_ "radio"
            , onClick (UserStatusSelected Underage)
            ]
            [ text "I'm underage" ]
        , label [ class "mr-3", for "underage" ] [ text "I'm underage" ]
        , input
            [ id "adult"
            , name "status"
            , type_ "radio"
            , onClick (UserStatusSelected Adult)
            ]
            [ text "I'm an adult!" ]
        , label [ for "adult" ] [ text "I'm an adult" ]
        ]


statusMessage : UserStatus -> Html Msg
statusMessage userStatus =
    case userStatus of
        Underage ->
            text "You are underage"

        Adult ->
            text "You are an adult"

        Unknown ->
            text ""


update : Msg -> UserStatus -> UserStatus
update message userStatus =
    case message of
        UserStatusSelected newUserStatus ->
            -- We've changed this to return the new user status
            newUserStatus
