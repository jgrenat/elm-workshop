# Étape 10 : La page des catégories (fin)

## Objectif

C'est bien beau d'avoir le résultat sous forme de `String`, mais ce serait quand même mieux de l'avoir sous forme de `List Category`, non ? C'est l'objectif de cette étape !


## Les Decoders JSON

Elm se targue d'éviter toute erreur au *runtime*, et cela provient en grande partie de son système de types. Alors comment concilier cela avec des formats de données comme le JSON, qui sont par essence très permissifs ?
Cela passe par une étape de validation de la structure de ce JSON, via ce qu'on appelle des `Decoder`.

Décoder un JSON en type Elm, c'est décrire la totalité ou une partie de la structure d'un JSON.

Par exemple, pour le JSON `{ firstname: "John", lastname: "Doe", birthYear: 1987 }` on pourrait indiquer qu'on s'attend à un champ `firstname` contenant un `String` et un champ `birthYear` contenant un `Int`. 
Si on n'a pas besoin de `lastname`, il n'est pas nécessaire de le décrire. 

Un tel décodeur pourrait être défini ainsi, grâce au module [Json.Decode](http://package.elm-lang.org/packages/elm-lang/core/latest/Json-Decode) :

```elm
import Json.Decode as Decode exposing (int, map2, field, string)

type alias User = 
    { firstname : String
    , birth : Int 
    } 

userDecoder : Decode.Decoder User
userDecoder =
    Decode.map2 
        User 
        (Decode.field "firstname" Decode.int) 
        (Decode.field "birthYear" Decode.int)
```

On voit qu'ici on utilise `map2` pour dire qu'on va décrire deux champs. `User` est utilisé comme fonction pour créer notre entité à partir des deux champs trouvés.
On indique ensuite comment trouver nos deux champs dans le JSON, en indiquant qu'on cherche d'abord un champ `firstname` de type `String`, puis un champ `lastname` de type `Int`.

Alors comment utiliser ce décodeur ensuite ? En se servant de la fonction [`decodeString`](http://package.elm-lang.org/packages/elm-lang/core/latest/Json-Decode#decodeString) :

```elm
jsonString : String
jsonString =
    "{ firstname: \"John\", lastname: \"Doe\", birthYear: 1987 }"

decodedUser : Result String User
decodedUser =  
    Decode.decodeString userDecoder jsonString
```

Comme vous pouvez le voir, cette fonction retourne un `Result`, ce qui vous oblige à gérer les cas où le JSON est mal formé : c'est un grand pas en avant pour éviter les *runtime errors* !


## Quelques astuces

Vous avez maintenant tout ce qu'il vous faut pour décoder notre `String` en une `List Category`, mais voici quelques petites pistes :

 - En remplaçant [`Http.getString`](http://package.elm-lang.org/packages/evancz/elm-http/3.0.1/Http#getString) par [`Http.get`](http://package.elm-lang.org/packages/evancz/elm-http/3.0.1/Http#get), vous pouvez directement fournir en second argument un `Decoder` pour tenter de décoder le contenu reçu  
 - Ici, vous ne décodez pas une seule catégorie, mais une liste de catégories. Je vous laisse explorer le module [`Json.Decode`](http://package.elm-lang.org/packages/elm-lang/core/5.1.1/Json-Decode) à la recherche d'une fonction pour vous aider !
 - Attention, si vous regardez bien le JSON retourné par l'API, il est de la forme `{ "trivia_categories": [...] }`. Il vous faudra donc wrapper votre décodeur en conséquence :

```elm 
getCategoriesDecoder = 
        Decode.field "trivia_categories" categoriesListDecoder
```

## Let's start!

[Lien vers le rendu](./index.html) (pensez à actualiser pour voir vos changements)


<div style="text-align: right;"><a href="../Step11">Étape suivante --&gt;</a></div>









