module Step05.Tests.Tests exposing (eachCategoryHasItsNameDisplayed, everyCategoriesAreDisplayed, getCategory, listOfCategoriesIsPresent, replayLinkShouldHaveProperClasses, replayLinkShouldHaveProperLink, suite, titleIsPresentWithProperText)

import Expect exposing (fail)
import Fuzz exposing (intRange)
import Html exposing (Html, div)
import Html.Attributes
import Random
import Step05.CategoriesPage exposing (Category, categories, categoriesPage)
import Test exposing (Test, concat, fuzz, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, class, classes, tag, text)
import Test.Runner.Html exposing (defaultConfig, hidePassedTests, viewResults)
import Utils.Utils exposing (testStyles)


main : Html a
main =
    div []
        [ testStyles
        , viewResults (Random.initialSeed 1000 |> defaultConfig |> hidePassedTests) suite
        ]


suite : Test
suite =
    concat
        [ titleIsPresentWithProperText
        , listOfCategoriesIsPresent
        , everyCategoriesAreDisplayed
        , eachCategoryHasItsNameDisplayed
        , replayLinkShouldHaveProperClasses
        , replayLinkShouldHaveProperLink
        ]


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
    test "There are 24 'li' tags displayed, one for each category" <|
        \() ->
            categoriesPage
                |> Query.fromHtml
                |> Query.findAll [ tag "li" ]
                |> Query.count (Expect.equal 24)


eachCategoryHasItsNameDisplayed : Test
eachCategoryHasItsNameDisplayed =
    fuzz (intRange 0 23) "Each category has its name displayed" <|
        \categoryIndex ->
            case getCategory categoryIndex of
                Just category ->
                    categoriesPage
                        |> Query.fromHtml
                        |> Query.has [ text category.name ]

                Nothing ->
                    "Cannot find category with index "
                        ++ String.fromInt categoryIndex
                        ++ ", have you touched the categories list?"
                        |> fail


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
    fuzz (intRange 0 23) "Each category have the proper link" <|
        \categoryIndex ->
            let
                linkMaybe =
                    getCategory categoryIndex
                        |> Maybe.map
                            (.id
                                >> String.fromInt
                                >> (++) "#game/category/"
                            )
            in
            case linkMaybe of
                Just link ->
                    categoriesPage
                        |> Query.fromHtml
                        |> Query.has [ tag "a", attribute (Html.Attributes.href link) ]

                Nothing ->
                    "Cannot find category with index "
                        ++ String.fromInt categoryIndex
                        ++ ", have you touched the categories list?"
                        |> fail


getCategory : Int -> Maybe Category
getCategory index =
    categories
        |> List.drop index
        |> List.head
