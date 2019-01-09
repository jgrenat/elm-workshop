module Step15.Update exposing (update)

import Navigation
import Step15.Api exposing (getQuestionsCommand)
import Step15.Routing exposing (parseLocation)
import Step15.Types exposing (AnsweredQuestion, Category, Game, Model, Msg(..), Question, QuestionStatus(..), RemoteData(..), Route(..))


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
