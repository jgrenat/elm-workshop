module Step6.Tests.Tests exposing (..)

import Fuzz exposing (intRange)
import Html exposing (div)
import Step6.CategoriesPage exposing (categories, categoriesPage)
import Test.Runner.Html exposing (run)
import Test exposing (Test, describe, fuzz, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, class, classes, tag, text)
import Expect
import Html.Attributes exposing (href)


main =
    describe "What we expect:"
        [ titleIsPresentWithProperText
        , listOfCategoriesIsPresent
        , everyCategoriesAreDisplayed
        , eachCategoryHasItsNameDisplayed
        , replayLinkShouldHaveProperClasses
        , replayLinkShouldHaveProperLink
        ]
        |> run


titleIsPresentWithProperText : Test
titleIsPresentWithProperText =
    test "There should be a title with the proper text \"Play within a given category\"" <|
        \() ->
            categoriesPage
                |> Query.fromHtml
                |> Query.find [ tag "h1" ]
                |> Query.has [ text "Play within a given category" ]


listOfCategoriesIsPresent : Test
listOfCategoriesIsPresent =
    test "There should be an 'ul' tag with the class \"categories\"" <|
        \() ->
            categoriesPage
                |> Query.fromHtml
                |> Query.find [ tag "ul" ]
                |> Query.has [ class "categories" ]


everyCategoriesAreDisplayed : Test
everyCategoriesAreDisplayed =
    test "There are 32 'li' tags displayed, one for each category" <|
        \() ->
            categoriesPage
                |> Query.fromHtml
                |> Query.findAll [ tag "li" ]
                |> Query.count (Expect.equal 24)


eachCategoryHasItsNameDisplayed : Test
eachCategoryHasItsNameDisplayed =
    fuzz (intRange 0 22) "Each category has its name displayed" <|
        \categoryIndex ->
            categoriesPage
                |> Query.fromHtml
                |> Query.has [ getCategory categoryIndex |> .name |> text ]


replayLinkShouldHaveProperClasses : Test
replayLinkShouldHaveProperClasses =
    test "Each link has the classes \"btn btn-primary\"" <|
        \() ->
            categoriesPage
                |> Query.fromHtml
                |> Query.findAll [ tag "a" ]
                |> Query.each (Query.has [ classes [ "btn", "btn-primary" ] ])


replayLinkShouldHaveProperLink : Test
replayLinkShouldHaveProperLink =
    fuzz (intRange 0 22) "Each category have the proper link" <|
        \index ->
            let
                link =
                    (getCategory index) |> .id |> toString |> (++) "#game/category/"
            in
                categoriesPage
                    |> Query.fromHtml
                    |> Query.has [ tag "a", attribute (Html.Attributes.href link) ]


getCategory index =
    categories
        |> List.drop index
        |> List.head
        |> \maybeCategory ->
            case maybeCategory of
                Just category ->
                    category

                Nothing ->
                    Debug.crash ("Cannot find category with index " ++ (toString index) ++ ", have you touched the categories list?")
