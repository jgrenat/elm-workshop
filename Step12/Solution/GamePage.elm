module Step12.Solution.GamePage exposing (Question, displayAnswer, gamePage, main, questionToDisplay)

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
    div []
        [ h2 [ class "question" ] [ text question.question ]
        , ul [ class "answers" ] (List.map displayAnswer question.answers)
        ]


displayAnswer : String -> Html msg
displayAnswer answer =
    li []
        [ a [ class "btn btn-primary" ] [ text answer ]
        ]


main =
    div []
        [ div [ class "jumbotron" ] [ gamePage questionToDisplay ]
        ]
