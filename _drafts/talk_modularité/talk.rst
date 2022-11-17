:title: Les enjeux de la modularité logicielle
:data-transition-duration: 1500
:css: talk.css

You can render this presentation to HTML with the command::

    hovercraft talk.rst outdir

And then view the outdir/index.html file to see how it turned out.

----

Les enjeux de la modularité logicielle
======================================

.. note::

    Bonjour à tous.

    Pour commencer, je remercie <EVENT> d'avoir accepté mon talk / de m'avoir invité

    J'ai aussi beaucoup de gratitude pour ma boite de services, Younup, qui me donne le temps, l'encouragement et l'accompagnement pour ce genre d'activité.

    Aujourd'hui je vous propose de parler de modularité.

----

Pourquoi ce sujet ?

|

.. class:: substep

    ⇊ charge mentale

    ⇊ erreurs humaines

    **Encapsuler** des choses dans des boites

.. note::

    Quand je fais des appli métier, de l'informatique de gestion, j'ai plein de choses à penser. Sur le métier lui-même, sur les différents contextes métiers qui interagissent entre eux, et aussi sur les préoccupations techniques : outillage, opérationnel, observabilité, sécurité.

    L'accumulation de préoccupations a un effet inévitable : l'erreur humaine, l'oubli. Cela induit une baisse de performance organisationnelle et non-commercial, ainsi que de bien-être.

                Quand un produit a du succès, son scope fonctionnel a tendance à augmenter. La taille de l'équipe ayant l'ownership du produit augmente aussi, jusqu'à dépasser la taille raisonnable. Modulariser le produit permet de ventiler l'ownership du produit sur plusieurs équipes.

    Je souhaite éviter ces effets. Pour cela je dois alors soulager ma charge mentale.

    Pour réduire ma charge mentale, j'**encapsule** des choses dans des boites. Sous certaines contraintes, je peux alors utiliser/déplacer ces boites en faisant **abstraction** de ce qu'elles contiennent ou de comment elles fonctionnent.

    Ces contraintes ce sont celles qui font qu'un système est modulaire.

    Les enjeux c'est : Qu'est-ce qui va se passer si on ne les applique pas ? Et si on les applique ?

    J'expérimente régulièrement les 2 cas. J'ai remarqué que les produits et les équipes allaient bien mieux lorsque les contraintes de la modularité étaient connues et appliquées. J'ai envie de vous en convaincre, et de vous montrer avec bien sûr du code modulaire, dans le monde Java.

----

:id: whoAmI

Antoine Salesse
===============

Développeur (de logiciels)
--------------------------

.. image:: images/tawane-younup_transparancy_circle.png
    :height: 200px

.. container:: substep

    .. image:: images/Duke_logo.png
            :width: 30px

    .. image:: images/kotlin.png
            :width: 40px

    .. image:: images/Gradle_Logo.png
            :width: 60px

    .. image:: images/aws.png
            :width: 60px

    .. image:: images/docker.png
            :width: 65px

    .. image:: images/gitlab.png
            :width: 40px

    .. image:: images/github_logo.png
            :width: 40px

    .. image:: images/micrometer.png
            :width: 40px

    .. image:: images/micronaut.png
            :width: 45px

    .. image:: images/spring.png
            :width: 40px

    .. image:: images/quarkus.png
            :width: 40px

    .. image:: images/jakarta.png
            :width: 40px

    .. image:: images/junit5-logo-1.png
            :width: 40px

    .. image:: images/tux.png
            :width: 40px

    .. image:: images/k8s.png
            :width: 50px

    .. image:: images/terraform.png
            :width: 40px

.. container:: substep

    .. image:: images/younup_logo_transparency.png
            :width: 300px

    younup.fr/blog

.. container:: substep aligned

    .. image:: images/linkedIn_Logo.png
        :width: 60px

    @antoine-salesse

.. container:: substep aligned

    .. image:: images/keyboard_logo.png
        :width: 60px

    t4w4n3.github.io

.. note::

    Et au fait, je m'appelle Antoine.

    Dans la vie, mes 2 drivers principaux c'est être papa, depuis 2018, et faire du software, depuis 2012, toujours plus ou moins autour de backends Java.

    Ça fait 3 ans que je travaille avec passion pour Younup et ses clients.

    Younup c'est une ESN native de Nantes et présente aussi à Rennes, Bordeaux, Lille et Lyon.

    J'y fais du consulting backend et lead dev, des formations internes, des entretiens tech, et des contributions de médias : articles tech, quickies, et maintenant talk.

    Je suis actif sur LinkedIn, c'est là que je poste mes réflexions à propos du software.

    Je publie aussi sur un blog tech : t4w4n3.github.io

----

Qu'est ce qu'un module ?
========================

|

.. class:: substep

Extension facultative à un système autonome

|

.. class:: substep

Le système fonctionnait déjà sans le module

.. note::

    Bon, pour commencer demandons nous : "qu'est-ce qu'un module ?"

    Oublions le software 2 minutes. "Qu'est-ce qu'un module ?"

    Je vous propose cette définition : "C'est une extension facultative à un système autonome."

    "Système autonome" = Le système fonctionnait déjà sans le module.

----

Ajout de fonctionnalité(s)
==========================


.. class:: substep

    Un module est une **encapsulation** de fonctionnalités.

    |

    Le module expose ses fonctionnalités par des interfaces.

    |

    Le système accède aux fonctionnalités d'un module par ses interfaces.

.. note::

    L'ajout d'un module au système ajoute une ou plusieurs fonctionnalités à ce système.

----

L'ajout d'un module est facile et simple
========================================

|

.. class:: substep

    Ou alors correctement documenté

.. note::

    Vous remarquerez la distinction faite entre facilité et simplicité.

----

Le système devient dépendant du module
======================================

|

.. class:: substep

    Supprimer le module = faire régresser le système

.. note::

    C'est toujours le système qui utilise les fonctionnalités du module, mais jamais le module qui appelle des fonctionnalités du système.

    Sinon, ce n'est pas un système modulaire, mais un seul et même système local.

    Et s'il y a du réseau entre les 2, c'est en plus un système distribué, avec toutes les complications que ça apporte.

    Toute dépendance cyclic entre le système et un module indique que le module devrait plutôt faire partie du système.

    Toute dépendance cyclic entre 2 modules indique que ce devrait plutôt être un seul module.

----

System as a module
==================

.. note::

    Tout système autonome peut être module d'un autre, à condition qu'il expose ses fonctionnalités à travers des interfaces, et qu'il n'ait pas de dépendance vers l'autre système.

----

:data-x: r0
:data-y: r500
:data-scale: 0.1

Software and modules
====================

WIP rendu ici

.. note::

    a
