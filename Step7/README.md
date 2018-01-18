# Étape 7 : The Elm Architecture

## Objectif

Prenons une pause au niveau de la page des catégories pour aborder *The Elm Architecture (TEA)*. Attention, il y a un peu de lecture sur cette étape, mais c'est pour mieux vous préparer à la suite !

A force de développer des applications web, les développeurs Elm se sont rendu compte qu'ils appliquaient toujours le même pattern, qui fut ensuite standardisé sous le nom de TEA.

Une application web est un programme qui a besoin de trois éléments : 

 - un modèle, contenant l'état de l'application
 - une fonction de rendu, qui prend en paramètre ce modèle et retourne du HTML (entre autres) ; ce HTML peut émettre des messages
 - une fonction d'update, qui prend en paramètres le modèle actuel, un message, et retourne le nouveau modèle
 
Le cycle d'une application est donc le suivant :

 - On crée un programme en lui donnant un modèle initial, une fonction de vue et une fonction d'update
 - La fonction de vue génère le HTML initial
 - Un évènement se produit qui génère un message (clic utilisateur, timer, réponse à une requête HTTP, ...)
 - Ce message est envoyé à la fonction d'update qui génère un nouveau modèle
 - La fonction de vue génère le HTML correspondant au nouveau modèle
 
<img alt="The Elm Architecture illustration" src="../images/step7-tea.png" style="width: 100%; border: 1px solid black;">

## L'exemple du compteur

Cette architecture, vous l'avez déjà vue avec le compteur dans la première étape. Voici le code commenté pour que vous puissiez replacer chacun des éléments : 

```elm
module Counter exposing (..)

import Html exposing (Html, button, span, text, div)
import Html.Events exposing (onClick)


-- Here we create the program with an initial model (the Int `O`), 
-- a `view` function and an `update` fonction
main =
    Html.beginnerProgram { model = 0, view = view, update = update }

-- Here we are creating a union type representing all the message 
-- our application can receive
type Msg
    = Increment
    | Decrement 


-- The update function take a message and a model as arguments 
-- to return the new model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1


-- The view function just create the proper HTML according 
-- to the model
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , span [] [ text (toString model) ]
        -- Thanks to `onClick` we can generate a message when 
        -- the user clicks on this button
        , button [ onClick Increment ] [ text "+" ]
        ]

```


## Passons à la pratique

Avant de mettre en place cette architecture sur notre page de catégories, un peu de pratique avec un exemple plus simple : une page demandant si l'utilisateur est majeur ou non et qui affiche un message correspondant.

<img alt="The Elm Architecture illustration" src="../images/step7-tea.png" style="width: 100%; border: 1px solid black;">

Un exemple de l'application [peut être trouvé ici](https://underage-or-adult.surge.sh/).


### Modèle 

Le modèle de l'application va contenir une seule valeur, représentant la seule donnée de notre application : le choix de l'utilisateur.

Or, quand l'application charge, l'utilisateur n'a encore fait aucun choix, donc cette valeur ne doit pas être définie. On pourra choisir une valeur par défaut, mais le but est de ne pas afficher de message si l'utilisateur n'a encore rien indiqué.

JavaScript a résolu ce problème en introduisant `null` et `undefined`... Et en introduisant également par la même occasion ces *magnifiques* erreurs :

```js
const user = null;
user.name;
// VM245:1 Uncaught TypeError: Cannot read property 'name' of null

let myFunction;
myFunction();
// Uncaught TypeError: myFunction is not a function
``` 

Il est très difficile en JavaScript d'être certain de ne pas avoir ce genre d'erreurs en production. En Elm, il a été décidé de ne pas avoir de `null` ou d'`undefined`.

Alors comment représenter une valeur vide ? Pour cela on va utiliser un [union type](https://guide.elm-lang.org/types/union_types.html) `UserStatus` qui pourra avoir trois valeurs : NotSpecified, UnderAge et Adult. L'avantage est que le compilateur va nous forcer à gérer tous les cas !

Ensuite, une structure `case...of` (déjà vu dans l'exemple du compteur) nous permettra d'afficher le message que l'on souhaite. Un petit exemple avec un autre union type :

```elm 
type ShirtSize = Large | Medium | Small

displayShirtSize : ShirtSize -> Html Msg
displayShirtSize size = 
    case size of
        Large -> 
            text "Large size"
        Medium ->
            text "Medium size"
        Small ->
            text "Small size"
```


### Messages

Un [union type](https://guide.elm-lang.org/types/union_types.html) `Msg` est déjà défini contenant le seul message qu'on a à gérer, `UserStatusSelected`, qui prend en argument un `UserStatus`, un autre union type défini par nous.


## Update et View

Ces deux fonctions ont été créées mais nécessitent quelques changements, à vous de faire passer les tests !


## Let's start!

[Lien vers le rendu](./index.html) (pensez à actualiser pour voir vos changements)


<div style="text-align: right;"><a href="../Step8">Étape suivante --&gt;</a></div>