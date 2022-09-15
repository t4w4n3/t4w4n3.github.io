:title: Hovercraft! demo
:data-transition-duration: 1500
:css: talk.css

You can render this presentation to HTML with the command::

    hovercraft talk.rst outdir

And then view the outdir/index.html file to see how it turned out.

----

La modularité
=============

.. note::

    Bonjour à tous.

    Pour commencer, je remercie <EVENT> d'avoir accepté mon talk / de m'avoir inviter.

    J'ai aussi beaucoup de gratitude pour ma boite de services, Younup, qui me donne le temps et l'encouragement pour ce genre d'activité.

    Aujourd'hui je vous propose de parler de modularité.

----

Pourquoi ce sujet ?

.. note::

    Quand je fais des appli métier, j'ai plein de choses à penser. Sur le métier lui-même, sur les différents contextes métiers qui interagissent entre eux, et aussi sur les préoccupations techniques : outillage, opérationnel, observabilité, sécurité.

    L'accumulation de préoccupations a un effet inévitable : l'erreur humaine, l'oubli. Cela induit une baisse de performance business, non-business, et de bien-être.

    Je souhaite éviter ces effets. Pour cela je dois alors soulager ma charge mentale.

    Pour réduire ma charge mentale, j'**encapsule** des choses dans des boites. Sous certaines contraintes, je peux alors utiliser/déplacer ces boites en faisant **abstraction** de ce qu'elles contiennent ou de comment elles fonctionnent.

    J'obtiens alors un système modulaire.

    Ces contraintes ce sont celles de la modularité. Depuis que je les applique, j'ai la sensation d'être plus performant et plus épanoui dans mon travail.

    Et donc je souhaite partager mes connaissances sur le sujet.

----

:id: whoAmI

Antoine Salesse
===============

Développeur (de logiciels)
--------------------------

.. image:: images/tawane-younup_transparancy_circle.png
    :height: 200px

|

.. class:: substep

    .. image:: images/younup_logo_transparency.png
            :width: 300px


.. container:: substep aligned

    .. image:: images/linkedIn_Logo.png
        :width: 60px

    @antoine-salesse

.. container:: substep aligned

    .. image:: images/keyboard_logo.png
        :width: 60px

    @t4w4n3.github.io

.. note::

    Je m'appelle Antoine Salesse.

    Je fais de l'ingénierie logicielle depuis 2012, toujours plus ou moins autour de Java, et principalement sur du backend.

    Ça fait 3 ans que je travaille avec passion pour Younup et ses clients


    Faire un détour sur la slide de Younup

----

Use reStructuredText!
=====================

* You can use your favorite text-editor!

* Many tools available: Landslide, S5

* Convenient (and powerful!)

.. note::

    You also have a clock and a timer, so you know how much time you have
    left.

----

But then there was Prezi
========================

Sliding from left to right is no longer enough.
You need to be able to...

.. note::

    If you click on the timer it restarts from zero. This is handy when you
    are rehearsing the presentation and need to make sure it fits in the time
    allocated.

----

:data-y: r1000

...pan...
=========

.. note::

    If you have more notes than fit in the console, you can scroll down, but
    more handily, you can scroll the text up by pressing space bar.

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

