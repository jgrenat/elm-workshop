# Step 09: Categories List (final step)

## Goal

We now have the categories list as a `String`, but we need it as a `List Category`. That's exactly what we will achieve in this step!


## JSON Decoders

Elm has no runtime exception mainly thanks to its type system.  Then how to interact with JSON strings, that are by nature really permissive?
The answer is: each time we have to deal with a JSON, we will validate its structure thanks to a `Decoder`.

Decode a JSON value into an Elm type means you need to tell the Elm runtime the way the JSON is structured and where to find each piece of information.

For example, if you have a JSON like `{ firstname: "John", lastname: "Doe", birthYear: 1987 }`, you can tell Elm that there is a field `firstname` containing a `String` and a field `birthYear` containing an `Int`. 
If we don't need to use `lastname`, you don't need to mention it. 

Such a decoder could be created like below, thanks to the module [Json.Decode](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode):

```elm
import Json.Decode as Decode exposing (int, map2, field, string)

type alias User = 
    { firstname : String
    , birth : Int 
    } 

userDecoder : Decode.Decoder User
userDecoder =
    Decode.map2 
        User 
        (Decode.field "firstname" Decode.string) 
        (Decode.field "birthYear" Decode.int)
```

As you can see, we are using `map2` to indicate that we will describe two fields. `User` is used as a constructor that will build our user thanks to the resulting values of the two decoders described below.
If we had four fields to get, we would have used `map4`.
 
Then we describe where to find the first of the two values, indicating that we are searching for  a field `firstname` of type `String`. 
Then we describe where to find the second value, in a field `lastname` of type `Int`.

Now that we have our decoder, how can we use it? For that you can use the function [`decodeString`](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#decodeString):

```elm
jsonString : String
jsonString =
    "{ firstname: \"John\", lastname: \"Doe\", birthYear: 1987 }"

decodedUser : Result String User
decodedUser =  
    Decode.decodeString userDecoder jsonString
```

As you can see, this function returns a `Result`, so you have to handle the cases where the JSON string is not valid, or the values you were searching for are not found inside.


## A few tips

You have now all the elements to decode our `String` into a `List Category`, but here are a few tips:

 - By replacing [`Http.expectString`](https://package.elm-lang.org/packages/elm/http/latest/Http#expectString) by [`Http.expectJson`](https://package.elm-lang.org/packages/elm/http/latest/Http#expectJson), you can directly provide a `Decoder` as the second argument to decode the received body  
 - We are not decoding a single category, but a list of categories. Explore the [`Json.Decode`](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode) documentation to find a function that could help!
 - Be careful, if you look at the response body, our categories list is inside a field `trivia_categories`: `{ "trivia_categories": [...] }`. You will need to indicate that in your decoder:

```elm 
getCategoriesDecoder = 
        Decode.field "trivia_categories" categoriesListDecoder
```

## Let's start!

[See the result of your code](./CategoriesPage.elm) (don't forget to refresh to see changes)

Once the tests are passing, you can go to the [next step](../Step10).










