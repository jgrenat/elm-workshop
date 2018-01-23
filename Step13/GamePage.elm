module Step13.GamePage exposing (..)

import Testable
import Testable.Cmd
import Testable.Html exposing (Html, a, div, h2, iframe, li, program, text, ul)
import Testable.Html.Attributes exposing (class, src, style)
import Testable.Http as Http
import Result exposing (Result)
import Json.Decode as Decode


questionsUrl : String
questionsUrl =
    "https://opentdb.com/api.php?amount=5&type=multiple"


main : Program Never Model Msg
main =
    testableProgram { init = init, update = update, view = displayTestsAndView, subscriptions = (\model -> Sub.none) }


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
    ( Model Loading, getQuestionsCmd )


update : Msg -> Model -> ( Model, Testable.Cmd.Cmd Msg )
update message model =
    case message of
        OnQuestionsFetched (Ok []) ->
            ( model, getQuestionsCmd )

        OnQuestionsFetched (Ok (currentQuestion :: remainingQuestions)) ->
            ( Model (Loaded (Game currentQuestion remainingQuestions)), Testable.Cmd.none )

        OnQuestionsFetched (Err _) ->
            ( Model OnError, Testable.Cmd.none )


getQuestionsCmd : Testable.Cmd.Cmd Msg
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


view : Model -> Testable.Html.Html Msg
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



------------------------------------------------------------------------------------------------------
-- Don't modify the code below, it displays the view and the tests and helps with testing your code --
------------------------------------------------------------------------------------------------------


displayTestsAndView : Model -> Testable.Html.Html Msg
displayTestsAndView model =
    div []
        [ div [ class "jumbotron" ] [ view model ]
        , iframe [ src "./Tests/index.html", class "mt-5 w-75 mx-auto d-block", style [ ( "height", "500px" ) ] ] []
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
