module Step03.Solution.ResultPage exposing (..)

import Html exposing (Html, a, beginnerProgram, div, h1, iframe, text)
import Html.Attributes exposing (class, href, src, style)


resultPage : Int -> Html msg
resultPage score =
    div [ class "score" ]
        [ h1 [] [ text ("Your score: " ++ toString score) ]
        , a [ class "btn btn-primary", href "#" ] [ text "Replay" ]
        ]
