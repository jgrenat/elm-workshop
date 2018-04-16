# Étape 15 : Défiler les questions

## Objectif

Notre page de jeu est maintenant intégrée à l'ensemble ! Si vous n'avez pas stocké votre `Game` directement dans la route, prenez le temps de regarder le code dans cette étape pour voir comment nous avons procédé.
Garder le jeu dans la route permet de conserver la cohérence de notre modèle.

Nous allons maintenant autoriser l'utilisateur à répondre aux questions et à voir son score !

## Instructions

 - Quand un utilisateur clique sur une réponse, il passe à la question suivante et son résultat pour cette question est stocké dans le modèle.
 Attention, pas de changement de page ici, on utilise le même procédé que dans le compteur à l'étape 1 !
 
 - Une fois une question répondue, l'utilisateur passe à la page suivante
 
 - Quand toutes les questions ont été répondues, l'utilisateur est redirigé vers `#result/{son-score}`
 
 
## Un fichier moins *chargé*

Comme vous pouvez le voir, on a ici plusieurs fichiers. Les méthodes ont en effet été extraites dans plusieurs fichiers différents correspondant à leur fonction. On a ainsi séparé les types, les méthodes d'affichage, la fonction d'update, ce qui concerne le routing et les appels d'API. 

Cette séparation est suffisante pour un petit projet comme le nôtre. Sur des projets plus gros, on pourrait par exemple avoir une approche orientée composants avec un composant par page.

## Let's start!

[Lien vers le rendu](./index.html) (pensez à actualiser pour voir vos changements)


<div style="text-align: right;"><a href="../Step15">Étape suivante --&gt;</a></div>









