# La résilience avec Java : Le limiteur de débit

Avant de parler du limiteur de débit (rate-limiteur / throttling), qu'est-ce que la résilience logicielle ?

C'est un ensemble de patterns et de techniques pour mitiger les défaillances de parties du système, afin de maintenir temporairement le système en mode dégradé plutôt qu'en arrêt total. 

Cette mitigation devient indispensable dans les systèmes distribués.

## Le limiteur de débit (rate-limiteur / throttling)

Étant donné 2 composants A et B étant chacun une unité de déploiement à part entière, le composant A émet des appels à l'API du composant B. Par exemple, une application backend A qui envoi des requêtes sql à une base de données B.

La quantité de requêtes émises peut impacter la charge CPU de la base de données, et ainsi sa qualité de service.

On préfère une application qui répond plus lentement, plutôt que pas du tout.

Ici le goulot d'étranglement semble être le CPU de la base de données.

Si on ne peut pas agrandir un goulot d'étranglement, alors réduisons plutôt la taille du tuyau entrant.

C'est l'intérêt du pattern de résilience "Limiteur de débit".

## Exemple de scénario d'adaptation de débit entre 2 composants

Une métrique Micrometer de type "Timer" est posée sur une requête de lecture dans la table des factures.

`invoiceRepository.fetchTotalTva(Month month, Client client)`

On observe dans Prometheus que cette métrique (le temps mis pour une lecture) a tendance à s'envoler à partir de 100 requêtes par secondes. À tel point que les temps de réponses dépassent les timeout.

La solution : surveiller le temps de réponse de la méthode `invoiceRepository::fetchTotalTva`.  
Quand il dépasse un seuil préétabli, alors limiter le débit d'exécution de la méthode.  
Quand il redescend sous ce seuil, alors stopper ou diminuer la limitation de débit.

## Implementation en Java (19), avec la librairie Resilience4J

