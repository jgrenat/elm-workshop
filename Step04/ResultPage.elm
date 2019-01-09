module Step04.ResultPage exposing (main, resultPage)

import Html exposing (Html, a, div, h1, iframe, p, text)
import Html.Attributes exposing (class, href, id, src, style)


resultPage : Int -> Html msg
resultPage score =
    div [ class "score" ]
        [ h1 [] [ text ("Your score: " ++ String.fromInt score ++ " / 5") ]
        , a [ class "btn btn-primary", href "#" ] [ text "Replay" ]
        ]



------------------------------------------------------------------------------------------------------------------------
-- You don't need to worry about the code below, it only displays the result of your code and the result of the tests --
------------------------------------------------------------------------------------------------------------------------


main =
    div []
        [ div [ class "jumbotron" ] [ resultPage 3 ]
        , iframe [ src "./Tests/index.html", class "mt-5 w-75 mx-auto d-block", style "height" "500px" ] []
        ]
