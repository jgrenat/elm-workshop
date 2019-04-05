module Step15.Solution.Update exposing (update)

import Navigation
import Step15.Solution.Api exposing (getQuestionsCommand)
import Step15.Solution.Routing exposing (parseLocation)
import Step15.Solution.Types exposing (AnsweredQuestion, Category, Game, Model, Msg(..), Question, QuestionStatus(..), RemoteData(..), Route(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnCategoriesFetched (Ok categories) ->
            ( { model | categories = Loaded categories }, Cmd.none )

        OnCategoriesFetched (Err err) ->
            ( { model | categories = OnError }, Cmd.none )

        OnQuestionsFetched (Ok []) ->
            ( model, getQuestionsCommand )

        OnQuestionsFetched (Ok (currentQuestion :: remainingQuestions)) ->
            let
                game =
                    Game [] currentQuestion remainingQuestions
            in
            ( { model | route = GameRoute (Loaded game) }, Cmd.none )

        OnQuestionsFetched (Err _) ->
            ( { model | route = GameRoute OnError }, Cmd.none )

        AnswerQuestion answer ->
            case model.route of
                GameRoute (Loaded game) ->
                    let
                        responseStatus =
                            if answer == game.currentQuestion.correctAnswer then
                                Correct

                            else
                                Incorrect

                        answeredQuestions =
                            AnsweredQuestion game.currentQuestion responseStatus :: game.answeredQuestions
                    in
                    case game.remainingQuestions of
                        [] ->
                            let
                                score =
                                    calculateScore answeredQuestions
                            in
                            ( { model | route = ResultRoute score }, Navigation.newUrl ("#result/" ++ toString score) )

                        newQuestion :: remainingQuestions ->
                            let
                                newGame =
                                    Game answeredQuestions newQuestion remainingQuestions
                            in
                            ( { model | route = GameRoute (Loaded newGame) }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        OnLocationChange location ->
            let
                route =
                    parseLocation location

                command =
                    case route of
                        GameRoute _ ->
                            getQuestionsCommand

                        _ ->
                            Cmd.none
            in
            ( { model | route = route }, command )


calculateScore : List AnsweredQuestion -> Int
calculateScore answeredQuestions =
    let
        scores =
            List.map
                (\answer ->
                    if answer.status == Correct then
                        1

                    else
                        0
                )
                answeredQuestions
    in
    List.foldl (+) 0 scores
