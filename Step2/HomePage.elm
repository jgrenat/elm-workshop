module Step2.HomePage exposing (..)

import Html exposing (Html, a, beginnerProgram, div, h1, iframe, text)
import Html.Attributes exposing (class, href, src, style)


homePage : Html msg
homePage =
    div []
        [ h1 [] [ text "A random title" ]
        , a [ class "btn", href "#nowhere" ] [ text "A random link" ]
        ]



------------------------------------------------------------------------------------------------------------------------
-- You don't need to worry about the code below, it only displays the result of your code and the result of the tests --
------------------------------------------------------------------------------------------------------------------------


main =
    div []
        [ div [ class "jumbotron" ] [ homePage ]
        , iframe [ src "./Tests/index.html", class "mt-5 w-75 mx-auto d-block", style [ ( "height", "500px" ) ] ] []
        ]
