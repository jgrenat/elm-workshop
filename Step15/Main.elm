module Step15.Main exposing (init, main)

import Navigation exposing (..)
import Step15.Api exposing (getCategoriesCommand, getQuestionsCommand)
import Step15.Routing exposing (parseLocation)
import Step15.Types exposing (Model, Msg(..), RemoteData(..), Route(..))
import Step15.Update exposing (update)
import Step15.View exposing (displayTestsAndView)


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init, update = update, view = displayTestsAndView, subscriptions = \model -> Sub.none }


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
