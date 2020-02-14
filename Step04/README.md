# Step4: Categories List

## Goal

This new page should list the available categories of questions. It will be done with several steps as there are many new concepts to apprehend.

This time, by going to `CategoriesPage.elm`, you will see that the page has a compilation error! Indeed, the list of categories is declared in the code in the following manner:

```elm
categories : List Category
categories =
    [ 
    -- list of categories
    ]
```

By looking at the type annotation, we can see that it's a list of elements, which are of type `Category`... but this type doesn't exist! This will be your mission for this step: make the code compile by creating the `Category` type.

It should contain two fields:

 - `id` of type `Int`
 - `name` of type `String`
 

## Wait... How can we create a type?

If you don't remember how to create a new type, here are two links to the documentation. 
Be careful, there are two ways to declare a type which are not equivalent, choose wisely!

 - [Custom Types](https://guide.elm-lang.org/types/custom_types.html)
 - [Type Aliases](https://guide.elm-lang.org/types/type_aliases.html)
  

## Let's start!

[See the result of your code](./CategoriesPage.elm) (don't forget to refresh to see changes)

Once the page compiles, you can go to the [next step](../Step05).
