# Step 7: The Elm Architecture

## Goal

We've seen how The Elm Architecture works on the previous step. As we've seen, we need to declare our web application in the following way:

```elm
main =
    Browser.sandbox { init = initialModel, view = view, update = update }
```

This function `sandbox` is in fact the most basic kind of web application you can do. There are other functions which provides more capabilities to your application:


 - `Browser.element` allows you to have _side effects_ like random numbers and to interact with the outside world (for example JavaScript code or HTTP requests). This is usually used to embed Elm parts inside an existing JavaScript application   
 - `Browser.document` allows you the same plus controlling the title of the page and the `body` entirely.
 - `Browser.application` allows you the same things than `Browser.document` and allows you to manages changes to the URL. 
 
The part about _side effects_ needs more explanations. Indeed, in Elm, every functions are pure. That means that their return value only depends on its parameters and that they can't alter anything outside their scope. 

That make them incompatible with the notion of random for example : a function which returns a random value cannot be pure as two identical calls would return different values! The same happens when we want to access data in the `localstorage` or get data from a web server with a HTTP request: we can't guarantee that each call of the function will produce the same value, so this cannot be done with pure functions!

These are important things for a web app to do, so how do Elm handle side effects? That's where we will talk about commands (`Cmd`) in Elm! A command is a way for our Elm code to ask the Elm runtime to perform an effect. For example, we can use them to ask the Elm runtime: "Okay, I need a random `Int` between 0 and 10! Can you generate one and send me the value inside a `ValueCreated` message?".

And this is the trick: our function will return the same command each time we'll call it with the same arguments. Then Elm will execute this order, then call our update function with the value encapsulated inside the `ValueCreated` message (which is a message we've created ourselves that contains an `Int`)

In the code everything stays pure, the side effects happens outside of our application!


## An example with a random number

Let's open the *[./RandomNumber.elm](./RandomNumber.elm)* file, in your browser and in your IDE. The code is annotated with numbers for a better comprehension.

We can see near `(1)` that we're declaring a `Browser.element` program that needs a fourth argument, a function that return the *Subscription*s `(2)`. *Subscriptions* are a mechanism allowing us to receive messages from JavaScript. As we don't need this, our function just returns `Sub.none`, meaning we don't want to _subscribe_ to JavaScript.

Then, near `(3)` we can see something different about the signature of the functions `init` and `update`: instead of only returning a `Model`, they return a tuple of two values: `(Model, Cmd Msg)`. By returning a `Cmd`, we will be able to ask the Elm runtime to execute side effects. Notice that this command is parameterized by `Msg`, meaning that once a command is done, the Elm runtime will need one of our application `Msg` to give us back the result. 

In the initial model, we don't need to perform any side effect, so we are returning `Cmd.none`.

The `view` function has nothing special except near `(4)`: we ask to send a message `GenerateNumber` that will be sent to our update function. Then, the update function is able to ask the Elm runtime to produce a random number near (5). As you can see, we're not updating the model here, we're just asking something to the Elm runtime:

```elm
Random.generate OnNumberGenerated (Random.int 0 10)
```

`Random.generate` creates a command to generate a random value. The second argument `Random.int 0 10` specify that we want an `Int` between 0 and 10. The first argument `OnNumberGenerated` is the message used by the Elm runtime to return the result to our `update` function.

That's exactly what happens near `(6)`, we receive the generated value and store it inside our model. There is no need for another side effect, so we can also return `Cmd.none`.


## Let's start!

Well, in fact... No! This step was only an example, but be prepared, on the next step we're going to implement the Elm Architecture on our categories page!


You can now go to the [next step](../Step08).
