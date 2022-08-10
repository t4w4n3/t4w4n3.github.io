1. Ça ne serait jamais arrivé dans un menhir

À qui je m'adresse :

Aux dev qui ont déjà connu un projet avec plusieurs applications qui communiquent par le réseau, fortement couplées, interdépendantes.
(un monolith distribué). Sur ce genre de projet, la moindre modification a des impacts potentiels fort sur tout le système et nécessite beaucoup de tests hauts dans la pyramide.
Le système ne peut être mis en prod que dans son entièreté, la mep est un évènement, demande une coordination et des go/no-go de toutes les teams.

C'est quoi l'objectif du talk :

Faire comprendre le concept de consistence.

Montrer que c'est la perte de consistence qui cause la plupart des problèmes de coordinations entre les équipes, et qu'elle-même est causée par la distribution du monolith à travers le réseau.
En effet, les transactions ne se propagent pas naturellement à travers le réseau sans passer par des patterns de transaction distribuées compliquées.
Or les transactions sont une forte source de consistence dans un système.

Montrer que dans un monolith, il est plus facile de garder la consistence des données que dans un système distribué.

Montrer que les termes utilisés dans ce genre de projet sont une mascarade (exemple : intégration continue, CI/CD).

Montrer que les solutions mises en place ne sont que des workarounds (exemple : mettre un monorepo pour contenir tout le système distribué ; cela partage par héritage (tout ou rien) plutôt que par composition (submodules))

1. Décrire un cas concret de système distribué
2. constat des problèmes/conséquences avec ce système
3. Est-ce réellement du microservice ?
4. Comment fait-on du MS
5. Pourquoi on est tout de même parti sur du MS
6. Y aurait-il eu une alternative ?
7. Oui : un monolith modulaire
8. Qu'est-ce que c'est un monolith modulaire ?
9. Quels sont les avantages ?
10. Comment scaler les team avec les modules d'un monolith
11. Les limites du monolith modulaire (volumétrie/scaling perf)

pyramide avec plusieurs pièces reliées par des couloirs labyrintesque VS Menhir

2. usecase-driven-development

3. Le vocabulaire est une échelle

4. The service everywhere antipattern in IOC frameworks
4. L'anti-pattern "tout est un service" dans les frameworks à inversion de contrôle

5. Le vocabulaire du chaos

* Complication
  ** Complication accidentelle
  ** Complication essentielle
  ** Complication nécessaire
* Complexité (implique l'émergence) (difficile à prédire)
* Simplicité
* Difficulté
* Facilité

6. Les interfaces c'est trop bien
   Ça découple donc ça permet de scaler.

7. Comment éviter les transactions distribuées avec un monolithe modulaire et Spring Async.

8. Un environnement de dev Linux ready sans sacrifier la sécurité et l'observabilité du SI.

9. Talk sur la consistence

10. Talk sur une startup fictive, qui grossit et fait des choix d'architecture et de scaling.

À qui je m'adresse :
Aux développeurs, testeurs, profils fonc, qui veulent connaitre comment se passe un projet en mode craftsmanship

C'est quoi l'objectif du talk :
Expliquer quelles sont les pratiques craftsman et convaincre que les utiliser à tous les niveaux d'un projet permet de le faire scaler en RH et en perf.
Et donc d'avoir à tout moment une bonne compétitivité/réactivité business et de la stabilité.
Montrer qu'on peut repousser le passage en microservice très longtemps et tout de même scaler en RH et en perf avec un monolithe modulaire

Comment je compte y parvenir :
En racontant l'histoire d'une boite qui a une idée d'application et qui monte le projet from scratch, jusqu'à son millionième utilisateur.
Je raconte ses choix d'architecture, de technologie, de ressources humaines.

* Cool j'ai une idée d'application web/android !
* Je rédige un mvp
  * C'est quoi un mvp ?
  * C'est quoi un bon mvp ?
  * J'en profite pour initier un document de mon domain-language
  * Le format est sous la forme d'une User Story dans un backlog système (transverse à plusieurs contextes métier)
    * Sans oublier les critères d'acceptation en Gherkin
* Je conçois une pré-maquette des écrans du mvp (ex : figma)
* Je confronte mon idée à des utilisateurs potentiels et j'adapte mon mvp et ma pré-maquette en fonction de leurs retours
  * Potentiellement je vois que mon idée ne fit pas le market et j'arrête tout
* Je choisis un framework front ou bien une plateforme front compatible web/mobile : Kotlin Multiplatform, React Native, Flutter.
* Je code mon mvp front en bouchonnant toutes les sources de données
  * L'UI doit être testable, c'est-à-dire avoir des éléments HTML identifiables par un robot de test 
* Je release mon front et le déploie en production sans considérations de performance ni de sécurité
* Je confronte mon idée à des utilisateurs potentiels et j'adapte mon mvp et son code
  * Potentiellement je vois que mon idée ne fit pas le market et j'arrête tout (biais des couts irrécupérables)
* Sinon, je recrute un ingénieur de test, qui lance l'automatisation d'un test UI de ce MVP (Serenity Bdd - Cypress - Geb)
  * Ce testeur fait des tests au niveau système, pour lui le système n'est qu'une seule et même application, et il se met à la place de l'utilisateur
  * Ces tests sont versionnés dans le même repository que le front
  * Il peut tester les edge-cases, mais ce sont surtout les cas nominaux qui l'intéresse, car le système est déjà couvert fonctionnellement par l'aggrégat des TU/TI/contrats des modules du système
* Et aussi si le front choisi n'est pas compatible mobile, alors je recode mon appli en natif android et ios (la galère)
* Je crée un nouveau dossier dans le même repository, pour mon backend (bff)
* J'identifie les bounded contexts traversés par mon MVP (et oui, le front est transverse aux contextes métier, dans son tunnel de vente, l'utilisateur passe par le context panier, le contexte rayons,le contexte paiement, le context stock, ...)
* Je choisis un outil de build (Gradle)
* Je boot mon monolithe modulaire en mode orchestration ou chorégraphie, avec :
  * un module en hexagonal par bounded context
  * Un module d'ACL entre chaque pair de bounded contexts qui communiquent
