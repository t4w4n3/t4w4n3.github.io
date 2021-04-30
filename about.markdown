---
layout: page
title: Qui suis-je ?
permalink: /about/
---

Hello ! Je suis Antoine, ou t4w4n3 de pseudo (parce qu'il en faut un je crois). Ce blog est plutôt tech et je m'y décris donc sous cette facette là.
Mais je suis aussi plus que cela bien sûr :wink:

Je dev en prod depuis 2012, en France, et j'ai fini par réaliser que c'est mon Ikigai en 2017 (merci la team des DocBusters).

Le code me parait semblable à un organisme vivant; il est soumis à l'entropie, il se complexifie, il évolue, il pourrit. En designant, codant, testant j'ai la sensation de maitriser l'entropie, et de me sentir vivant et utile. Le vivant est très fort pour provoquer des diminutions locales d'entropie.

J'aime les langages et frameworks de haut niveau : Springboot, **Grails**, **Groovy**, Quarkus, Micronaut. La compléxité du monde du software grandit à toute allure, et je n'ai pas envie de résoudre les problèmes qui sont pliés depuis longtemps. L'enchevetrement de niveaux d'abstraction est aujourd'hui si dense, qu'il est déraisonnable d'étudier toute la strate avant de commencer à en utiliser le sommet. Vouloir apprendre tout ce que nos prédécesseurs savaient n'est qu'un attavisme de la période pre-disque-dur. Maintenant que nous pouvons y stocker les enseignements de toutes les générations, plus besoin de tout retenir. Le paradigme Just-In-Time est maintenant bien plus adapté quand il s'agit d'aller chercher l'information. J'espère que les méthodes scolaires adopteront cette vision assez tôt.

L'écosystème de la JVM c'est mon truc ! Bien que plus ça va, moins j'aime coder du Java pur. Avec entre autres son typage static fort, il est équipé pour protéger le développeur contre lui-même. Le prix à payer pour une telle protection est la haute verbosité et un time-to-market moins bon que celui auquel on s'attendait en choisissant Java au lieu de C++.

Je me tourne donc souvent vers Groovy, qui lève des barrières de Java afin de donner accès aux opérateurs avancés, (elvis, elvis assignement, safe nav, safe index, spread, range, ...), et offre nativement des fonctions de manipulations de structures de données telles que `.collect()`, `findAll()`, `.collectEntries()`, `.combination()`, `.permutation()`, `.groupBy()`

Utiliser Groovy pour le code de prod demande du courage, et on trouvera des détracteurs à la pelle. De mon point de vue, c'est l'efficacité de la stack de test qui permettra la sérénité avec l'utilisation de Groovy en prod.

90% de mon xp JVM s'est faite avec Maven, surtout par dépis de connaitre/trouver autre chose. Jusqu'à ce que je rencontre Gradle. Et là, ce fut le switch direct. Le paradigme "as-code" appliqué à la conf me convient bien mieux que ce vieux XML. Yaml n'est pas pour me déplaire, et il m'arrive souvent d'en mettre une pincée. Mais le XML, beurk, ça me révulse. Pourquoi ? Xml représente l'opposé du principe DRY, si cher à ma santé mentale. J'en viens alors à développer mes propres DSL Groovy pour simplifier le dev de paramétrages, même si le delegate pattern me fait encore parfois des noeuds aux synapses.

Côté test, je suis un inconditionnel de Spock et de Geb (et oui encore du Groovy), pour couvrir les 3 niveaux : composant, intégration, système. J'ai aussi bien expérimenté le benchmarking avec un peu de Jmeter, beaucoup de JMH, et un chouilla de Gatling, mais je n'ai encore jamais rencontré de contexte d'entreprise avec une qualité/volumétrie nécessitant ce genre de test. Si demande il s'en présentrait, je suis prêt et je maitrise mes outils. 

Côté team,                  . J'apprécie qu'elles soient restreintes (N*(N-1)/2 <= 36, soit 9 personnes max).