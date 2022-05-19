1. Ça ne serait jamais arrivé dans un menhir

À qui je m'adresse :

Aux dev qui on déjà connu un projet avec plusieurs applications qui communiquent par le réseau, fortement couplées, interdépendantes.
(un monolith distribué). Sur ce genre de projet, la moindre modification a des impacts potentiels fort sur tout le système, et nécessite beaucoup de tests hauts dans la pyramide.
La système ne peut être mis en prod que dans son entièreté, la mep est un évèvement, demande une coordination et des go/nogo de toutes les teams.

C'est quoi l'objectif du talk :

Montrer que c'est la perte de consistence qui cause la plupart des problèmes de coordinations entre les équipes, et qu'elle-même est causée par la distribution du monolith à travers le réseau.
En effet, les transaction ne se propagent pas naturellement à travers le réseau sans passer par des pattern de transaction distribuées compliquées.
Or les transactions sont une forte source de consistence dans un système.


Montrer que les termes utilisés dans ce genre de projet sont une mascarade ( exemple : intégration continue).


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

9. Talk sur la consistence : 


