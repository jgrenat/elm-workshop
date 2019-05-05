# Step 10: Routing

## Goal


## Navigation?

When we're talking about *navigation* in a classic Single Page Application, it means that our application handles several pages with different URLs without reloading everything. 

This is possible by handling these three things:

 - When the page load, we need to analyze the initial URL to display the proper page
 - When the user click on a link, we need to change the URL (= adding an entry to the browser history)
 - When the URL change, we need to display the proper page
 
This is quite easy to do with Elm, but we will need to use a more advanced program than `Browser.element`. The `Browser.navigation` program allows us these three things. Let's see how we can declare such a program:


```elm
main : Program Value Model Msg
main = 
    Browser.application 
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = OnUrlRequest
        , onUrlChange = OnUrlChange
        }
```

First thing we can notice is that we need to provide two new elements: `OnUrlRequest` and `OnUrlChange` that are both messages that can be defined like this:

```elm
type Msg =
    OnUrlRequest UrlRequest
    | OnUrlChange Url
```

The first will be sent when a link is clicked and the second when an URL has changed (= when there is a new entry in the browser history). Great, that's two of the three things we need to handle! 

But these are not the only two elements that have changed, let's have a look at the signature of the `init` function:

```elm
init : flags -> Url -> Key -> ( Model, Cmd Msg )
```

`flags` is a value that we can get when starting our application (similar to arguments in a CLI tool for example) but we won't need that for now. However, we can see that we also receive a `Url` and a `Key`. This URL will allow us to define the initial page according to the URL. 
The `Key` part is something a bit special: we need to store it inside our model because it will be needed to use some functions of the [`Browser.Navigation` module](https://package.elm-lang.org/packages/elm/browser/latest/Browser-Navigation).

You now have all you need to handle the routing in our application!

## What you need to do

According to the page, you need to change the view... That means that your page should be stored inside the model. In your `init` function, you should check what the [`URL` object](https://package.elm-lang.org/packages/elm/url/latest/Url#Url) contains to store the proper page inside the model, along with the key.

For that, our model has evolved:

```elm
type Page
    = HomePage
    | CategoriesPage (RemoteData (List Category))


type alias Model =
    { key : Key
    , page : Page
    }
```

As you can see, our list of categories is now directly stored inside our `Page`, because we don't need that data when the page is loaded.

After that, you need to handle a few things:

 - When a link is clicked, an `OnUrlRequest` message is triggered, containing a [`UrlRequest` object](https://package.elm-lang.org/packages/elm/browser/latest/Browser#UrlRequest). If you follow that link, you can see that it can either be an `External` link (targeted on another domain), or an `Internal` link.
 - If it is an `External` link, we want to navigate to the external page with the [`Browser.Navigation.load` function](https://package.elm-lang.org/packages/elm/browser/latest/Browser-Navigation#load).
 - It it is an `Internal` link, we want to add that entry to the browser history with the [`Browser.Navigation.pushUrl` function](https://package.elm-lang.org/packages/elm/browser/latest/Browser-Navigation#pushUrl).
 - This  will trigger a `OnUrlChange` message with the new `Url` ; you need to change the `Page` inside our model according to the new URL
 - In the view function, you need to display the proper page according to the model (`displayHomePage` or `displayCategoriesPage`). 
 
__Small reminder:__ if during init or `OnUrlChange` the new page is the categories page, you also need to load the categories!

__Notice:__ we will navigate using hash strategy, that means our URLs will be `http://localhost:8080/` and `http://localhost:8080/#categories`. Because of that, you need to react to the `fragment` part of the `URL` object.

## Let's start!

[See the result of your code](./Routing.elm) (don't forget to refresh to see changes)

Once the tests are passing, you can go to the [next step](../Step11).







