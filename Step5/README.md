# Étape 5 : La page des catégories

## Objectif

Cette page doit lister l'ensemble des catégories de jeu. Nous allons procéder par étape, puisque cette page est un peu complexe.

Cette fois, en vous rendant sur `index.html`, vous verrez que la page ne compile pas ! En effet, je déclare la liste des catégories de cette façon :

```elm
categories : List Category
categories =
    [ 
    -- list of categories
    ]
```

En regardant l'annotation de type, on voit que j'indique qu'il s'agit d'une liste d'éléments du type `Category`... Or ce type n'existe pas ! Ce sera votre mission pour cette étape : faire compiler le code en créant le type `Category`

Celui-ci contient deux champs :

 - `id` de type `Int`
 - `name` de type `String`
 

## Mais comment on déclare un type ?

Si vous ne vous souvenez plus comment déclarer un type de variable, voici des liens vers la documentation. Attention il y a deux manières de déclarer un type, choisissez la bonne !

 - [Union Types](https://guide.elm-lang.org/types/union_types.html)
 - [Type Aliases](https://guide.elm-lang.org/types/type_aliases.html)
  

## Let's start!

[Lien vers le rendu](./index.html) (pensez à actualiser pour voir vos changements)


<div style="text-align: right;"><a href="../Step6">Étape suivante --&gt;</a></div>