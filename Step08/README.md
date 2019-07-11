# Step 8: Categories List (part 2)

## Goal

A lot of theory during the last 2 steps, it's time to come back to the categories page. But that was necessary, because we will now load our categories using a HTTP request... aka an *effect*! 

You're now ready for that!

In the `CategoriesPage.elm` file, you can see that now, our categories page follow the Elm Architecture. Moreover, the categories list is not hardwritten in the code anymore, and does not appear!

Your goal will now be to fetch this list through the [Trivia API](https://opentdb.com/api_config.php). The only thing you'll need to do is a GET request to [https://opentdb.com/api_category.php](https://opentdb.com/api_category.php).

Our model is composed of a record with a key `categories` containing something of type `RemoteData String`. This is a custom type that we've defined above in the code, that allow us to represent our result by stating if our categories are loading, if we've had an error doing so, or if they are loaded successfully (in which case it does contain the result). Here, we're only trying to get a `String` and not a `List Category`. Because converting the result into a `List Category` is harder, we will do that in the next step.


## Instructions 

 - When the page load, you need to trigger a HTTP call to get the categories list
 - This request will fetch the categories and get back a string representing the categories list as a JSON document
 - During the request, the screen should display the message "*Loading the categories...*"
 - If an error occurs, the screen should display the message "*An error occurred while loading the categories*"
 - When the categories are received, the screen should display the result as a string
 
 
## How do I perform HTTP requests?
 
As for random numbers, HTTP requests are an effect that need to be asked with a command. For that, you will use the package `elm/http` already installed on the project.

You will use the function [Http.get](https://package.elm-lang.org/packages/elm/http/latest/Http#get) that takes as argument a record containing two elements:
 - the URL to call
 - what the request should expect as a result
 
As we're expecting a string, for the second element you can use [Http.expectString](https://package.elm-lang.org/packages/elm/http/latest/Http#expectString) that needs as argument a function of type `Result Error String -> Msg`. That's a function that receives a `Result Error String` and returns a message. 

Lucky us, that's exactly the signature of our message constructor `OnCategoriesFetched`!

Small tip: The `Result error value` type is defined in the `Result` module like this:

```elm
type Result error value
    = Ok value
    | Err error
```

It should be enough for you to extract data from it in a `case...of` expression, but you can find more information [there](https://package.elm-lang.org/packages/elm/core/latest/Result).


## Let's start!

[See the result of your code](./CategoriesPage.elm) (don't forget to refresh to see changes)

Once the tests are passing, you can go to the [next step](../Step09).









