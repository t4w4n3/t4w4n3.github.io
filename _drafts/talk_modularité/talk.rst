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

.. class:: substep

    This paragraph will be shown when you press <next>

    This will show on the second <next> press

.. note::

    Quand je fais des appli métier, j'ai plein de choses à penser. Sur le métier lui-même, sur les différents contextes métiers qui interagissent entre eux, et aussi sur les préoccupations techniques : outillage, opérationnel, observabilité, sécurité.

    L'accumulation de préoccupations a un effet inévitable : l'erreur humaine, l'oubli. Cela induit une baisse de performance organisationnelle et non-commercial, ainsi que de bien-être.

    Je souhaite éviter ces effets. Pour cela je dois alors soulager ma charge mentale.

    Pour réduire ma charge mentale, j'**encapsule** des choses dans des boites. Sous certaines contraintes, je peux alors utiliser/déplacer ces boites en faisant **abstraction** de ce qu'elles contiennent ou de comment elles fonctionnent.

    Ces contraintes ce sont celles qui font qu'un système est modulaire.

    Les enjeux c'est : Qu'est-ce qui va se passer si on ne les applique pas ? Et si on les applique ?

    J'observe régulièrement les 2 cas. Je vais vous raconter des histoires dans ces cas. Puis bien sûr on verra du code modulaire, dans le monde Java.

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

:data-rotate: 90

...rotate...
============

.. note::

   If there isn't more text to scroll up, space bar will go to the next
   slide. Therefore you, as a presenter, just press space every time you run
   out of things to say!

----

:data-x: r0
:data-y: r500
:data-scale: 0.1

...and zoom!
============

.. note::

    Zooming is cool. But one day it will grow old as well. What will we do
    then to make presentations interesting?

----

:data-x: r-800
:data-scale: 1

But Prezi is a GUI
==================

So we are back to square one.

(And it is closed source to boot)

.. note::

    It's probably back to making bad jokes again.

----

What about impress.js?
======================

It's open source!

Supports pan, tilt and zoom!


----

:id: ThreeD
:data-y: r1200
:data-rotate-x: 180

In three dimensions!
====================

*But...*

.. note::

    Wow! 3D! You didn't see that one coming, did you?

----


It's HTML...
============

Not a friendly format to edit

----

:data-x: r800

...and manual positioning
=========================

So inserting a slide means

repositioning all the following slides!


.. note::

    The endless repositioning of slides is what prompted me to write
    Hovercraft! in the first place.

----

:id: thequestion
:data-x: r0
:data-y: r-1200

*Is there no solution?*
=======================

Of course there is!

.. note::

    What would be the point of this slide show if I didn't have a solution?
    Duh!

----

:data-rotate-y: 180
:data-scale: 3
:data-x: r-2500
:data-y: r0

Introducing **Hovercraft!**
===========================

.. note::

    TADA!

----

:data-x: r-3000
:data-scale: 1

reStructuredText
----------------

plus
....

impress.js
----------

plus
....

positioning!
------------

and
...

More!

----

:data-y: r-1200

Position slides
===============

* Automatically!
* Absolutely!
* Relative to the previous slide!
* Along an SVG path!


.. note::

    That SVG path support was a lot of work. And all I used it for was to
    position the slides in circles.

----

Presenter console!
==================

* A view of the current slide
* A view of the next slide
* Your notes
* A clock
* A timer

.. note::

    You found the presenter console already!

----

Mathjax!
========

Beautiful maths!

.. math::

    e^{i \pi} + 1 = 0

    dS = \frac{dQ}{T}

And inline: :math:`S = k \log W`

----

**Hovercraft!**
===============

.. figure:: images/hovercraft_logo.png

    The merge of convenience and cool!

.. note::

    A slogan: The ad-mans best friend!

----

:data-x: 0
:data-y: 2500
:data-z: 4000
:data-rotate-x: 90

**Hovercraft!**
===============

On Github:

https://github.com/regebro/hovercraft

.. note::

    Fork and contribute!

