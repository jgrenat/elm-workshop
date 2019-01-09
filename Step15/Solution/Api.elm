module Step15.Solution.Api exposing (getCategoriesCommand, getQuestionsCommand)

import Http
import Json.Decode as Decode
import Step15.Solution.Types exposing (Category, Msg(..), Question)


getCategoriesUrl : String
getCategoriesUrl =
    "https://opentdb.com/api_category.php"


getQuestionsUrl : String
getQuestionsUrl =
    "https://opentdb.com/api.php?amount=5&type=multiple"


categoriesDecoder : Decode.Decoder (List Category)
categoriesDecoder =
    Decode.map2 Category (Decode.field "id" Decode.int) (Decode.field "name" Decode.string)
        |> Decode.list
        |> Decode.field "trivia_categories"


getCategoriesCommand : Cmd Msg
getCategoriesCommand =
    Http.send OnCategoriesFetched getCategoriesRequest


getCategoriesRequest : Http.Request (List Category)
getCategoriesRequest =
    Http.get getCategoriesUrl categoriesDecoder


getQuestionsCommand : Cmd Msg
getQuestionsCommand =
    Http.send OnQuestionsFetched getQuestionsRequest


getQuestionsRequest : Http.Request (List Question)
getQuestionsRequest =
    Http.get getQuestionsUrl questionsDecoder


questionsDecoder : Decode.Decoder (List Question)
questionsDecoder =
    Decode.field "results" (Decode.list questionDecoder)


questionDecoder : Decode.Decoder Question
questionDecoder =
    Decode.map3 Question (Decode.field "question" Decode.string) (Decode.field "correct_answer" Decode.string) answersDecoder


answersDecoder : Decode.Decoder (List String)
answersDecoder =
    Decode.map2 (::) (Decode.field "correct_answer" Decode.string) (Decode.field "incorrect_answers" (Decode.list Decode.string))
