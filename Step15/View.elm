module Step15.View exposing (displayTestsAndView, view)

import ElmEscapeHtml exposing (unescape)
import Html exposing (Html, a, div, h1, h2, iframe, li, program, text, ul)
import Html.Attributes exposing (class, href, src, style)
import Html.Events exposing (onClick)
import Step15.Types exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ displayPage model ]


displayPage : Model -> Html Msg
displayPage model =
    case model.route of
        HomepageRoute ->
            displayHomepage model

        ResultRoute score ->
            displayResultPage score

        CategoriesRoute ->
            displayCategoriesPage model.categories

        GameRoute remoteGame ->
            displayGamePage remoteGame


displayHomepage : Model -> Html Msg
displayHomepage model =
    div [ class "gameOptions" ]
        [ h1 [] [ text "Quiz Game" ]
        , a [ class "btn btn-primary", href "#game" ] [ text "Play random questions" ]
        , a [ class "btn btn-primary", href "#categories" ] [ text "Play from a category" ]
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
        [ h1 [] [ text ("Your score: " ++ toString score ++ " / 5") ]
        , a [ class "btn btn-primary", href "#" ] [ text "Replay" ]
        ]


displayGamePage : RemoteData Game -> Html Msg
displayGamePage remoteGame =
    case remoteGame of
        Loading ->
            text "Loading the questions..."

        OnError ->
            text "An unknown error occurred while loading the questions."

        Loaded game ->
            div [] [ displayGame game.currentQuestion ]


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
            "#game/category/" ++ toString category.id
    in
    li []
        [ a [ class "btn btn-primary", href path ] [ text category.name ]
        ]


displayGame : Question -> Html Msg
displayGame question =
    div []
        [ h2 [ class "question" ] [ unescape question.question |> text ]
        , ul [ class "answers" ] (List.map displayAnswer question.answers)
        ]


displayAnswer : String -> Html Msg
displayAnswer answer =
    li [] [ a [ class "btn btn-primary" ] [ unescape answer |> text ] ]



------------------------------------------------------------------------------------------------------
-- Don't modify the code below, it displays the view and the tests and helps with testing your code --
------------------------------------------------------------------------------------------------------


displayTestsAndView : Model -> Html Msg
displayTestsAndView model =
    div []
        [ div [ class "jumbotron" ] [ view model ]
        , iframe [ src "./Tests/index.html", class "mt-5 w-75 mx-auto d-block", style "height" "500px" ] []
        ]
