# Étape 8 : The Architecture Elm (suite)

## Objectif

Nous avons pu voir l'architecture Elm dans la précédente étape. Comme vous avez pu le voir, on déclare notre programme de la façon suivante :

```elm
main =
    beginnerProgram { model = initialModel, view = view, update = update }
```

Cette fonction `beginnerProgram` est en réalité une version simplifiée de la fonction `program`, qui est vraiment utilisée pour développer des applications web plus complexes.

Il y a deux différences principales : 

 - On peut communiquer avec du code JavaScript 
 à travers les subscriptions `Sub` et les commandes `Cmd` 
 - On peut provoquer des *effets* à travers les `Cmd`
 
Le second point mérite quelques explications. En Elm, il est impossible de provoquer ce qu'on appelle des *effets* dans son code. 
 
En effet, toutes les fonctions sont pures, cela signifie que le retour d'une fonction ne dépend *que* de ses paramètres et qu'elle ne modifie rien à l'extérieur de cette fonction. Cela permet d'avoir une sécurité 
 
Dans ces conditions, on ne peut pas générer nous-même des nombres aléatoires, puisque deux appels à la même fonction génèreraient des nombres différents ! Il en va de même pour ce qui est de stocker des données dans le `localStorage`, ou même exécuter des requêtes HTTP !
 
C'est là que les commandes (`Cmd` dans Elm) interviennent ! Celles-ci nous permettent de dire au Elm runtime : "Je souhaite provoquer un effet, voici ce que tu dois faire et le message dans lequel me retourner le résultat". 
 
C'est ainsi le Elm runtime qui va se charger d'exécuter ces effets et nous rappeler avec le résultat.


## Un exemple avec un Random Number

Je vous invite à ouvrir le fichier RandomNumber.elm, autant dans le navigateur Elm-reactor quand dans votre IDE. J'ai annoté le code avec des numéros pour pouvoir commenter plus facilement.

On voit qu'on déclare un programme en `(1)` avec un quatrième élément, qui correspond aux *Subscriptions* `(2)`. C'est par là qu'on passerait si on souhaitait recevoir des messages d'un code JavaScript. En l'occurence, ce n'est pas le cas, donc on retourne simplement `Sub.none` pour l'indiquer.

On voit ensuite en `(3)` que nos fonctions d'*init* et d'*update* ont des signatures différentes, puisqu'au lieu de renvoyer un `Model`, elles renvoient un tuple `( Model, Cmd Msg )`. C'est en effet par là qu'on va pouvoir envoyer des effets au Elm runtime pour qu'il les exécute.

Dans le cas du model initial, on n'a pas besoin de provoquer d'effet, donc on retourne `Cmd.none`. Notez au passage qu'on utilise notre type Model comme une fonction pour créer notre modèle (`Model 0`).

Notre fonction *view* est assez classique, mais on peut remarquer qu'un clic sur le bouton en `(4)` va envoyer un message pour demander la génération d'un nombre aléatoire.

Ce message passe dans notre fonction d'update en `(5)` où on ne modifie pas le model (puisqu'on le retourne tel quel), mais par contre on retourne une commande :

```elm
Random.generate OnNumberGenerated (Random.int 0 10)
```

`Random.generate` retourne une commande qui indique au Elm runtime qu'on souhaite générer une valeur aléatoire. Le second argument, `Random.int 0 10` indique que cette valeur est un entier entre 0 et 10, et le premier argument `OnNumberGenerated` est le message via lequel cette valeur doit nous être envoyée.

On attend d'ailleurs en `(6)` cette fameuse valeur pour la stocker dans notre modèle actuel. Plus besoin d'effet, donc on retourne `Cmd.none` avec.


## Let's start!

Heu... en fait non ! Cette étape n'était que de la théorie. Mais qu'à cela ne tienne, on va enfin pouvoir repasser à la pratique sur les catégories !


<div style="text-align: right;"><a href="../Step9">Étape suivante --&gt;</a></div>