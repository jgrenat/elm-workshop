module Step02.ResultPage exposing (main, resultPage)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Utils.Utils exposing (styles, testsIframe)


resultPage : Int -> Html msg
resultPage score =
    div []
        [ text "Content should go here"
        ]



------------------------------------------------------------------------------------------------------------------------
-- You don't need to worry about the code below, it only displays the result of your code and the result of the tests --
------------------------------------------------------------------------------------------------------------------------


main =
    div []
        [ styles
        , div [ class "jumbotron" ] [ resultPage 3 ]
        , testsIframe
        ]
