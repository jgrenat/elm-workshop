module Step13.Solution.GamePage exposing (Category, Game, Model, Msg(..), Question, RemoteData(..), answersDecoder, correctAnswerDecoder, displayAnswer, displayTestsAndView, gamePage, getQuestionsRequest, init, main, questionDecoder, questionsDecoder, questionsUrl, testableProgram, update, view)

import Json.Decode as Decode
import Result exposing (Result)
import Testable
import Testable.Cmd
import Testable.Html exposing (Html, a, div, h2, iframe, li, program, text, ul)
import Testable.Html.Attributes exposing (class, src, style)
import Testable.Http as Http


questionsUrl : String
questionsUrl =
    "https://opentdb.com/api.php?amount=5&type=multiple"


main : Program Never Model Msg
main =
    testableProgram { init = init, update = update, view = displayTestsAndView, subscriptions = \model -> Sub.none }


type alias Question =
    { question : String
    , correctAnswer : String
    , answers : List String
    }


type alias Model =
    { game : RemoteData Game
    }


type alias Game =
    { currentQuestion : Question
    , remainingQuestions : List Question
    }


type Msg
    = OnQuestionsFetched (Result Http.Error (List Question))


type alias Category =
    { id : Int
    , name : String
    }


type RemoteData a
    = Loading
    | Loaded a
    | OnError


init : ( Model, Testable.Cmd.Cmd Msg )
init =
    ( Model Loading, Http.send OnQuestionsFetched getQuestionsRequest )


update : Msg -> Model -> ( Model, Testable.Cmd.Cmd Msg )
update message model =
    case message of
        OnQuestionsFetched (Ok (firstQuestion :: remainingQuestions)) ->
            let
                game =
                    Game firstQuestion remainingQuestions
            in
            ( Model (Loaded game), Testable.Cmd.none )

        OnQuestionsFetched _ ->
            ( Model OnError, Testable.Cmd.none )


view : Model -> Testable.Html.Html Msg
view model =
    case model.game of
        Loading ->
            div [] [ text "Loading the questions..." ]

        OnError ->
            div [] [ text "An unknown error occurred while loading the questions" ]

        Loaded game ->
            gamePage game.currentQuestion


gamePage : Question -> Html msg
gamePage question =
    div []
        [ h2 [ class "question" ] [ text question.question ]
        , ul [ class "answers" ] (List.map displayAnswer question.answers)
        ]


displayAnswer : String -> Html msg
displayAnswer answer =
    li [] [ a [ class "btn btn-primary" ] [ text answer ] ]


getQuestionsRequest : Http.Request (List Question)
getQuestionsRequest =
    Http.get questionsUrl questionsDecoder


questionsDecoder : Decode.Decoder (List Question)
questionsDecoder =
    Decode.field "results" (Decode.list questionDecoder)


questionDecoder : Decode.Decoder Question
questionDecoder =
    Decode.map3
        Question
        (Decode.field "question" Decode.string)
        correctAnswerDecoder
        answersDecoder


correctAnswerDecoder : Decode.Decoder String
correctAnswerDecoder =
    Decode.field "correct_answer" Decode.string


answersDecoder : Decode.Decoder (List String)
answersDecoder =
    Decode.map2
        (\correctAnswer incorrectAnswers -> correctAnswer :: incorrectAnswers)
        correctAnswerDecoder
        (Decode.field "incorrect_answers" (Decode.list Decode.string))



{- Or in a more concise way:

   answersDecoder : Decode.Decoder (List String)
   answersDecoder =
       Decode.map2
           (::)
           correctAnswerDecoder
           (Decode.field "incorrect_answers" (Decode.list Decode.string))
-}


displayTestsAndView : Model -> Testable.Html.Html Msg
displayTestsAndView model =
    div []
        [ div [ class "jumbotron" ] [ view model ]
        ]


testableProgram :
    { init : ( model, Testable.Cmd.Cmd msg )
    , update : msg -> model -> ( model, Testable.Cmd.Cmd msg )
    , subscriptions : model -> Sub msg
    , view : model -> Html msg
    }
    -> Program Never model msg
testableProgram options =
    program
        { init = Testable.init options.init
        , view = Testable.view options.view
        , update = Testable.update options.update
        , subscriptions = options.subscriptions
        }
