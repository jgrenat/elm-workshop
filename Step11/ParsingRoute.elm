module Step11.ParsingRoute exposing (Category, Msg, Page(..), RemoteData(..), Route(..), categoriesUrl, displayPage, displayTestsAndView, homeUrl, main, parseUrlToPageAndCommand, resultUrl, routeParser, view)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Http exposing (expectJson)
import Json.Decode as Decode
import Url exposing (Protocol(..), Url)
import Url.Parser as Parser exposing ((</>))
import Utils.Utils exposing (styles, testsIframe)


main : Html Msg
main =
    displayTestsAndView


type Page
    = HomePage
    | CategoriesPage (RemoteData (List Category))
    | ResultPage Int


type Route
    = HomeRoute
    | CategoriesRoute
    | ResultRoute Int


type alias Category =
    { id : Int, name : String }


type RemoteData a
    = Loading
    | Loaded a
    | OnError


type Msg
    = OnCategoriesFetched (Result Http.Error (List Category))


homeUrl : Url
homeUrl =
    { protocol = Http
    , host = "localhost"
    , port_ = Just 80
    , path = "/"
    , query = Nothing
    , fragment = Nothing
    }


categoriesUrl : Url
categoriesUrl =
    { homeUrl | path = "/categories" }


resultUrl : Int -> Url
resultUrl score =
    { homeUrl | path = "/result/" ++ String.fromInt score }


routeParser : Parser.Parser (Route -> Route) Route
routeParser =
    Parser.oneOf
        [ Parser.map HomeRoute Parser.top ]


parseUrlToPageAndCommand : Url -> ( Page, Cmd Msg )
parseUrlToPageAndCommand url =
    let
        routeMaybe : Maybe Route
        routeMaybe =
            Parser.parse routeParser url
    in
    ( HomePage, Cmd.none )


view : Html Msg
view =
    div []
        [ div []
            [ text "Parsing url \"\": "
            , displayPage (parseUrlToPageAndCommand homeUrl)
            ]
        , div []
            [ text "Parsing url \"/categories\": "
            , displayPage (parseUrlToPageAndCommand categoriesUrl)
            ]
        , div []
            [ text "Parsing url \"/result/3\": "
            , displayPage (parseUrlToPageAndCommand <| resultUrl 3)
            ]
        , div []
            [ text "Parsing url \"/result/4\": "
            , displayPage (parseUrlToPageAndCommand <| resultUrl 4)
            ]
        ]


displayPage : ( Page, Cmd Msg ) -> Html msg
displayPage ( page, cmd ) =
    let
        pageString =
            case page of
                HomePage ->
                    "Home page"

                CategoriesPage Loading ->
                    "Categories page with Loading status and"

                CategoriesPage _ ->
                    "Categories page with wrong status and"

                ResultPage score ->
                    "Results page with score " ++ String.fromInt score ++ " and"

        commandString =
            if cmd /= Cmd.none then
                "with a command"

            else
                "with no command"
    in
    pageString
        ++ " "
        ++ commandString
        |> text


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



------------------------------------------------------------------------------------------------------
-- Don't modify the code below, it displays the view and the tests and helps with testing your code --
------------------------------------------------------------------------------------------------------


displayTestsAndView : Html Msg
displayTestsAndView =
    div []
        [ styles
        , div [ class "jumbotron" ] [ view ]
        , testsIframe
        ]
