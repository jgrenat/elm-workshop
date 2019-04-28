module Step10.Routing exposing (Category, Model, Msg(..), RemoteData(..), categoriesDecoder, displayCategoriesList, displayCategoriesPage, displayCategory, displayHomepage, displayPage, displayResultPage, displayTestsAndView, getCategoriesRequest, getCategoriesUrl, init, initialModel, main, update, view)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation exposing (Key)
import Html exposing (Html, a, button, div, h1, iframe, li, text, ul)
import Html.Attributes exposing (class, href, src, style)
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


type alias Model =
    { key : Key
    , categories : RemoteData (List Category)
    }


type alias Category =
    { id : Int, name : String }


type RemoteData a
    = Loading
    | Loaded a
    | OnError


initialModel : Url -> Key -> Model
initialModel url key =
    Model key Loading


init : () -> Url -> Key -> ( Model, Cmd Msg )
init _ url key =
    ( initialModel url key, getCategoriesRequest )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnCategoriesFetched (Ok categories) ->
            ( { model | categories = Loaded categories }, Cmd.none )

        OnCategoriesFetched (Err err) ->
            ( { model | categories = OnError }, Cmd.none )

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
        [ displayPage model ]


displayPage : Model -> Html Msg
displayPage model =
    displayHomepage model


displayHomepage : Model -> Html Msg
displayHomepage model =
    div [ class "gameOptions" ]
        [ h1 [] [ text "Quiz Game" ]
        , a [ class "btn btn-primary", href "#categories" ] [ text "Play from a category" ]
        , a [ class "btn btn-primary", href "#result/3" ] [ text "Show me the results page" ]
        ]


displayCategoriesPage : RemoteData (List Category) -> Html Msg
displayCategoriesPage categories =
    div []
        [ h1 [] [ text "Play within a given category" ]
        , displayCategoriesList categories
        ]


displayResultPage : Int -> Html Msg
displayResultPage score =
    div [ class "score" ]
        [ h1 [] [ text ("Your score: " ++ String.fromInt score ++ " / 5") ]
        , a [ class "btn btn-primary", href "#" ] [ text "Replay" ]
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
