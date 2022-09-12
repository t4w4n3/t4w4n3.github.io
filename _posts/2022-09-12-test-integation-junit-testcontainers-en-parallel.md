---
layout: post
title:  "Exécuter des tests TestContainers en parallèle avec Junit5"
date:   2022-09-12 14:31:42 +0100
categories: java junit5
---

# Les tests d'intégration TestContainers en parallèle avec Junit5

Dans la majorité des stack Java, la suite de test est orchestrée par la plateforme Junit.

C'est dans la config de Build Gradle ou Maven qu'on déclare la plateforme de test.

Exemple en Gradle avec le Kotlin DSL :

```kotlin
tasks.test {
    useJunitPlateform()
}
```

On sépare même parfois les tests unitaires des tests d'intégration.

Exemple :

```kotlin
val integrationTestFileNamePattern = "**/*IntegrationTest.*"

val integrationTest = task<Test>("integrationTest") {
    include(integrationTestFileNamePattern)
}

tasks.test {
    exclude(integrationTestFileNamePattern)
}

tasks.withType<Test>().configureEach {
    useJUnitPlatform()
}

tasks.check { dependsOn(integrationTest) }
```

Une fois séparés, on se dit alors que la step des tests d'intégrations est trop longue.  
On peut alors imaginer les faire tourner en parallèle, à condition qu'ils respectent le "I" des principes F.I.R.S.T :

* Fast
* **Isolated/Independent**
* Repeatable
* Self-validating
* Thorough

> **Isolated/Independent**
>
>For any given unit test, for its environment variables or for its setup. It should be independent of everything else
> should so that it results is not influenced by any other factor.
>
> -- source : <cite>https://medium.com/@tasdikrahman/f-i-r-s-t-principles-of-testing-1a497acda8d6 </cite>

Il existe 2 manière de paralléliser les tests unitaires en Gradle.

La première, avec Gradle lui-même :

```kotlin

tasks.withType<Test>().configureEach {
    maxParallelForks = Runtime.getRuntime().availableProcessors() - 1
}
```

On observe alors que ce sont les classes de test qui sont parallélisées et non les tests eux-mêmes.

Et la seconde, avec Junit 5 :

```kotlin
tasks.integrationTest {
    systemProperties["junit.jupiter.execution.parallel.enabled"] = true
    systemProperties["junit.jupiter.execution.parallel.mode.default"] = "concurrent"
}
```

On observe cette fois-ci que les tests d'une même classe sont, eux aussi, parallélisés.

Bon ok, à présent on souhaite tester un adaptateur secondaire (cf. architecture hexagonale) MongoDb ou PostgreSql.

On proscrit l'usage de solution InMemory comme H2, car elles sont trop distantes de la solution finale et le test ne
valide donc pas suffisamment l'intégration avec ce composant.  
On se tourne alors vers TestContainers.

