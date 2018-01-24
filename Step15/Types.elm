module Step15.Types exposing (..)

import Http exposing (Error)
import Navigation exposing (Location)


type alias Model =
    { categories : RemoteData (List Category)
    , route : Route
    }


type Msg
    = OnCategoriesFetched (Result Error (List Category))
    | OnQuestionsFetched (Result Error (List Question))
    | OnLocationChange Location


type alias Category =
    { id : Int, name : String }


type RemoteData a
    = Loading
    | Loaded a
    | OnError


type alias Question =
    { question : String
    , correctAnswer : String
    , answers : List String
    }


type alias AnsweredQuestion =
    { question : Question
    , status : QuestionStatus
    }


type QuestionStatus
    = Correct
    | Incorrect


type alias Game =
    { answeredQuestions : List AnsweredQuestion
    , currentQuestion : Question
    , remainingQuestions : List Question
    }


type Route
    = HomepageRoute
    | CategoriesRoute
    | ResultRoute Int
    | GameRoute (RemoteData Game)
