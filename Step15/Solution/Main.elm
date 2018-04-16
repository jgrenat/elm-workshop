module Step15.Solution.Main exposing (..)

import Step15.Solution.Api exposing (getCategoriesCommand, getQuestionsCommand)
import Step15.Solution.Types exposing (Model, Msg(OnLocationChange), RemoteData(Loading), Route(GameRoute))
import Step15.Solution.Update exposing (update)
import Step15.Solution.View exposing (displayTestsAndView)
import Navigation exposing (..)
import Step15.Solution.Routing exposing (parseLocation)


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init, update = update, view = displayTestsAndView, subscriptions = (\model -> Sub.none) }


init : Location -> ( Model, Cmd Msg )
init location =
    let
        route =
            parseLocation location

        initialModel =
            Model Loading route

        initialCommand =
            case route of
                GameRoute _ ->
                    Cmd.batch [ getCategoriesCommand, getQuestionsCommand ]

                _ ->
                    getCategoriesCommand
    in
        ( initialModel, initialCommand )
