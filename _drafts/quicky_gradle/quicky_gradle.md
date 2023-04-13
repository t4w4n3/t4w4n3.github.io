# Quicky Gradle

Titre : 

    A qui je m'adresse ?
=> A des développeurs Java venus au JUG Lille pour écouter des sujets tech pointus sur Java.

    De quoi je veux convaincre ?
=> Que Gradle est l'outil d'automatisation de build incontournable de Java.

Plan :

1. Mais au fait, c'est quoi le build ?
Le build, c'est l'ensemble du processus qui permet de passer du code source à un artefact logiciel déployable et exécutable.
Ce processus, qu'on peut appeler aussi cycle de vie de l'application, passe par plusieurs étapes comme la compilation, l'exécution des tests, la résolution/téléchargement de dépendances, le packaging dans le livrable final.
Ces étapes doivent être orchestrées; on doit compiler les tests avant de les exécuter.
Ces étapes sont répétitives et laborieuses pour un humain, d'où l'utilisation d'un outil d'automatisation.
3. Les outils d'automatisation de build de Java
   * Ant (xml impératif)
   * Maven (xml déclaratif)
   * Sbt
   * Bazel
   * Gradle

JVM ecosystem report 2021
https://snyk.io/jvm-ecosystem-report-2021/
4. Les projets multi modules
5. Qu'est-ce que Gradle
    * C'est un outil d'automatisation de build
    * Ses scripts de build sont en Groovy ou en Kotlin
    * Conçu et maintenu autour de la performance :
        * Incremental Builds
        * Build Caching
        * Incremental Subtasks
        * Parallel Execution
        * Compiler Daemon

# Brainstorm area

    Les idées à ne pas perdre mais qu'on ne sait pas où mettre.

Oubliez ce que vous pensez savoir sur Gradle des années passées.

Dans un outil d'automatisation de build :
   * Le build est une application dont le "domain" est le cycle de vie de l'application (dependency resolve, compile, test, package)
   * Une application codée en XML ? Sérieusement, nous les dev backend ? Alors pourquoi s'obstiner sur Maven

Ces outils permettent de créer facilement des versions reproductibles et fiables de votre code, ce qui est crucial pour les projets à grande échelle.

 ## ChatGpt 1

Propose-moi un plan de présentation orale dont l'objectif est de démontrer en quoi Gradle est devenu l'outil d'automatisation de build incontournable de la JVM pour les projets multi-modules.

Voici un plan de présentation que vous pourriez suivre pour démontrer en quoi Gradle est devenu l'outil d'automatisation de build incontournable de la JVM pour les projets multi-modules :

    Commencer en expliquant ce qu'est un outil d'automatisation de build et pourquoi il est important dans le développement de logiciels.

    Introduire Gradle et souligner ses principaux avantages par rapport aux autres outils d'automatisation de build populaires, tels que Maven et Ant.

    Décrire comment Gradle facilite la gestion de projets multi-modules en permettant de gérer facilement les dépendances entre différents modules, ainsi que la configuration et la gestion des tâches de build pour chaque module.

    Donner des exemples concrets de la façon dont Gradle permet d'automatiser des tâches courantes dans les projets multi-modules, telles que la compilation, le packaging et le déploiement.

    Expliquer comment Gradle peut être étendu en utilisant des plugins pour ajouter des fonctionnalités supplémentaires, telles que la gestion de dépendances, la génération de documentation ou la vérification de la qualité du code.

    Conclure en résumant les principaux avantages de Gradle en tant qu'outil d'automatisation de build pour les projets multi-modules, et pourquoi il est devenu l'outil incontournable de la JVM pour ces projets.
    

Traitez votre code de build comme vous traitez votre code applicatif.

Pourquoi on a besoin de bons outils pour automatiser le build de notre application.

Today Gradle est le meilleur candidat, mais demain il pourra en avoir un autre et il faudra lui donner sa chance.

Gradle a ses limites aussi.

Quels sont les fonctionnalités que doivent avoir les outils d'auto de build ?
Montrer que Maven ne les rempli pas.
Montrer que Gradle les remplis.

Qu'est ce qui a changé depuis 5 ans dans Gradle et qui fait qu'il faut le reconsidérer.
Qu'est-ce qui manquerait dans Maven et qu'i ly a dans Gradle.

Nouveau plan avec Pierre :

1. C'est quoi le build ? C'est une application avec de la logique. Traitez votre code de build comme vous traitez votre code applicatif.
2. Je viens de faire ci ça ça ça dans le mono-repo de SNCF Connect, et je vais vous montrer x trucs qui font qu'aujourd'hui Gradle est un super outil d'automatisation de build qui (re-)mérite notre attention
   1. a
   2. b
3. Conclusion
   * Moi je kif Gradle et j'espère que vous allez kiffé aussi
   * Malgré quelques inconvénients/limitations, Gradle c'est top :
     * Courbe de progression pentue : Builder c'est compliqué, les outils le sont aussi. "Oui mais maven c'est facile". Tu te souviens quand tu as commencé Maven il y a 10 ans, tu te souviens comment tu as galéré.
     * Mise à jour régulière nécessaire
     * Dans breaking change régulier dans l'API
   * 


Option plan 2 : Défoncer Maven
