# Étape 12 : Le routing

## Objectif

Nous avons déjà réalisé trois pages : la page d'accueil, la liste des catégories et la page de résultat ! Par contre, les liens entre ces trois pages ne fonctionnent pas. Nous allons maintenant voir comment intégrer le routing à notre application.

Pour cela, on va avoir besoin de deux packages différents :

 - [Navigation](http://package.elm-lang.org/packages/elm-lang/navigation/latest), pour intercepter les évènements relatifs à la navigation et nous permettre de les gérer
 - [URL parser](http://package.elm-lang.org/packages/evancz/url-parser/latest), pour construire et matcher nos URL de façon sécurisée

Commencez par les installer en utilisant le gestionnaire de packages Elm, sinon le code ne compilera pas :

```bash
elm-package install elm-lang/navigation
elm-package install evancz/url-parser
```

*Il ne faudra pas oublier d'importer ce dont vous avez besoin dans votre code Elm !*

## Workflow

Pour pouvoir intercepter les évènements, le module *Navigation* vient wrapper notre `Html.program` pour lui rajouter quelques fonctionnalités :

 - Nous permettre de changer l'URL
 - Émettre un message lorsque celle-ci change
 
Au chargement de notre application, Navigation va transmettre les informations sur l'URL actuelle à notre fonction d'init. C'est ensuite à nous d'en déduire une *page* de notre application grâce à *url-parser*.
Lors d'un changement d'URL, notre fonction `update` est appelée avec un message de changement de route, et on utilise de nouveau *url-parser* pour en déduire la nouvelle page.

Vous devez donc :

 - Créer la définition de nos routes
 - Créer un matcher pour transformer des URL en routes
 - Créer un message pour le changement de routes, et donc le gérer dans notre update
 - Utiliser [Navigation.program](http://package.elm-lang.org/packages/elm-lang/navigation/2.1.0/Navigation#program) au lieu de Html.program et donc modifier notre fonction d'`init`
 - Stocker la route courante dans l'URL
 

## Wooow... comment je fais tout ça ?

Commencez par créer un type pour vos routes. Un petit exemple pour un article de blog :

```elm
type Route
    = HomepageRoute
    | ArticlesRoute
    | ArticleRoute Int
```

Ici, la troisième route prend un paramètre qui représente l'ID de la route.

Ensuite, il faut créer un parser pour ces routes :

```elm
import UrlParser exposing (..)

matcher : Parser (Route -> a) a
matcher =
    oneOf
        [ map HomepageRoute top
        , map ArticlesRoute (s "articles")
        , map ArticleRoute (s "article" </> int)
        ]
```

Ici, on map les URL `/`, `/articles` et `/article/{articleID}`. Vous avez vous-même trois routes à mapper : la page d'accueil, la liste des catégories et la page des réponses, qui prend le score en paramètre.

Quand le module Navigation nous envoie une URL, ce sera en fait un objet `Location` qu'il faut donc transformer avec notre matcher :

```elm
import Navigation exposing (Location)
import UrlParser exposing (..)

parseLocation : Location -> Route
parseLocation location =
    case (parseHash matcher location) of
        Just route ->
            route

        Nothing ->
            -- Page non trouvée, on considère qu'on est sur la Home
            -- Dans un vrai projet, on créerait une page de 404.
            HomepageRoute 
```

Remplacez ensuite le `Html.program` par un `Navigation.program` et n'oubliez pas d'adapter la fonction `initialModel`. Attention, `Location.program` prend deux arguments, le premier étant un message pour nous renvoyer la `Location` quand celle-ci change, et le second étant l'équivalent de l'argument de `Html.program`.

Finalement, adaptez votre vue pour afficher la bonne page :)

Comme on ne peut pas jouer encore, j'ai simulé un lien vers la page de résultat.


## Let's start!

[Lien vers le rendu](./index.html) (pensez à actualiser pour voir vos changements)


<div style="text-align: right;"><a href="../Step12">Étape suivante --&gt;</a></div>









