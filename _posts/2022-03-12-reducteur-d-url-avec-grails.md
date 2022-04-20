---
layout: post
title:  "Un réducteur d’url codé avec Grails 5"
date:   2022-03-12 11:50:40 +0100
categories: java grails
---

# Démo de Grails 5 avec un simple réducteur d’url

J’ai récemment regardé [cette vidéo](https://www.youtube.com/watch?v=gq5yubc1u18) de la chaîne Youtube [Coding Garden](https://coding.garden/).

Dans ce live coding enregistré, il tente (et réussi) à coder un site web réducteur d’url from scratch, et il le déploie en production grace au PAAS Heroku et sa CLI, le tout en 1 heure.

Je me suis dit :

> Waou, quelle maitrise de ses outils !

Puis, je me suis demandé :

> Pourrais-je en coder un aussi vite avec ma propre stack ?"

Essayons !

## Qu’est-ce qu’un réducteur d’url ?

Très simple.

Vous avez une longue URL et pour x raisons, vous avez besoin qu’elle soit minuscule (exemples : pour s’en souvenir, l’afficher).

Vous allez donc sur un outil de raccourcissement d’URL.

Vous lui donnez votre longue url.

Il vous donne en retour une petite url qui redirige vers la vôtre.

## Ma propre stack

Je suis un développeur Java backend, qui sait aussi faire quelques trucs en frontend.

Je vais utiliser Grails 5.1.3, qui inclut (avec quelques personnalisations perso) <

- Gradle 7.4.1
- Java 15
- Groovy 3.0.10
- Hibernate 5.5
- Micronaut 3.2.7
- Springboot 2.6.4
- Tomcat 9.0
- Spring 5.3.16

Java 15 est la plus haute version ayant une compatibilité totale avec Groovy 3. Pour Java 17/18, il faut attendre Groovy 4 et Grails 6.

Le framework offre un support backend et frontend.

Vous pouvez me trouver old-school, mais j’aime le templating HTML Java. Mais pas le genre Jsp / Jstl. Plutôt un très moderne : GSP (Groovy Server Pages). C’est le composant de view principal du Framework Grails.

## Pré-requis

* Un JDK entre 8 et 15
* Grails 5.1.3
* (facultatif) Intellij => excellent support de Grails

Si vous avez [sdkman](https://sdkman.io/), voici les commandes d’installation :

```sh
sdk install grails 5.1.3
sdk install java 11.0.12-open
```

Et si vous ne l’avez pas, allez l’installer ainsi :wink: : 

```sh
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
```

## Étape 1 : Pur projet Grails

Pour commencer, on a besoin d’initialiser le projet Grails

```sh
grails create-app shorturl
cd shorturl
```

Allons voir ce que nous avons déjà, en lançant le mode dev avec le wrapper Grails :

```sh
./grailsw run-app
```

### run-app result :

```sh
Running application...
Grails application running at http://localhost:8080 in environment: development
<===========--> 85% EXECUTING [44s]
> :bootRun
```

Le dev-mode de Grails supporte le hotreload, laissons donc l’app tourner.

### Capture du Front-end :

> ![](/assets/images/welcome-to-grails.png)

## Étape 2 : Créer l’entité principale

Fondamentalement, ce que nous voulons, c’est stocker des ’url’ par ’segment’.

Vous savez déjà ce qu’est une url.

Un segment est un morceau d’URL, entre des slashes.

> https://t4wan3.github.io/blog/grails/url-shortener-grails

Dans cette url, « blog », « grails » et « url-shortener-grails » sont des segments.

Grails fait la persistance en base de données grâce à des « classes de domaine » équivalentes à l’association d’`Entity` et de `JpaRepository` de Spring.

Créons la classe de domaine pour stocker des ’url’ par ’segment’ :

```sh
./grailsw create-domain-class shortUrl
```

On l’ouvre, et on y créé les attributs :

```groovy
class ShortUrl {

	String segment
	String url

	static constraints = {
	}
}
```

Vous voyez le champ `constraints` ?

Et bien on peut y ajouter des conditions de validation pour chacun des champs :

* Le `segment` :
	* Doit être unique
	* Doit avoir entre 5 et 10 caractères
	* Doit être en ascii
* L’url :
	* Doit être une url valide
	* Ne dois pas être blank (vide)

```groovy
static constraints = {
			segment unique: true, size: 5..10, matches: "[0-9a-zA-Z]*"
	url url: true, blank: false
}
```

## Étape 3 : Scaffolder the ShortUrl entity

La traduction littérale de "scaffold" est "échafauder".  
Dans notre contexte, cela signifie "générer automatiquement une hiérarchie de structures de données depuis une graine initiale".

Maintenant que notre domaine est modélisé, nous pouvons supposer que notre application est assez simple pour utiliser un CRUD.

Nous n’avons qu’une seule entité et la seule opération CRUD que nous voulons est CREATE.

Construire un formulaire frontend pour l’opération CREATE est une roue, et Grails sait que nous ne voulons pas la réinventer.

Et donc il peut la scaffolder pour nous.

Grails implémente [Micronaut for Spring](https://micronaut-projects.github.io/micronaut-spring), et donc nous travaillons là sur un [MVC](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller).

Le scaffolding peut commencer depuis un contrôleur. On peut soit :

* Exécuter la commande de scaffolding, ce qui va alors générer les fichiers dans les sources
* Déclarer l’instruction de scaffolding dans un contrôleur, ce qui va alors référencer les fichiers dans le build

Essayons la 2ᵉ solution :

```sh
./grailsw create-controller ShortUrl
```

Puis on remplace tout son contenu avec l’instruction :

```Groovy
class ShortUrlController {
	static scaffold = ShortUrl
}
```

Ouvrons le navigateur afin de voir le contenu hot-reloadé :

### Les contrôleurs disponibles :

> ![](/assets/images/available_controller.png)

On peut voir ici notre tout nouveau contrôleur. Ouvrons-le.

### La page listant les urls raccourcies

> ![](/assets/images/shorturl_list.png)


Quand le navigateur a appelé l’endpoint du contrôleur avec une requête GET, il y avait ce header :

`Accept: application/html`

Le contrôleur l’interprète afin de répondre avec une page html listant toutes les `ShorUrl` stockées.

Regardons ce que fait le bouton "new ShortUrl" : 

### La page de création des `ShortUrl`

> ![](/assets/images/create_shorturl.png)

Cela ouvre une page avec un formulaire qui permet de créer de nouvelles `ShortUrl`.

C’est proche de ce qu’on aimerait avoir comme page d’accueil ! 

Quand on créé une `ShortUrl`, on est redirigé vers la page `show` de l’objet créé. 

![](/assets/images/shorturl-show-page.png)

### Essayons le lien

Si je préfixe le base-path avec le segment, j’obtiens `http://localhost:8080/k2m47`. 

Mais ce lien redirige vers la page 404 : 

![](/assets/images/page-not-found-404.png)

## Étape 4 : Configurer la redirection

Fondamentalement, on veut que `http://localhost:8080/k2m47` redirige vers la longue url associée stockée.  

Et donc on créé la redirection interne depuis ce pattern d’url vers une nouvelle action nommée `redirect` dans le `ShortUrlController` :

```groovy
class UrlMappings {
    static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
            }
        }
        
        "/$segment"(controller: 'shortUrl', action: 'redirect')

        "/"(view:"/index")
        "500"(view: '/error')
        "404"(view: '/notFound')
    }
}
```

```groovy
class ShortUrlController {
    
    [...]
    
	def redirect(String segment) {
		redirect uri: ShortUrl.findBySegment(segment)?.url
	}
}
```

Ouvrons à nouveau l’url raccourcie : http://localhost:8080/k2m47

Magique, l’url raccourcie apparait !

## Étape 5 : Changer la page d’accueil

À présent que la redirection fonctionne, on voudrait changer la page d’accueil.

On peut y parvenir avec le fichier `UrlMappings.groovy` (qui existe déjà) :

```groovy
class UrlMappings {
    static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
            }
        }
        
        "/$segment"(controller: 'shortUrl', action: 'redirect')

        "/"(controller: 'shortUrl', action: "create")
        "500"(view: '/error')
        "404"(view: '/notFound')
    }
}
```

Quand un utilisateur accède à `/`, il va être redirigé vers l’action create du contrôleur nommé `ShortUrlController`. 

> De quelle action parles-tu ? Il n’y a aucune méthode dans ShortUrlController.

Si, il y en a. Les actions `create`, `save`, `get`, `update` sont injectées à la compile-time dans le contrôleur, grace au scaffolding.

## Étape 6 : Interdire les actions inutiles

Dans notre cas d’utilisation, on ne veut que les actions `show`, `index`, `save`. Et surtout pas `update`.

On utilise aussi la `closure` `constraints` afin de :

* Autoriser seulement le contrôleur `ShortUrlController`
* Autoriser seulement les actions show, index, save

```groovy
class UrlMappings {
    static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
     	       controller matches: 'shortUrl'
        	    action inList: ['show', 'index', 'save']
            }
        }

        "/"(controller: 'shortUrl', action: "create")
        "500"(view: '/error')
        "404"(view: '/notFound')
    }
}
```

Si la contrainte de validation échoue, alors l’utilisateur est redirigé (par convention) vers la page 404. 

## Étape 7 : Rendre le segment facultatif 

Grails construit le formulaire à partir des attributs et des contraintes de l’entité.

Rendons le segment `nullable` :

```groovy
static constraints = {
    		segment unique: true, size: 5..10, matches: "[0-9a-zA-Z]*", nullable: true
    url url: true, blank: false
}
```

![](/assets/images/segment_optional.png)

Bien mieux !

Mais on doit maintenant en générer un aléatoirement si non renseigné.

Initialisons-le dans la méthode `beforeValidate` de `ShortUrl` (si non fourni par l’utilisateur) :

```groovy
import static org.apache.commons.lang3.RandomStringUtils.randomAlphanumeric

class ShortUrl {

[...]

    void beforeValidate() {
        int segmentMinSize = constrainedProperties.segment.size.from as int
        segment ?= RandomStringUtils.randomAlphanumeric(segmentMinSize)
    }
}
```

`beforeValidate` se déclenche dès qu’on tente d’ajouter/modifier une entité en base de données.

On réutilise la contrainte `min size` en tant que taille par défaut.

------

### Note rapide sur l’aléatoire

1. Ici, le segment n’a pas à être sécurisé. On veut juste des mots de 5 caractères
2. Sur un mot de 5 caractères alphanumériques, des collisions peuvent survenir. On peut alors ajouter un peu de code de validation :

```groovy
class ShortUrl {

[...]

protected String getRandomAlphaNumeric() {
	  def segmentMinSize = constrainedProperties.segment.size.from as int
	  RandomStringUtils.randomAlphanumeric(segmentMinSize)
  }

  def beforeValidate() {
	  if (!segment) {
		  do {
			  segment = randomAlphaNumeric
		  } while (hasDuplicatedSegment())
	  }
  }

  boolean hasDuplicatedSegment() {
	  !validate() &&
			  errors.fieldErrors?.find { it.field == 'segment' }?.code == 'unique'
  }
}
```

-----

À présent, un mot aléatoire est généré jusqu’à ce qu’il soit unique (Grails va vérifier dans la base de données pendant le `validate()`).

## Étape 8 : Changer la redirection sur un `submit` de `create`

> ![](/assets/images/show_page.png)

Quand on veut une `ShortUrl`, en soumettant le formulaire, l’action de `save` est exécutée, et on est redirigé par convention sur la page `show` montrant l’entité `ShortUrl` créée.

La page `show` n’a pas de valeur dans notre MVP, et donc on préfère être redirigé sur une nouvelle page de création qui contient aussi la nouvelle `ShortUrl` dans une `div` conditionnelle.

Pour ça, surchargeons l’implémentation scaffoldée `show` :

```groovy
def show(Long id) {
	redirect action: 'create', params: [id: id]
}
```

On lui donne en paramètre l’id de l’entité tout juste créée dans le but d’être capable de récupérer cette entité et de l’afficher sur le page de création. 

## Étape 9 : La div conditionnelle sur la page de création

Quand on arrive sur la page de création, il y a deux cas d’utilisation possibles :

1. On vient juste d’ouvrir la page
2. On vient juste de soumettre une nouvelle `ShortUrl` depuis une précédente page de création

Pour le second cas, on a un `params.id` non-null, et on s’en sert alors pour récupérer en base de données l’entité associée, et on l’ajoute au model de la vue.

```groovy
def create(String id) {
    respond new ShortUrl(params), model: [created: ShortUrl.get(id)]
}
```

Maintenant, on surcharge la page de création en générant les 4 vues (index, show, edit, create) :

```sh
./grailsw generate-views ShortUrl
```

À la fin du body du fichier `create.gsp`, on ajoute la div conditionnelle qui sert à afficher la potentielle `ShortUrl` toute juste créée :

```html
[...]
</div>
<g:if test="${created}">

</g:if>
</body>
</html>
```

Le code d’affichage d’une `ShortUrl` se trouve dans le fichier `show.gsp`. Copions-le ici :

```html
[...]
</div>
<g:if test="${created}">
	<div id="show-shortUrl" class="content scaffold-show" role="main">
		<h1>Shortened url :</h1>
		<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
		</g:if>
	</div>
</g:if>
</body>
</html>
```

Ensuite on génère le lien de redirection avec `createLink` et on l’affiche :

```html
[...]
</div>
<g:if test="${created}">
	<div id="show-shortUrl" class="content scaffold-show" role="main">
		<h1>Shortened url :</h1>
		<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
		</g:if>
        <g:set var="link" value="${createLink(uri: "/${created.segment}", absolute: true)}"/>
        <a href="${link}">${link}</a>
	</div>
</g:if>
</body>
</html>
```

Et enfin, on supprime les vues non surchargées et inutilisées :

```sh
rm grails-app/views/shortUrl/show.gsp
rm grails-app/views/shortUrl/index.gsp
rm grails-app/views/shortUrl/edit.gsp
```

Super ! Maintenant on peut voir la `ShortUrl` créée sur la même page :

> ![](/assets/images/conditional_div.png)

## Étape 10 : Ajouter une meilleure page d’index

Dans Grails, la page d’index correspond à la liste (paginée) des éléments.

Par défaut, la liste de toutes les `ShortUrl` créées ressemble à ça :

![](/assets/images/default_shorturl_list_view.png)

On se moque du segment et de sa page de visualisation (`show`).

Ce qu’on devrait plutôt montrer sur cette page d’index, c’est une table de longues urls par urls raccourcies.

Une solution simple est d’ajouter un template à la page d’index scaffoldée. Dans ce template, on indique au système GSP comment faire le rendu de la table.

Générons à nouveau les vues scaffoldées de `ShortUrl` :

```shell
./grailsw generate-views ShortUrl
rm grails-app/views/shortUrl/index.gsp
```

Ensuite, on ajoute le template à utiliser sur l’élément `<f:table>` :

```html
[...]
<f:table collection="${shortUrlList}" template="shortUrlList" />
[...]
```

Puis on créé le template. Il doit se trouver dans `grails-app/views/templates/_fields/_shortUrlList.gsp`

Le contenu par défaut peut être trouvé dans le `grails-fields-plugin`. J’ai été le chercher dans son dépôt Github : [https://github.com/grails-fields-plugin/grails-fields/blob/master/grails-app/views/templates/_fields/_table.gsp](https://github.com/grails-fields-plugin/grails-fields/blob/master/grails-app/views/templates/_fields/_table.gsp)

Et je l’ai copié dans mon template afin d’en modifier les noms de colonnes et leur contenu :

```html
<table>
	[...]
	<tr>
		<th>Short urls</th>
		<th>Shortened urls</th>
	</tr>
	[...]
					<td>
						<g:link uri="/${bean.segment}">
							${g.createLink(uri: "/${bean.segment}", absolute: true)}
						</g:link>
					</td>
					<td>
						<a href="${bean.url}">
							${bean.url}
						</a>
					</td>
	[...]
</table>
```

Voici le résultat :

![](/assets/images/customized_shorturl_list_view.png)

## Étape 11 - La touche finale

Notre outil ressemble toujours à un site Grails "get started".

Alors changeons le logo (avec un qui soit libre) et le text de footer.

On peut faire cela sur toutes les pages en éditant le fichier `layouts/main.gsp` (rappel : nous sommes dans un framework de templating).

Pour le nouveau logo :

```html
<a class="navbar-brand" href="/#"><asset:image src="axe.svg" alt="Tawane’s url shortener Logo"/></a>
```

Avec un peu de redimensionnement dans `grails-app/assets/stylesheets/grails.css` :

```css
a.navbar-brand img {
	height: 55px;
}
```

Le nouveau footer :

```html
<div class="footer row" role="contentinfo">
	<div class="col">
		<p>Url shortener by tawane</p>
	</div>

	<div class="col">
		<p>Powered by Grails <g:meta name="info.app.grailsVersion"/></p>
	</div>

	<div class="col">
		<p>Served by Heroku with Gradle buildpack</p>
	</div>
</div>
```

![](/assets/images/touche_finale.png)

![](/assets/images/pagination.png)

Maintenant, prenons un moment pour jeter un coup d’œil sur tout le code écrit. Ce n’est pas tant que ça comparé au produit obtenu, n’est-ce pas ?

## Conclusion

On vient de développer une fonctionnalité complète from scratch, avec très peu de lignes de code, grâce à Grails.

On est resté concentré sur notre MVP, mais on a malgré tout plein de bonus sympas offerts par Grails :

* **La liste des `ShortUrl` est paginée !**
* La validation du formulaire html est complète, avec affichage des erreurs
* Redirection vers les pages 404/500 en cas d’erreur
* On a écrit presque zéro css tout en ayant un front décent
* Les fichiers CSS existent déjà et les classes des templates sont prêtes à être éditées
* La stack de tests (unit / integration / functional) est prête
* Notre app est responsive, grace au fichier mobile.css
* Notre formulaire est **SÉCURISÉ** ! Grails échappe chaque saisie utilisateur
* Les fichiers d’asset (images/css/js) sont minifié et leurs noms sont hashés grace au plugin `asset-pipeline`
* L’internationalisation est prête : Juste en valorisant les labels dans messages_ru.properties, les Russes peuvent utiliser le site

Si vous avez ressenti le pouvoir de Grails, essayez le avec cette app ou n’importe quelle autre idée, je vous promets que vous allez adorer ce framework.

Les sources complètes sont disponibles sur [github.com/t4w4n3/shorturl](https://github.com/t4w4n3/shorturl/)

Vous pouvez essayer l’app sur [https://intense-lake-67642.herokuapp.com/](https://intense-lake-67642.herokuapp.com/)  
Soyez patient, le serveur d’Heroku se coupe automatiquement au bout de 30 minutes d’inactivité. Son redémarrage prend environ 20 secondes si vous l’ouvrez.
