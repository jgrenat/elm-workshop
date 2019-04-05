module Step12.GamePage exposing (Question, gamePage, main, questionToDisplay)

import Html exposing (Html, a, div, h2, iframe, li, text, ul)
import Html.Attributes exposing (class, href, src, style)


type alias Question =
    { question : String
    , correctAnswer : String
    , answers : List String
    }


questionToDisplay =
    { question = "What won't we see in Elm?"
    , correctAnswer = "Runtime exceptions"
    , answers = [ "Runtime exceptions", "JSON", "Single page applications", "Happy developers" ]
    }


gamePage : Question -> Html msg
gamePage question =
    div [] [ text "Content of the page" ]



------------------------------------------------------------------------------------------------------------------------
-- You don't need to worry about the code below, it only displays the result of your code and the result of the tests --
------------------------------------------------------------------------------------------------------------------------


main =
    div []
        [ div [ class "jumbotron" ] [ gamePage questionToDisplay ]
        , iframe [ src "./Tests/index.html", class "mt-5 w-75 mx-auto d-block", style "height" "500px" ] []
        ]
