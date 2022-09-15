# Le tour du monde - étude de faisabilité

Le tour du monde en 80 :

* Requêtes http
* Instructions
* Lignes de code
* jours

Les instructions ne servent pas qu'à se déplacer, mais aussi à obtenir des informations sur la map.

* Pour commencer une partie, je dois envoyer un POST sur http://localhost:8080/tour_du_monde_80/game avec comme body :

```json
{
  "player": "monPseudo",
  "password": 123
}
```

* Je peux réinitialiser le jeu en envoyant un DELETE sur http://localhost:8080/tour_du_monde_80/game avec comme body :

```json
{
  "player": "monPseudo",
  "password": 123
}
```

* Je dois ensuite ajouter le header "player=monPseudo" à toutes mes requêtes pour qu'elles soient acceptées

## Brainstorm area

### Idée 1

On comptabilise les appels API rest
Pour réussir le challenge, il faut en avoir 80 max.
Si on réussit le challenge, on gagne un petit lot.
Pour les 3 premiers (le moins d'appels), des plus gros lots.

### Idée 2

Entre les "villes"/localisations, il y a des distances et donc du temps.
Il y a un challenge sur le nombre de jours réalisés et le challenge serait d'être le plus proche des 80 jours.

Ils peuvent faire autant de ligne de code qu'ils veulent, dans le langage qu'ils veulent

Pour chaque langage, on leur fournit des snippet à copier-coller. Exemple :

* Un client rest, avec des get, des post, des headers, ...

Il y aurait plusieurs moyens de locomotion, avec des contraintes différentes. Exemple :

* Le prix d'un trajet (pas dans le MVP évidemment)
* La vitesse
* Doit être adapté au type du terrain (pour traverser la mer, il faut un truc qui vole ou qui flotte)

Moyens de locomotions :

* Train
* Montgolfière
* Bateau
* Piéton
* Calèche

Quand on fait un trajet mentionné dans le bouquin, on a secrètement un bonus et un easter egg.
Quand on utilise le même moyen de locomotion sur un trajet que dans le bouquin, on a secrètement un bonus et un easter egg.

## Réalisation

On a besoin d'un front.

On y verrait :

- Un monde
	- 2d
	- 3d
- L'emplacement du joueur
- Le trajet déjà parcouru

### Design

Contacts

* Romain
* Grégoire ?
* poster un message sur le teams

8bits ?

image::../../../../Images/mapmondejulesverne.jpeg[]

https://webdesignerwall.com/demo/interactive-map/

image::../../../../Images/julesvernes_jolie_map.png[]

https://observablehq.com/@d3/world-tour

d3-geo de d3.js

Il y aurait un système de coordonnées, afin d'y placer/déplacer les objets.

### Rendu

* moteur de jeux vidéo ?
* html/css ?
* lib web ?

Déplacer un object (personnage) d'un point à un autre peut se faire facilement en css.

Libs :

* Three.js
* phaser.io => https://phaser.io/examples
* Lib de cartographie

## Logistique

Un pc/clavier/écran sur le stand
(azerty/qwerty/bepo)

## MVP

### Story Telling

En tant que développeur connaissant le JS,
j'arrive sur le stand de Younup.

J'y vois un grand écran sur lequel apparait :

* une carte du monde aux inspirations Jules Verne
* Des points d'intérêt
* Un personnage d'inspiration Jules Verne sur le point qui semble être la ville de XXX

Sur le stand, en face de l'écran se trouve un pupitre ave un laptop ouvert sur un éditeur de code.
On me propose alors de relever un challenge de code sur le thème de Jules Verne.
La carte affichée sur l'écran est en fait interactive.
Le personnage doit faire le tour du monde et revenir à son point de départ.

Pour valider son tour du monde, il doit passer par des endroits stratégiques avant de revenir.

* endroit 1
* endroit 2
* endroit 3

Pour interagir avec cette carte, je dois envoyer des requêtes http à une API rest :

* Les GET servent à obtenir des informations sur la carte, sur les destinations possibles à partir de la position courante
* Les POST servent à envoyer des ordres d'actions à notre personnage afin qu'il aille se rendre sur une des destinations possibles
* L'url de départ qui m'est donnée est http://localhost:8080/tour_du_monde_80/


On me demande quel langage et quel IDE je souhaite utiliser pour ce challenge.
Je choisis le Javascript et VsCode.

On me positionne alors sur un VsCode, et on m'indique un dossier contenant des snippet de code Javascript tels que :

* Un client http
* Des exemples de requêtes http avec ce client, avec des headers et un body

J'ai également accès à un Postman contenant une seule requête : un GET vers http://localhost:8080/tour_du_monde_80/ avec un header "player" vide.

C'est parti, je commence le challenge.

Je crée un fichier JS App.js.
J'y crée un fonction main().
J'envoie un GET sur http://localhost:8080/tour_du_monde_80/
Je reçois une réponse 405 avec comme body {
	"message": "Veuillez créer une nouvelle partie"
	"_links": {
		"game": {
			"href": "/game",
			"type": "POST",
			"body": {
				"player": "monPseudo",
				"password": 123
			}
		} 
}

Juste avant cette requête, je colle un snippet JS de requête POST :
POST http://localhost:8080/tour_du_monde_80/game
{
"player": "monPseudo",
"password": 123
}
J'exécute mon code.
Mon pseudo apparait sur la carte, à côté du personnage
J'ajoute à la fin de mon code un DELETE :
DELETE http://localhost:8080/tour_du_monde_80/game
{
"player": "monPseudo",
"password": 123
}
Je l'exécute seule.
Mon pseudo disparait de l'écran.
Je ré-exécute le tout.
Le GET me renvoie un 200 avec comme body :
{
	"message": "Vous êtes à xxx. Vous devez faire le tour du monde, c'est-à-dire passer par 4 endroits dont \"endroit1\", \"endroit2\", \"endroit3\" puis retourner à votre point de départ",
	"destinations": [
		{
			"name": "xxx1",
			"duration": "3"
		},
		{
			"name": "xxx2",
			"duration": "4"
		}
	],
	"_links" : {
		"move" : {
			"href": "move/xxx1",
			"type": "POST"
		},
		"plan_xxx" : {
			"href": "plan/xxx",
			"type": "GET",
		},
		"plan_xxx1" : {
			"href": "plan/xxx1",
			"type": "GET",
		},
		"plan_xxx2" : {
			"href": "plan/xxx2",
			"type": "GET",
		}
	}
}
Les localisation xxx1 et xxx2 changent de couleur sur l'écran, avec un style graphique qui semble indiquer que je ne peux aller qu'ici.
Je code une requête POST pour aller à xxx1.
Mon personnage se déplace de xxx à xxx1 selon une courbe.
Je code une requête GET pour obtenir des informations sur la localisation xxx1.
De nouvelles destinations me sont indiqué en réponse, et elles apparaissent aussi sur la carte.
Je code une requête POST pour aller à xxx3.
Mon personnage s'y déplace.
Ainsi de suite, je réussis à passer par les 3 endroits checkpoints, puis je retourne à mon point de départ.
En y arrivant, "victoire" apparait sur l'écran.
Y apparait aussi "4ème sur 25 : Tour du monde en 87 jours".
3 autres joueurs ont donc réussi à faire ce tour du monde, mais étaient plus proche de 80 jours que moi.

### Estimation

#### Front

Taches :
* Trouver une image de fond pour la carte du monde, d'ambiance Jules Verne
  * L'afficher
* Mettre en place un système de coordonnées x/y
* Pouvoir placer des points sur la carte à partir de coordonnée 
* Trouver une image de personnage, d'ambiance Jules Verne
  * Pouvoir la placer à côté d'un point à partir de son id (on récupère le point d'id 123, puis on choppe ses coordonnées, puis on déplace le personnage jusque-là)
* Pouvoir afficher des messages sur l'écran à plusieurs endroits :
  * En haut à droite pour le pseudo du joueur
  * À côté des points
  * Au milieu pour le message de fin de partie
* Pouvoir déplacer l'image du personnage d'un point à un autre, suivant une ligne droite d'abord, puis suivant une courbe.
  * La durée du déplacement doit être spécifiable en secondes. Exemple : je veux que le front déplace le personnage du point A au point B en 3 secondes.
* 