# Step 11: Parsing the URL

## Goal

For now, we have only handled static URLs, for example `#categories`. But how can we handle URL containing dynamic parameters? For example, our results page URL contains the score: `#result/3` or `#result/5`.

For these more advanced routes, we need to use a parser and more exactly the [`Url.Parser` module](https://package.elm-lang.org/packages/elm/url/latest/Url-Parser).

This is pretty much the same thing that with JSON decoders – we're describing what we expect to find and we check that pattern against the URL.

For example, the following parser can be used to recognize the path `/categories/13/details`: `Parser.s "categories" </> Parser.int </> s "details"`. Here is how you could use it:=

```elm
type Route =
    HomeRoute
    | CategoryDetailsRoute Int

categoryDetailsParser : Parser.Parser (Route -> Route) Route
categoryDetailsParser =
    Parser.s "categories" </> Parser.int </> Parser.s "details"
    |> Parser.map CategoryDetailsRoute


parseUrl : Url -> Route
parseUrl url = 
    Parser.parse categoryDetailsParser url
    |> Maybe.withDefault HomeRoute
```

## Parsing several routes

Now it's your turn to parse the URL of our application to recognize those three paths:

 - the root path should be recognized as the `HomeRoute` ([`Parser.top`](https://package.elm-lang.org/packages/elm/url/latest/Url-Parser#top) may help you)
 - the path `categories` should be recognized as the `CategoriesRoute`
 - the path `result/2` should be recognized as the `ResultRoute 2` (the `2` is of course a dynamic value)
 
To create a parser able to recognize several routes, you will need to use the [`Parser.oneOf` function](https://package.elm-lang.org/packages/elm/url/latest/Url-Parser#oneOf).


## Turning a route into a page

After having parsed the URL into a `Route`, a simple `case ... of` syntax will allow you to get the matching `Page` and to get a command if we need to (remember, on the `CategoriesPage`, we need to get the categories).

That's all, you can now modify the `routeParser` and the function `parseUrlToPageAndCommand` to make the tests pass.
 
## Let's start!

[See the result of your code](./ParsingRoute.elm) (don't forget to refresh to see changes)

Once the tests are passing, you can go to the [next step](../Step12).







