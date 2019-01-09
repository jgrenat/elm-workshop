module Counter exposing (Msg(..), main, update, view)

import Browser
import Html exposing (Html, button, div, span, text)
import Html.Events exposing (onClick)


main =
    Browser.sandbox { init = 0, view = view, update = update }


type Msg
    = Increment
    | Decrement


update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1


view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , span [] [ text (String.fromInt model) ]
        , button [ onClick Increment ] [ text "+" ]
        ]
