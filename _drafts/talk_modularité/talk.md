# Les applications modulaires permettent de scaler en RH + perf

## Pitch

### De quoi ça parle ?

D'app modulaires, qu'est-ce que c'est que la modularité, comment l'atteindre, qu'est-ce que ça apporte -> scaler en RH + perf

### À qui je m'adresse ?

À des membres de dev team et des coordinateurs/managers, des CTO.
Ils ont déjà travaillé dans des contextes où les teams ont du mal à paralléliser et à coordonner leurs efforts pour livrer de la valeur métier.
Ils travaillaient alors sur du code commun ou sur des applications/modules fortement couplés.
Dans ces contextes, la MEP est un évènement, demande la coordination de toutes les équipes et un déploiement global de la plupart des composants du système.
Ils ont observé que ça ne fonctionnait pas aussi bien que ça pourrait.

### De quoi je veux convaincre ?

Je veux les convaincre que rendre nos applications/systèmes modulaires permet de scaler en RH ainsi qu'en charge d'utilisation utilisateur (perf).
Pour ça, je souhaite leur donner ma définition de :
* scaler
* module
* couplage/découplage
* Archi hexagonale
* API
* Bounded context
* (cohésion)
* système distribué
* système monolithique

## Plan

1. 





## brainstorm area

De quoi je veux parler ?

D'applications modulaires.

Qu'est-ce qu'un module.

C'est une extension facultative à un système autonome.

L'ajout d'un module au système ajoute une ou plusieurs fonctionnalités à ce système.

L'ajout d'un module est facile et simple (plug-n-play but not hack-n-grrrrr).

Un module est une encapsulation de fonctionnalités.

Le module expose ses fonctionnalités par des interfaces.

Le système accède aux fonctionnalités d'un module par ses interfaces.

Le système utilise les fonctionnalités de ses modules et en devient donc dépendant.

On ne peut alors plus supprimer le module sans affecter les fonctionnalités du système.

C'est toujours le système qui utilise les fonctionnalités du module, mais jamais le module qui appelle des fonctionnalités du système. Sinon, ce n'est pas un système modulaire, mais un seul et même système local. Et s'il y a du réseau entre les 2, c'est en plus un système distribué, avec toutes les complications que ça apporte.

Toute dépendance cyclic entre le système et un module indique que le module devrait plutôt faire partie du système.

Toute dépendance cyclic entre 2 modules indique que ce devrait plutôt être un seul module.

L'existence d'un module a au moins 2 origines :
* Il a été créé en tant que tel
* Il a été extrait d'un système existant

Tout système autonome peut être module d'un autre, à condition qu'il expose ses fonctionnalités à travers des interfaces, et qu'il n'ait pas de dépendance vers l'autre système. 

Bon on est ok sur le concept de module.

Mais en fait on n'a même pas encore parlé de software // Maintenant on peut parler de software

Nos applications sont-elles intrinsèquement modulaires ?

Non bien sûr. Les contraintes permettant la modularité, qu'on vient d'évoquer ne s'appliquent pas d'elles-mêmes.

Il faut produire de l'effort pour les appliquer.

Alors, pourquoi dépenser cet effort, non gratuit ?
Pourquoi se contraindre à rendre nos applications/systèmes modulaires ?

Il y a selon moi au moins 2 sortes de contraintes :
* Celles que l'on choisit de s'imposer. Exemples : 
  * Dépendre des interfaces plutôt que de leurs implémentations
  * Faire des tests auto
* Celles qui finissent par s'imposer d'elles-mêmes. Exemple :
  * Déployer seulement 1 fois par mois de 20 h à minuit, après 2 semaines de tests e2e manuels

Si on s'était imposé les 2 premières, alors la 3ᵉ ne serait peut-être pas venu s'imposer.

Autrement dit : En s'imposant délibérément et judicieusement des contraintes, on peut s'en éviter des mauvaises.

Je repose donc la question : Pourquoi se contraindre à rendre nos applications/systèmes modulaires ?

Réponse : Parce que ces contraintes-là sont reconnues pour éviter celles qui torture les projets IT depuis toujours. 

Trouvons-en quelques-une.

Pour ça, souvenons-nous d'un bon gros monolith distribué comme on en connait tous, voire qu'on a même participé à faire émerger ainsi.
Plusieurs bounded contexts y sont dispersés.
Leur logique est à droite à gauche, dans le front, dans la base de données, dans des procstock.
La modélisation métier est faite en partie en base de données.
Il y a de la logique métier en base de données, voire en procédure stockée.
Il y a peu d'interfaces, les morceaux de code s'appellent les uns les autres au travers de tout le système.
Les fonctionnalités exposées ne sont pas versionnées.

Autre chose vous vient en tête sur un monolith distribué que vous avez connu ?

Alors, quels sont les contraintes et leurs effets qui vont venir s'imposer dans ce système ?

* Chaque développeur doit connaitre la totalité du système pour y apporter un changement
  * Effet : leur charge mentale déborde
    * Effet : burnouts
    * Effet : perte d'implication
    * Effet : perte de productivité
    * Effet : Ils font des erreurs
      * Effet : Le système se dégrade davantage
      * Effet : Le confiance se dégrade
* Effet : Le système est difficile à tester automatiquement
  * La couverture des fonctionnalités est loin des 100%
    * Le déploiement fait peur
      * On déploie moins souvent
        * La réactivité business s'effondre
          * Si un concurrent est meilleur alors c'est la fin
    * Le refacto fait peur
      * Le code se dégrade
        * Changer le code devient difficile
          * La réactivité business s'effondre
            * Si un concurrent est meilleur alors c'est la fin
Bref : on perd de la satisfaction et de l'argent. 

Ces effets sont dramatiques non ?



--------
Ils sont même à l'opposé des objectifs fondamentaux des organisations qui font du software, c'est à dire :
Ils amènent d'ailleurs à la question : C'est quoi les objectifs fondamentaux des acteurs d'un logiciel ? Je vous propose ceux-là :


* Job satisfaction
* organizational performance (financial benefits, competitiveness, business responsiveness)
* non-commercial performance (employee satisfaction, quality of product, customer satisfaction, environmental and societal ethics)

* less burnout
* less deployment pain
* less rework

Qui sait où j'ai été prendre ces objectifs ?

Bien vu : Accelerate

C'est à la fois un livre et une publication scientifique dans laquelle les auteurs ont analysé quelles pratiques Lean et Devops sont appliquées chez les organisations qui performent, ainsi que les corrélations entre ces pratiques et ces objectifs habituels des organisations.