TestContainers démarre un conteneur docker (ou [containerd](https://containerd.io/)) avec le même composant que celui
qui sera utilisé en environnement déployé.

Pour plus d'information sur la mise en place de
TestContainers, [Kévin Kouomeu](https://www.linkedin.com/in/kevin-kouomeu/) a un super article sur le sujet
=> https://www.younup.fr/blog/tests-integration-avec-springboot-docker-testcontainers

En dehors de la mise en place, TestContainers possède un mécanisme de gestion du cycle de vie des conteneurs demandés
dans les tests d'intégration composant.

Les 4 états du cycle de vie sont :

* Création
* Démarrage
* Arrêt
* Suppression

Pour déléguer cette gestion au framework TestContainers, il faut nécessairement ajouter
l'annotation `@org.testcontainers.junit.jupiter.Container` sur les variables de type `GenericContainer` (par
exemple `MongoDBContainer` ou `LocalStackContainer`).

La suppression est pilotée par un conteneur spécifique démarré par TestContainers, et adéquatement
nommé [Ryuk](https://fr.wikipedia.org/wiki/Ryuk).

Quand les tests passent séquentiellement, tout va bien avec cette configuration.

En revanche quand les tests passent en parallèle, Ryuk est perdu : **À la fin du test qui termine le permier, Ryuk
supprime tous les conteneurs**  
Résultat : Le prochain test à vouloir interagir avec un conteneur échoue à le contacter.

En effet, Testcontainers n'est pas nativement compatible avec la stratégie de parallélisation. L'issue Github est
toujours ouverte (au 12/09/2022) : https://github.com/testcontainers/testcontainers-java/issues/1495

La documentation de TestContainers propose qu'il est "parfois" utile d'utiliser le pattern du "Singleton
container" : https://www.testcontainers.org/test_framework_integration/manual_lifecycle_control/#singleton-containers

Ryuk ne supprimera alors cet unique conteneur qu'à la toute fin de la suite de test.

Cependant, cette même documentation nous prévient que ça ne suffit pas à éviter les effets de bords inattendus avec le
mode parallèle de Junit.

![singletonContainers.png](/assets/images/singletonContainers.png)

En effet, il manque un détail pour que ça fonctionne : `.withReuse(true)`

```java
public abstract class SingletonMongoContainer {

    @Container
    private static MongoDBContainer mongoDBContainer = new MongoDBContainer("mongo:5.0").withReuse(true);
}
```

Avec cette option, le `SingletonContainer` sera bien partagé entre les tests et leur thread respectif, et son cycle de
vie sera correctement géré.

Venons-en maintenant au boss final du donjon : **Utiliser 2 sous-types de `GenericContainer` dans un test d'une suite
exécutée en parallel**.  
Par exemple : Un `MongoDbContainer` + un `LocalStackContainer`.

On aurait donc besoin d'un `SingletonMongoDbContainer` abstrait et d'un `SingletonLocalStackContainer`.  
Problème : pas d'héritage multiple en Java.  
Passer par 2 interfaces plutôt que 2 classes abstraites ? Pas possible, car les variables de `GenericContainer` doivent
être `static`. Or les attributs d'une interface ont beau être `static`, ils se dupliquent sur chacune des implementation.
Et donc adieu l'unicité nécessaire.  
Dommage pas de `trait` en Java.

**Solution : 3 niveaux d'héritage**

```java
public abstract class SingletonMongoContainer {
    @Container
    private static MongoDBContainer mongoDBContainer = new MongoDBContainer("mongo:5.0").withReuse(true);
}

public abstract class SingletonLocalStackContainer extends SingletonMongoContainer {
    @Container
    private static LocalStackContainer localStackContainer = new LocalStackContainer(DockerImageName.parse("localstack/localstack:0.14.3"))
            .withClasspathResourceMapping("/localstack", "/docker-entrypoint-initaws.d", BindMode.READ_ONLY)
            .withServices(LocalStackContainer.Service.SQS)
            .withReuse(true);
}

public abstract class SingletonContainers extends SingletonLocalStackContainer {
}
```

```kotlin
class MyIntegrationTest : SingletonContainers(
    @Autowired private val messageRepository: MessageRepository,
    @Autowired private val queueMessagingTemplate: QueueMessagingTemplate,
    @Autowired private val webTestClient: WebTestClient,
) {
    @Test
    fun `should write all messages from queue into database`() {
        val usecase = MyUseCase(webTestClient, queueMessagingTemplate)
        val firstMessageId = usecase.sendFirstMessageToQueue()
        val secondMessageId = usecase.sendSecondMessageToQueue()
        val thirdMessageId = usecase.sendThirdMessageToQueue()
        messageIsPersisted(firstMessageId)
        messageIsPersisted(secondMessageId)
        messageIsPersisted(thirdMessageId)
    }
}

private fun messageIsPersisted(id: String) {
    await().atMost(ofSeconds(5)).untilAsserted {
        runBlocking {
            var message: Message? = null
            try {
                message = messageRepository.getById(messageId)
            } finally {
                message shouldNotBe null
            }
        }
    }
}
```

Résumé des états du cycle de vie de la suite de tests d'intégration composant :

1. Les classes abstraites initialisent leurs variables static
2. Les `GenericContainer` de `SingletonMongoContainer` et de `SingletonLocalStackContainer` sont instanciés
3. Les tests sont scannés par Junit
4. Les conteneurs sont tous démarrés
5. Les tests s'exécutent en parallèle
6. Junit publie l'évènement de fin de la suite de test
7. Les classes de test et leurs abstractions sont alors garbage-collectées, ce qui passent par le code d'arrêt des
   conteneurs
8. Ryuk supprime les conteneurs

`Build Successful`

## Conclusion

TestContainers et la stratégie de parallélisme de Junit ont quelques cas d'usage d'incompatibilité avec la configuration
par défaut.  
Mais en modifiant adéquatement la configuration des différents outils impliqués (Java, Spring, Springboot,
TestContainers, Junit5), on peut arriver à résoudre ces incompatibilités.
