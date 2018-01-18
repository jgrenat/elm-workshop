module Step4.ResultPage exposing (..)

import Html exposing (Html, a, beginnerProgram, div, h1, iframe, p, text)
import Html.Attributes exposing (class, href, id, src, style)


resultPage : Int -> Html msg
resultPage score =
    let
        comment =
            if score < 4 then
                "Keep going, I'm sure you can do better!"
            else
                "Congrats, this is really good!"
    in
        div [ class "score" ]
            [ h1 [] [ text ("Your score: " ++ (toString score) ++ " / 5") ]
            , p [] [ text comment ]
            , a [ class "btn btn-primary", href "#" ] [ text "Replay" ]
            ]



-----------------------------------------------------------------------------------------------------------------------
-- You don't need to worry about the code below, it only display the result of your code and the result of the tests --
-----------------------------------------------------------------------------------------------------------------------


main =
    div []
        [ div [ class "jumbotron" ] [ resultPage 3 ]
        , iframe [ src "./Tests/index.html", class "mt-5 w-75 mx-auto d-block", style [ ( "height", "500px" ) ] ] []
        ]
