# Étape 13 : La page de jeu (suite)

## Objectif

On sait maintenant afficher une question, on va maintenant récupérer la liste des questions sur l'API Trivia. 
Par défaut, on va chercher cinq questions de catégories diverses, en limitant juste aux questions à choix multiple. Voici donc l'URL à contacter : `https://opentdb.com/api.php?amount=5&type=multiple`.

Le format de sortie est le suivant, comme vous pouvez le voir :

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

On n'a pas besoin de toutes les informations, puisque notre modèle contient seulement trois champs :

```elm
type alias Question =
    { question : String
    , correctAnswer : String
    , answers : List String
    }
```

Attention par contre, notre `answers` ne correspond pas à la clé `incorrect_answers` du JSON, mais à la liste de toutes les réponses, bonne y compris. Pour cela, il faudra trouver un moyen de rajouter la bonne réponse à la liste lors du décodage ; [peut-être en cherchant dans la documentation du module `Decode`](http://package.elm-lang.org/packages/elm-lang/core/latest/Json-Decode)...
Faites simple et ajoutez la bonne réponse au début de la liste des réponses. Cela signifie que la première réponse affichée sera toujours la bonne, mais nous corrigerons ce défaut un peu plus tard.

## Un nouveau modèle

Si vous regardez bien le code, on a un nouveau modèle :

```elm
type alias Model =
    { game : RemoteData Game
    }

type alias Game =
    { currentQuestion : Question
    , remainingQuestions : List Question
    }
```

On remarque que les questions ont été mises dans un type Game, et séparées en deux : la question actuelle et les questions restantes (qui ne contient pas la question actuelle).

Ce choix peut sembler curieux, nous allons donc voir les alternatives pour comprendre ce qui nous a amené à le faire.


### Alternative 1

La première alternative est la suivante :

```elm
type alias Game =
    { currentQuestion : Int
    , questions : List Question
    }
```

On stocke une liste de questions ainsi que l'index de la question courante. Si ce modèle est totalement fonctionnel, il pose cependant un énorme défaut : il est possible d'avoir des états dits "impossibles".

Par exemple, imaginons que pour une raison inconnue, on a 5 questions dans notre liste, et que l'index `currentQuestion` vaut 6. Cet état n'est pas possible et ne doit pas se produire dans l'application. Il faudrait donc faire toujours attention à ne pas modifier le modèle de façon à ce qu'il devienne incohérent. C'est un risque. 
Le mieux serait d'éviter au maximum ces incohérences en construisant notre modèle de façon à ce qu'elles deviennent impossibles.


### Alternative 2

```elm
type alias Game =
    { remainingQuestions : List Question
    }
```

Ici, on stocke uniquement les questions restantes, la première étant la question courante. Une fois la question répondue, on la retire du tableau et la question en première position devient la question courante.

On corrige le problème de l'index non compris dans le tableau. Oui mais que se passe-t-il lorsque le tableau est vide ? Dans ce cas on n'a pas de question courante, ça ne peut vouloir dire qu'une chose : notre `Game` est terminé, et on ne devrait même pas être sur la page de jeu ! De nouveau, notre modèle peut être incohérent si une erreur est commise par le développeur !


### Notre solution

Avec notre solution, on a donc la question courante stockée à part, qui ne peut pas être nulle. On stocke également les questions restantes. Une fois la question courante répondue, on peut dépiler la première question restante et la mettre dans la variable `currentQuestion`. 

Mais que se passe-t-il quand le tableau est vide ? Eh bien le compilateur va nous forcer à gérer le cas, et empêchera de lui-même un état incohérent !

En Elm, **le système de types est puissant**, exploitez-le au maximum pour qu'il vous simplifie la vie !


## Instructions

Assez de blabla, passons à la pratique ! Voici les instructions :

 - Les questions doivent être chargées au chargement de le page
 - Tant qu'elles sont en cours de chargement, le texte "*Loading the questions...*" apparaît
 - Si une erreur se produit, le texte "*An unknown error occurred while loading the questions.*" apparaît
 - Une fois les questions chargées, la première question est affichée
 

## Let's start!

[Lien vers le rendu](./index.html) (pensez à actualiser pour voir vos changements)


<div style="text-align: right;"><a href="../Step14">Étape suivante --&gt;</a></div>









