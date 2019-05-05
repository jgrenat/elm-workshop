module Step10.Routing exposing (Category, Model, Msg(..), RemoteData(..), categoriesDecoder, displayCategoriesList, displayCategoriesPage, displayCategory, displayTestsAndView, getCategoriesRequest, getCategoriesUrl, init, main, update, view)

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Navigation exposing (Key)
import Html exposing (Html, a, div, h1, li, text, ul)
import Html.Attributes exposing (class, href)
import Http exposing (expectJson)
import Json.Decode as Decode
import Result exposing (Result)
import Url exposing (Url)
import Utils.Utils exposing (styles, testsIframe)


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = displayTestsAndView
        , subscriptions = \model -> Sub.none
        , onUrlRequest = OnUrlRequest
        , onUrlChange = OnUrlChange
        }


type Msg
    = OnCategoriesFetched (Result Http.Error (List Category))
    | OnUrlRequest UrlRequest
    | OnUrlChange Url


type Page
    = HomePage
    | CategoriesPage (RemoteData (List Category))


type alias Model =
    { key : Key
    , page : Page
    }


type alias Category =
    { id : Int, name : String }


type RemoteData a
    = Loading
    | Loaded a
    | OnError


init : () -> Url -> Key -> ( Model, Cmd Msg )
init _ url key =
    ( Model key HomePage, getCategoriesRequest )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnCategoriesFetched (Ok categories) ->
            ( model, Cmd.none )

        OnCategoriesFetched (Err err) ->
            ( model, Cmd.none )

        OnUrlRequest urlRequest ->
            ( model, Cmd.none )

        OnUrlChange url ->
            ( model, Cmd.none )


getCategoriesUrl : String
getCategoriesUrl =
    "https://opentdb.com/api_category.php"


categoriesDecoder : Decode.Decoder (List Category)
categoriesDecoder =
    Decode.map2 Category (Decode.field "id" Decode.int) (Decode.field "name" Decode.string)
        |> Decode.list
        |> Decode.field "trivia_categories"


getCategoriesRequest : Cmd Msg
getCategoriesRequest =
    Http.get
        { url = getCategoriesUrl
        , expect = expectJson OnCategoriesFetched categoriesDecoder
        }


view : Model -> Html Msg
view model =
    div []
        [ displayHomePage ]


displayHomePage : Html Msg
displayHomePage =
    div [ class "gameOptions" ]
        [ h1 [] [ text "Quiz Game" ]
        , a [ class "btn btn-primary", href "#categories" ] [ text "Play from a category" ]
        ]


displayCategoriesPage : RemoteData (List Category) -> Html Msg
displayCategoriesPage categories =
    div []
        [ h1 [] [ text "Play within a given category" ]
        , displayCategoriesList categories
        ]


displayCategoriesList : RemoteData (List Category) -> Html Msg
displayCategoriesList categoriesRemote =
    case categoriesRemote of
        Loaded categories ->
            List.map displayCategory categories
                |> ul [ class "categories" ]

        OnError ->
            text "An error occurred while fetching categories"

        Loading ->
            text "Categories are loading..."


displayCategory : Category -> Html Msg
displayCategory category =
    let
        path =
            "#game/category/" ++ String.fromInt category.id
    in
    li []
        [ a [ class "btn btn-primary", href path ] [ text category.name ]
        ]



------------------------------------------------------------------------------------------------------
-- Don't modify the code below, it displays the view and the tests and helps with testing your code --
------------------------------------------------------------------------------------------------------


displayTestsAndView : Model -> Document Msg
displayTestsAndView model =
    Document
        "Step 10"
        [ styles
        , div [ class "jumbotron" ] [ view model ]
        , testsIframe
        ]
