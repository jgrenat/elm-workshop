module Step09.Solution.CategoriesPage exposing (..)

import Testable
import Testable.Cmd
import Testable.Html exposing (Html, button, div, h1, iframe, program, text)
import Testable.Html.Attributes exposing (class, src, style)
import Testable.Http as Http
import Result exposing (Result)


main : Program Never Model Msg
main =
    testableProgram { init = init, update = update, view = displayView, subscriptions = (\model -> Sub.none) }


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
    ( Model Loading, getCategoriesCmd )


getCategoriesCmd : Testable.Cmd.Cmd Msg
getCategoriesCmd =
    Http.send OnCategoriesFetched (Http.getString "https://opentdb.com/api_category.php")


update : Msg -> Model -> ( Model, Testable.Cmd.Cmd Msg )
update msg model =
    case msg of
        OnCategoriesFetched (Ok categoriesString) ->
            ( { model | categories = Loaded categoriesString }, Testable.Cmd.none )

        OnCategoriesFetched (Err _) ->
            ( Model OnError, Testable.Cmd.none )


view : Model -> Testable.Html.Html Msg
view model =
    div []
        [ h1 [] [ text "Play within a given category" ]
        , displayCategories model.categories
        ]


displayCategories : RemoteData String -> Html Msg
displayCategories remoteString =
    case remoteString of
        Loading ->
            text "Loading the categories..."

        OnError ->
            text "An error occurred while loading the categories."

        Loaded categories ->
            text categories



------------------------------------------------------------------------------------------------------
-- Don't modify the code below, it displays the view and the tests and helps with testing your code --
------------------------------------------------------------------------------------------------------


displayView : Model -> Testable.Html.Html Msg
displayView model =
    div []
        [ div [ class "jumbotron" ] [ view model ] ]


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
