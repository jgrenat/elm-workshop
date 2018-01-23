module Main exposing (..)

import Random
import Html exposing (Html, program, div, button, text)
import Html.Events exposing (onClick)


{-| (1)
-}
main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , view = view
        , subscriptions = (\model -> Sub.none) -- (2)
        }


type alias Model =
    { randomNumber : Int
    }


type Msg
    = GenerateNumber
    | OnNumberGenerated Int


{-| (3)
-}
init : ( Model, Cmd Msg )
init =
    ( Model 0, Cmd.none )


{-| (3)
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GenerateNumber ->
            -- (5)
            ( model, Random.generate OnNumberGenerated (Random.int 0 10) )

        OnNumberGenerated number ->
            -- (6)
            ( Model number, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        -- (4)
        [ button [ onClick GenerateNumber ] [ text "Generate random number" ]
        , div []
            [ text ("The random number : " ++ (toString model.randomNumber)) ]
        ]
