# Étape 3 : Concevons la page de résultat !

## Objectif

Nous allons maintenant réaliser la page de résultat. Celle-ci est très simple et peu dynamique, mais va nous permettre de voir une ou deux nouvelles notions.

<img alt="Screenshot of the page to realize" src="../images/step3.png" style="width: 100%; border: 1px solid black;">

Voici la structure que vous devez réaliser en HTML :

```html
<div class="score">
    <p>Your score: 3 / 5</p>
    <a class="btn btn-primary" href="#">Replay</a>
</div>
```

Pour cela, ouvrez le fichier `./ResultPage.elm` dans votre IDE et commencez à bidouiller le code pour obtenir le rendu désiré !


## Quelques pistes

Attention, comparé à avant, tous les imports n'ont pas été faits. Vous devrez donc rajouter ce qu'il vous manque aux imports du début de fichier. Pas de surprise, le nom de l'import correspond au nom de la balise que vous désirez utiliser !

```elm
-- Rajoutez vos imports de balises ici
import Html exposing (Html, beginnerProgram, div, iframe, text) 
-- Rajoutez vos imports d'attributs ici
import Html.Attributes exposing (class, src, style)
```

Vous aurez également besoin d'utiliser un argument à votre fonction resultPage. Celui-ci est un `Int` et vous aurez besoin de le convertir en `String` pour l'afficher. Peut-être qu'une [fonction sur ce lien](http://package.elm-lang.org/packages/elm-lang/core/1.0.0/Basics) pourra vous aider ! (*Pas besoin d'importer le module Basics, il est déjà importé par défaut dans vos programmes Elm.*)


## Let's start!
[Lien vers le rendu](./index.html) (pensez à actualiser pour voir vos changements)


<div style="text-align: right;"><a href="../Step4">Étape suivante --&gt;</a></div>
