# Step 15: Run the Game!

## Goal

Now that the game page is integrated to  everything else, we can go back to it and allow the user to answer the questions and get its score!

## Instructions

 - When a use click on a response, the next question is displayed and its result is stored inside the model. 
 - When all questions have been answered, the user is redirected to the `#result/{score}` page.

## Let's start!

[See the result of your code](./Main.elm) (don't forget to refresh to see changes)

Once the tests are passing, you are done with this workshop!

However you can add some things to your application:

 - Shuffle the answers because now the first one is always the correct one
 - Save the score inside the local storage (search for how to use `ports`)