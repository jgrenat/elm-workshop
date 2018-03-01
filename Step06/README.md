# Étape 6 : La page des catégories (suite)

## Objectif

Maintenant qu'on a nos catégories qui compilent, affichons-les ! 

<img alt="Screenshot of the page to realize" src="../images/step6.png" style="width: 100%; border: 1px solid black;">

Le code HTML est très basique :

```html
<div>
    <h1>Play within a given category</h1>
    <ul class="categories">
        <li>
            <a class="btn btn-primary" href="#game/category/9">
                General Knowledge
            </a>
        </li>
        <!-- ... -->
        <li>
            <a class="btn btn-primary" href="#game/category/32">
                Entertainment: Cartoon &amp; Animations
            </a>
        </li>
   </ul>
</div>
```

On a déjà affiché du HTML à plusieurs occasions, mais ici, on part du principe qu'on ne connait pas le nombre de catégories, et qu'on ne pas donc pas les afficher une à une.

Votre réflexe de développeur doit immédiatement vous souffler à l'oreille "*Faisons une boucle*" mais Elm ne possède pas de boucles ! 

En revanche, il s'agit d'un langage fonctionnel, et il permet donc d'effectuer des opérations sur des listes pour les transformer.

En y réfléchissant, c'est exactement ce qu'on veut faire : transformer notre liste de `Category` en listes de `li` correspondant à la catégorie.

Une fois cette liste transformée, on peut directement l'utiliser comme second argument d'une fonction `ul` pour obtenir le rendu souhaité.

La fonction permettant de transformer notre liste est `List.map` et vous pouvez [trouver sa documentation ici](http://package.elm-lang.org/packages/elm-lang/core/latest/List#map). Comme vous pouvez le voir, `List.map` attend en premier argument une fonction de transformation, et en second argument la liste :

```elm
numbers : Int
numbers = 
    [1, 2, 3, 4, 5]

toSquare : Int -> Int
toSquare number =
    number * number
    
-- Contains [1, 4, 9, 16, 25]
squaredNumbers : Int
squaredNumbers = 
    List.map toSquare numbers 
``` 
 

## Let's start!

[Lien vers le rendu](./index.html) (pensez à actualiser pour voir vos changements)


<div style="text-align: right;"><a href="../Step07">Étape suivante --&gt;</a></div>