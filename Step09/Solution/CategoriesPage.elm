module Step09.Solution.CategoriesPage exposing (Category, Model, Msg(..), RemoteData(..), categoriesListDecoder, displayCategories, displayCategory, getCategoriesDecoder, getCategoriesRequest, init, main, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Http exposing (expectJson)
import Json.Decode as Decode
import Result exposing (Result)


main : Program () Model Msg
main =
    Browser.element { init = \_ -> init, update = update, view = view, subscriptions = \model -> Sub.none }


type alias Model =
    { categories : RemoteData (List Category)
    }


type Msg
    = OnCategoriesFetched (Result Http.Error (List Category))


type alias Category =
    { id : Int
    , name : String
    }


type RemoteData a
    = Loading
    | Loaded a
    | OnError


init : ( Model, Cmd.Cmd Msg )
init =
    ( Model Loading, getCategoriesRequest )


getCategoriesRequest : Cmd Msg
getCategoriesRequest =
    Http.get
        { url = "https://opentdb.com/api_category.php"
        , expect = expectJson OnCategoriesFetched getCategoriesDecoder
        }


getCategoriesDecoder : Decode.Decoder (List Category)
getCategoriesDecoder =
    Decode.field "trivia_categories" categoriesListDecoder


categoriesListDecoder : Decode.Decoder (List Category)
categoriesListDecoder =
    Decode.list categoryDecoder


categoryDecoder : Decode.Decoder Category
categoryDecoder =
    Decode.map2 Category
        (Decode.field "id" Decode.int)
        (Decode.field "name" Decode.string)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnCategoriesFetched (Err _) ->
            ( Model OnError, Cmd.none )

        OnCategoriesFetched (Ok categories) ->
            ( Model (Loaded categories), Cmd.none )


view : Model -> Html Msg
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


displayCategories : List Category -> Html msg
displayCategories categories =
    ul [ class "categories" ] (List.map displayCategory categories)


displayCategory : Category -> Html msg
displayCategory category =
    let
        link =
            "#game/category/" ++ String.fromInt category.id
    in
    li []
        [ a [ class "btn btn-primary", href link ] [ text category.name ]
        ]
