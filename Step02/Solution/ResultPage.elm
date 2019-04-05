module Step02.Solution.ResultPage exposing (resultPage)

import Html exposing (Html, a, div, h1, text)
import Html.Attributes exposing (class, href)


resultPage : Int -> Html msg
resultPage score =
    div [ class "score" ]
        [ h1 [] [ text ("Your score: " ++ String.fromInt score) ]
        , a [ class "btn btn-primary", href "#" ] [ text "Replay" ]
        ]
