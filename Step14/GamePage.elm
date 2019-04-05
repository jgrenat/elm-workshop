module Step14.GamePage exposing (Category, Game, Model, Msg(..), Question, RemoteData(..), answersDecoder, correctAnswerDecoder, displayAnswer, gamePage, getQuestionsRequest, init, main, questionDecoder, questionsDecoder, questionsUrl, update, view)

import Html exposing (Html, a, div, h2, li, program, text, ul)
import Html.Attributes exposing (class, src, style)
import Http
import Json.Decode as Decode
import Result exposing (Result)


questionsUrl : String
questionsUrl =
    "https://opentdb.com/api.php?amount=5&type=multiple"


main : Program Never Model Msg
main =
    program { init = init, update = update, view = view, subscriptions = \model -> Sub.none }


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


init : ( Model, Cmd Msg )
init =
    ( Model Loading, Http.send OnQuestionsFetched getQuestionsRequest )


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        OnQuestionsFetched (Ok (currentQuestion :: remainingQuestions)) ->
            ( Model (Loaded (Game currentQuestion remainingQuestions)), Cmd.none )

        OnQuestionsFetched _ ->
            ( Model OnError, Cmd.none )


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
        (::)
        correctAnswerDecoder
        (Decode.field "incorrect_answers" (Decode.list Decode.string))


view : Model -> Html Msg
view model =
    case model.game of
        Loading ->
            text "Loading the questions..."

        OnError ->
            text "An unknown error occurred while loading the questions."

        Loaded game ->
            div [] [ gamePage game.currentQuestion ]


gamePage : Question -> Html msg
gamePage question =
    div []
        [ h2 [ class "question" ] [ text question.question ]
        , ul [ class "answers" ] (List.map displayAnswer question.answers)
        ]


displayAnswer : String -> Html msg
displayAnswer answer =
    li [] [ a [ class "btn btn-primary" ] [ text answer ] ]
