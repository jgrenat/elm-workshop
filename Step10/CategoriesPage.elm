module Step10.CategoriesPage exposing (..)

import Testable
import Testable.Cmd
import Testable.Html exposing (Html, a, button, div, h1, iframe, li, program, text, ul)
import Testable.Html.Attributes exposing (class, href, src, style)
import Testable.Http as Http
import Result exposing (Result)
import Step6.CategoriesPage exposing (categoriesPage)
import Json.Decode as Decode


main : Program Never Model Msg
main =
    testableProgram { init = init, update = update, view = displayTestsAndView, subscriptions = (\model -> Sub.none) }


type alias Model =
    { categories : RemoteData (List Category)
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
    ( Model Loading, Http.send OnCategoriesFetched getCategoriesRequest )


getCategoriesRequest =
    Http.getString "https://opentdb.com/api_category.php"


update : Msg -> Model -> ( Model, Testable.Cmd.Cmd Msg )
update msg model =
    case msg of
        OnCategoriesFetched (Err error) ->
            ( Model OnError, Testable.Cmd.none )

        OnCategoriesFetched (Ok categories) ->
            ( model, Testable.Cmd.none )


view : Model -> Testable.Html.Html Msg
view model =
    div []
        [ h1 [] [ text "Play within a given category" ]
        , case model.categories of
            Loading ->
                text "Loading the categories..."

            OnError ->
                text "An error occurred while loading the categories"

            Loaded categories ->
                displayCategories categories
        ]


displayCategories : List Category -> Testable.Html.Html msg
displayCategories categories =
    ul [ class "categories" ] (List.map displayCategory categories)


displayCategory : Category -> Testable.Html.Html msg
displayCategory category =
    let
        link =
            "#game/category/" ++ (toString category.id)
    in
        li []
            [ a [ class "btn btn-primary", href link ] [ text category.name ]
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