* Je recrute et crée une team backend par bounded context
  * 1 team = au moins 2 ingénieurs logiciels craftsPerson. 1 PO en bonus 
* Je choisis un langage : Kotlin/JVM
* Chaque team conçoit/rédige dans le backlog de son produit (module) la User Story du usecase pour lequel son bounded context intervient dans le MVP.
* Sans oublier les critères d'acceptation en Gherkin, et les JDD complets associés
* Je code le usecase de mon mvp en archi hexagonal (sans framework), avec des adapteurs secondaires in-memory, en TDD
* Je choisis un framework ou micro-framework pour les adapteurs primaires web et je les implémente, avec TI
  * Cet outil doit être à compilation native ou bien interprêté, la raison viendra plus tard, trust me (Ktor/Kotlin Multiplatform/Quarkus/http4k/micronaut)
* Je formalise le/les contrat(s) d'api entre mon front et mon back, DTO y-compris (Les api sont versionnées)
* J'auto-génère les clients web, les endpoint web, et les DTO côté back et front depuis les contrats d'interface
* Je débouchonne le front pour le connecter au back
* J'ajoute les cross-cutting concerns de performance et de sécurité
* Je release
* Je déploie en prod le monolith modulaire et le front (2 instances minimum, avec load balancer)
* Je fais une démo à mes utilisateurs
* Ça leur plait
* On commence de nouvelles features en rédigeant à nouveau des US au niveau système
* Au besoin sont créés de nouveaux :
  * Bounded contexts
  * Maquettes
* Le front est toujours dev en mode bouchonné avant le back
* On prend le feedback utilisateur puis on débouchonne petit à petit
* Les features s'accumulent, le nombre d'utilisateurs grossit, on scale donc verticalement (plus de cpu/ram) ou horizontalement (plus d'instances) en fonction du cout
* Le nombre de features et d'utilisateurs grossit toujours, il n'est plus raisonnable d'avoir autant de dispo lors des baisses de charge (ex : la nuit)
* On décide alors de passer d'un scaling static à un scaling élastique (démarrer des pod en fonction de la charge)
  * Et paf, ça n'aurait pas été possible avec Java non natif (Car Springboot met plus de 10 secondes à start, ce que l'utilisateur ne peut pas attendre)
  * On peut aussi très bien passer en serverless
* Le nombre d'utilisateurs grossit toujours, et le module "basket" a besoin de 20 pod pour supporter la charge en journée. Étant dans un monolith modulaire, le module "payment" a donc lui aussi droit à 20 pod, alors qu'il se contenterait de 5, comme la plupart des autres modules finalement.
* On pourrait décider d'exclure le module "basket" du monolith, en lui créant son propre Main et sa propre infrastructure (as-code bien sûr)
  * Il y a toujours des call entre le monolithe et le microservice, sauf que les transactions ne se propagent pas naturellement à travers le réseau.
  * Il faut donc mettre en place de nouvelles préoccupations transverses : Les transactions distribuées, la résilience
* Pour éviter cet overhead, on choisit plutôt d'affecter des threads pool différents à chaque module, avec des tailles cohérentes avec leur charge observée
* Un jour ou l'autre, le module "basket" sortira probablement du monolithe modulaire

[//]: # (* Voilà, le monolith modulaire a en moyenne 1 pod la nuit, 5 en journée, et le microservice "basket" a 20 pod en journée et 2 la nuit)
[//]: # (* Je conçois une maquette &#40;html/css&#41;)



11. Les applications modulaires permettent de scaler en RH + perf

* De quoi ça parle ?

D'app modulaires, qu'est-ce que c'est que la modularité, comment l'atteindre, qu'est-ce que ça apporte -> scaler en RH + perf

* À qui je m'adresse ?

À des membres de dev team et des coordinateurs/managers, des CTO, des stackholders.
Ils ont déjà travaillé dans des contextes où les teams ont du mal à paralléliser et à coordonner leurs efforts pour livrer de la valeur business.
Ils travaillaient alors sur du code commun ou sur des applications/modules fortement couplés.
Dans ces contextes, la MEP est un évènement, demande la coordination de toutes les équipes, et un déploiement global de la plupart des composants du système.
Ils ont observé que ça ne fonctionnait pas aussi bien que ça pourrait.

* De quoi je veux convaincre ?

Je veux les convaincre que rendre nos applications/systèmes modulaires permet de scaler en RH ainsi qu'en charge d'utilisation utilisateur (perf).
Pour ça, je veux leur donner ma définition de :
* scaler
* module
* couplage/découplage
* (cohésion)
* système distribué
* système monolithique
