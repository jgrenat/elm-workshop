module Step14.GamePage exposing (..)

import Html exposing (Html, a, div, h2, li, program, text, ul)
import Html.Attributes exposing (class, src, style)
import Http
import Result exposing (Result)
import Json.Decode as Decode


questionsUrl : String
questionsUrl =
    "https://opentdb.com/api.php?amount=5&type=multiple"


main : Program Never Model Msg
main =
    program { init = init, update = update, view = view, subscriptions = (\model -> Sub.none) }


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
    ( Model Loading, getQuestionsCmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        OnQuestionsFetched (Ok []) ->
            ( model, getQuestionsCmd )

        OnQuestionsFetched (Ok (currentQuestion :: remainingQuestions)) ->
            ( Model (Loaded (Game currentQuestion remainingQuestions)), Cmd.none )

        OnQuestionsFetched (Err _) ->
            ( Model OnError, Cmd.none )


getQuestionsCmd : Cmd Msg
getQuestionsCmd =
    Http.send OnQuestionsFetched getQuestionsRequest


getQuestionsRequest : Http.Request (List Question)
getQuestionsRequest =
    Http.get questionsUrl questionsDecoder


questionsDecoder : Decode.Decoder (List Question)
questionsDecoder =
    Decode.field "results" (Decode.list questionDecoder)


questionDecoder : Decode.Decoder Question
questionDecoder =
    Decode.map3 Question (Decode.field "question" Decode.string) (Decode.field "correct_answer" Decode.string) answersDecoder


answersDecoder : Decode.Decoder (List String)
answersDecoder =
    Decode.map2 (::) (Decode.field "correct_answer" Decode.string) (Decode.field "incorrect_answers" (Decode.list Decode.string))


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
