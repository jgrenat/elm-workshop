module Step01.Solution.HomePage exposing (homePage)

import Html exposing (Html, a, div, h1, text)
import Html.Attributes exposing (class, href)


homePage : Html msg
homePage =
    div [ class "gameOptions" ]
        [ h1 [] [ text "Quiz Game" ]
        , a [ class "btn btn-primary", href "#game" ] [ text "Play random questions" ]
        , a [ class "btn btn-primary", href "#categories" ] [ text "Play from a category" ]
        ]
