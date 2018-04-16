module Step15.Solution.Routing exposing (parseLocation)

import Navigation exposing (Location)
import Step15.Solution.Types exposing (RemoteData(Loading), Route(..))
import UrlParser exposing (..)


matcher : Parser (Route -> a) a
matcher =
    oneOf
        [ map HomepageRoute top
        , map CategoriesRoute (s "categories")
        , map ResultRoute (s "result" </> int)
        , map (GameRoute Loading) (s "game")
        ]


parseLocation : Location -> Route
parseLocation location =
    parseHash matcher location
        |> Maybe.withDefault HomepageRoute
