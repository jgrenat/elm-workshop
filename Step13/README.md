# Step 13: Game page

## Goal

We know how to display a question, now we need to get the list of questions from the Trivia API.
By default, we will get 5 questions of any category, filtering to only keep multiple choices questions. This is the URL you will need to call: `https://opentdb.com/api.php?amount=5&type=multiple`.

As you can see, it returns an answer with the following format:

```js
{
  results: [
    {
      category: "Science & Nature",
      type: "multiple",
      difficulty: "medium",
      question: "To the nearest minute, how long does it take for light to travel from the Sun to the Earth?",
      correct_answer: "8 Minutes",
      incorrect_answers: [
        "6 Minutes",
        "2 Minutes",
        "12 Minutes"
      ]
    },
    // [...]
  ]
}
```

We don't need all these informations, because our model contains only three fields:

```elm
type alias Question =
    { question : String
    , correctAnswer : String
    , answers : List String
    }
```

Be careful, our `answers` field does not exactly match the `incorrect_answers` field of the JSON response, because it also contains the correct answer. That means you will need an extra step in the decoder to compute this field, maybe you will find a way in the [`Json.Decode` module documentation](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode)...

Let's keep it simple by adding the correct answer at the head of the list, meaning that the first answer displayed will always be the correct one. We will fix that flaw later.

## A new model

By looking at the code, you can see a new model:

```elm
type alias Model =
    { game : RemoteData Game
    }

type alias Game =
    { currentQuestion : Question
    , remainingQuestions : List Question
    }
```

As you can see, the questions have been stored inside a new `Game` type and are split in two: the current question and a list of remaining questions (that does not contain the current question).

This choice can seem weird, so let's see what are the alternatives to better understand it:

### Alternative 1

The first alternative is the following one:

```elm
type alias Game =
    { currentQuestion : Int
    , questions : List Question
    }
```

We're keeping all the questions in a list and only storing the index of the current question. That model could work, but it has a main flaw: it's possible to represent **impossible states**.

For example, let's imagine that for an unknown reason, we have 5 questions in our list and that our `currentQuestion` index is 6. This state is not possible and should not happen in the application. That means we need to make sure that we will never set this value to an invalid number. What if we don't have to, because the model does not allow this? 

If you look at the retained model, you can't have such an impossible case! 


### Alternative 2

```elm
type alias Game =
    { remainingQuestions : List Question
    }
```

Here, we're only keeping the remaining questions, and by convention the first one is the current question. Once this question has been answered, it is removed from the list and the next question become the current one.

That way, we're not subject to the wrong index problem ; but what happens when the list is empty? We do not have a current question anymore, which means only one thing: our `Game` is finished and we should not even be on the game page!

Once again, our model allow impossible states!


### Our solution

With our solution, the current question is always defined and cannot be null. When we answer it, we can take the new current question from the list, and if it is empty, the Elm compiler will force us to handle the case! 

In Elm, **the type system is really powerful**, use it and it will ease your life!


## Instructions

No more talking, let's practice! Here is what you need to do:

 - Load the questions at page load
 - While they are loading, the text "*Loading the questions...*" should be displayed
 - If there is an error, the text "*An unknown error occurred while loading the questions.*" should be displayed
 - Once the questions are loaded, the first question is displayed
 


## Let's start!

[See the result of your code](./GamePage.elm) (don't forget to refresh to see changes)

Once the tests are passing, you can go to the [next step](../Step14).