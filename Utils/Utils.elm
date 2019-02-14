module Utils.Utils exposing (styles, testsIframe)

import Html exposing (Html, div, iframe, node)
import Html.Attributes exposing (href, rel, src, style)


testsIframe : Html a
testsIframe =
    iframe
        [ src "./Tests/Tests.elm"
        , style "display" "block"
        , style "width" "90%"
        , style "margin" "auto"
        , style "height" "500px"
        , style "margin-top" "2em"
        ]
        []


styles : Html a
styles =
    div []
        [ node "link"
            [ rel "stylesheet"
            , href "/Utils/bootstrap.min.css"
            ]
            []
        , node "link"
            [ rel "stylesheet"
            , href "/Utils/style.css"
            ]
            []
        ]
