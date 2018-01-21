# Étape 9 : La page des catégories (suite)

## Objectif

Beaucoup de théorie dans ces dernières étapes et on a un peu négligé notre page des catégories. La raison est toute simple : nous allons maintenant charger nos catégories via une API et donc mettre en place une requête HTTP... donc un effet ! 

Mais vous êtes maintenant parés pour ça !

Si vous ouvrez CategoriesPage, vous voyez que maintenant, notre page des catégories suit The Elm Architecture. De plus, les catégories ne sont plus présentes en dur dans le code, et elles ne s'affichent plus !

Votre objectif sera donc de récupérer cette liste des catégories via l'[API Trivia](https://opentdb.com/api_config.php). Un simple GET sur l'adresse [https://opentdb.com/api_category.php](https://opentdb.com/api_category.php) suffit pour obtenir ce qu'on souhaite.

Remarquez aussi que notre modèle est uniquement composé d'une clé `categories` de type `RemoteData String`. Il s'agit d'un union type défini plus haut, qui permet représenter notre requête HTTP en précisant si elle est en cours, en erreur ou terminée avec succès (auquel cas elle stocke la réponse). Ici, on stocke un `String` et non pas une `List Category` pour des raisons de simplifications.


## Instructions 

 - Au chargement de la page, vous devez déclencher une requête HTTP pour récupérer la liste des catégories
 - Cette requête va récupérer le résultat sous forme d'une chaine de caractères contenant du JSON
 - Pendant le chargement, l'écran affiche le titre et le message "*Loading the categories...*"
 - En cas d'erreur dans la requête, l'écran affiche le titre et le message "*An error occurred while loading the categories*"
 - En cas de succès, l'écran affiche le titre et le résultat de la requête sous forme de chaine de caractères
 
 
## Les requêtes
 
De la même façon que pour générer un nombre aléatoire, les requêtes HTTP sont un effet qui doit donc être passé par les Commands. 
Pour les besoins des tests, on utilisera le module `Testable.Http`, mais le fonctionnement est identique au module standard `Http` utilisé habituellement.

Il vous faudra d'abord créer une requête avec la fonction [Http.getString](http://package.elm-lang.org/packages/elm-lang/http/1.0.0/Http#getString). 

Une fois cela fait, vous pouvez créer une Command avec la méthode [Http.send](http://package.elm-lang.org/packages/elm-lang/http/1.0.0/Http#send). 
Pour cette fonction, le premier argument est de type `Result Error String -> Msg`, soit une fonction qui prend un `Result Error String` en argument et retourne un message. Ca tombe bien, c'est exactement la signature de notre constructeur de message `OnCategoriesFetched` !

Petite aide : le type `Result error a` est défini dans le module `Result` de la façon suivante :

```elm
type Result error value
    = Ok value
    | Err error
```

Cela devrait suffire à l'exploiter dans un `case...of`, mais vous pouvez trouver davantage de documentation [en cliquant sur ce lien](http://package.elm-lang.org/packages/elm-lang/core/latest/Result).


## Contexte des tests

Pour pouvoir vous aidez davantage avec les tests, j'ai remplacé certains modules par leur version dans le package `Testable`. 
C'est notamment le cas des commandes, ne vous étonnez donc pas de voir `Testable.Cmd.none` au lieu de `Cmd.none`.


## Let's start!

[Lien vers le rendu](./index.html) (pensez à actualiser pour voir vos changements)


<div style="text-align: right;"><a href="../Step10">Étape suivante --&gt;</a></div>









