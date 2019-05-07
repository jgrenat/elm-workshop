module Step13.GamePage exposing (Category, Game, Model, Msg(..), Question, RemoteData(..), displayAnswer, displayTestsAndView, gamePage, init, main, questionsUrl, update, view)

import Browser
import Html exposing (Html, a, div, h2, li, text, ul)
import Html.Attributes exposing (class)
import Http exposing (Error, expectJson)
import Utils.Utils exposing (styles, testsIframe)


questionsUrl : String
questionsUrl =
    "https://opentdb.com/api.php?amount=5&type=multiple"


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> init
        , update = update
        , view = displayTestsAndView
        , subscriptions = \model -> Sub.none
        }


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
    ( Model Loading, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        OnQuestionsFetched _ ->
            ( model, Cmd.none )


view : Model -> Html.Html Msg
view model =
    div [] [ text "Content of the page" ]


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


displayTestsAndView : Model -> Html Msg
displayTestsAndView model =
    div []
        [ styles
        , div [ class "jumbotron" ] [ view model ]
        , testsIframe
        ]
