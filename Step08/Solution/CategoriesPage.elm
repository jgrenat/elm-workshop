module Step08.CategoriesPage exposing (Model, Msg(..), RemoteData(..), init, main, update, view)

import Browser
import Html exposing (Html, div, h1, text)
import Http exposing (expectString)
import Result exposing (Result)


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> init
        , update = update
        , view = view
        , subscriptions = \model -> Sub.none
        }


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


init : ( Model, Cmd Msg )
init =
    ( Model Loading, getCategories )


getCategories : Cmd Msg
getCategories =
    Http.get { url = "https://opentdb.com/api_category.php", expect = expectString OnCategoriesFetched }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnCategoriesFetched (Ok categories) ->
            ( { model | categories = Loaded categories }, Cmd.none )

        OnCategoriesFetched (Err _) ->
            ( { model | categories = OnError }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Play within a given category" ]
        , case model.categories of
            Loading ->
                text "Loading the categories..."

            OnError ->
                text "An error occurred while loading the categories..."

            Loaded categories ->
                text categories
        ]
