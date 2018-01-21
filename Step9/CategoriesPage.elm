module Step9.CategoriesPage exposing (..)

import Testable
import Testable.Cmd
import Testable.Html exposing (Html, button, div, h1, iframe, program, text)
import Testable.Html.Attributes exposing (class, src, style)
import Testable.Http as Http
import Result exposing (Result)
import Step6.CategoriesPage exposing (categoriesPage)


main : Program Never Model Msg
main =
    testableProgram { init = init, update = update, view = displayTestsAndView, subscriptions = (\model -> Sub.none) }


type alias Model =
    { categories : RemoteData String
    }


type Msg
    = OnCategoriesFetched (Result Http.Error String)


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
    ( Model Loading, Testable.Cmd.none )


update : Msg -> Model -> ( Model, Testable.Cmd.Cmd Msg )
update msg model =
    case msg of
        OnCategoriesFetched _ ->
            ( model, Testable.Cmd.none )


view : Model -> Testable.Html.Html Msg
view model =
    div []
        [ h1 [] [ text "Play within a given category" ]
        , text "Loading the categories..."
        ]



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
