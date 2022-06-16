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

Montrer que les solutions mises en place ne sont que des workarounds (exemple : mettre un monorepo pour contenir tout le système distribué ; cela partage par héritage (tout ou rien) plutôt que par
composition (submodules))

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
Au développeurs, testeurs, profils fonc, qui veulent connaitre comment se passe un projet en mode craftsmanship

C'est quoi l'objectif du talk :


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
  * L'UI doit être testable, c'est-à-dire avoir des éléments HTML identifiable par un robot de test 
* Je release mon front et le déploie en production sans considérations de performance ni de sécurité
* Je confronte mon idée à des utilisateurs potentiels et j'adapte mon mvp et son code
  * Potentiellement je vois que mon idée ne fit pas le market et j'arrête tout
* Sinon, je lance l'automatisation d'un test UI de ce MVP (Serenity Bdd - Cypress - Geb)
* Et aussi si le front choisi n'est pas compatible mobile, alors je recode mon appli en natif android et ios (la galère)
* Je crée un repository pour mon backend (bff)
* J'identifie les bounded contexts traversés par mon MVP (et oui, le front est transverses aux contexts métier, dans son tunnel de vente, l'utilisateur passe par le context panier, le contexte rayons,le contexte paiement, le context stock, ...)
* Je choisis un outil de build (Gradle)
* Je boot mon monolithe modulaire en mode orchestration ou chorégraphie, avec :
  * un module en hexagonal par bounded context
  * Un module d'ACL entre chaque pair de bounded contexts qui communiquent
* Je recrute et crée une team backend par bounded context
* Je choisis un langage : Kotlin/JVM
* Chaque team conçoit/rédige dans le backlog de son produit (module) la User Story du usecase pour lequel son bounded context intervient dans le MVP.
* Sans oublier les critères d'acceptation en Gherkin, et les JDD complets associés
* Je code le usecase de mon mvp en archi hexagonal (sans framework), avec des adapteurs secondaires in-memory, en TDD
* Je choisis un framework ou micro-framework pour les adapteurs primaires web et je les implémente, avec TI
* Je formalise le/les contrat(s) d'api entre mon front et mon back, DTO y-compris (Les api sont versionnées)
* J'auto-génère les clients web, les endpoint web, et les DTO côté back et front depuis les contrats d'interface
* Je débouchonne le front pour le connecter au back
* J'ajoute les cross-cutting concerns de performance et de sécurité
* Je release
* Je déploie
* Je fais une démo à mes utilisateurs



[//]: # (* Je conçois une maquette &#40;html/css&#41;)
