Orienter ses choix techniques en Java avec le microbenchmarking
===============================================================

## Partie 2

Voir la [partie 1](article-jmh-01.html).  

À leur retour du café, Benjamin passe [navigateur](https://en.wikipedia.org/wiki/Pair_programming) et Bertrand passe [conducteur](https://en.wikipedia.org/wiki/Pair_programming).
Avant leur pause, ils avaient expérimenté les annotations de JMH dans un HelloWorld, et ils étaient prêt à passer au code de prod.

### Benchmark du code de prod

```java
public class MyBenchmark {

    @State(Scope.Benchmark)
    public static class MyState {

        public DuckService duckService = new DuckService();
        public DuckFactory duckFactory = new DuckFactory();

        public MyState() {
            duckService.ducks = duckFactory.createDucksWithRandomColors(100);
        }
    }

    @Fork(value = 1)
    @BenchmarkMode(Mode.AverageTime)
    @Warmup(iterations = 2)
    @Measurement(iterations = 2)
    @OutputTimeUnit(TimeUnit.MICROSECONDS)
    @Benchmark
    public void makeAllYellowDucksQuackWithStreamBenchMark(MyState myState) {
        myState.duckService.makeAllYellowDucksQuack();
    }
}
```

### Le Jeu de données

#### L'annotation `@State`
L'étape d'instanciation du JDD ne doit pas être comptabilisée dans le bench.  
On le génère donc dans une classe (statique ou pas) annotée de `@State`.  
Son scope se limite aux méthodes de benchmark, ou aux threads (forks).  
Cela signifie qu'entre le benchmark de la méthode `makeAllYellowDucksQuackWithStreamBenchMark` et celui de la méthode `filterYellowDucksWithForLoopBenchmark`, l'état (`State`) sera ré-instancié malgré sa nature statique.

#### Idempotence
> :warning: **Attention aux JDD randomisés !**

Pour des résultats fiables, il est impératif d'utiliser le même JDD à chaque itération.
Ici la méthode `createDucksWithRandomColors()` n'est en fait pas du tout random.  
Elle est [idempotente](https://fr.wikipedia.org/wiki/Idempotence). Elle créé toujours le même JDD (depuis un fichier CSV).  
Par contre ce csv contient bien un JDD randomisé.  
Ce n'est pas le sujet ici, mais je vous donne une implémentation grossière (et efficace) pour charger le csv en `List<Duck>` :
```java
public List<Duck> createDucksWithRandomColors(int number) {
    List<Duck> collect = IntStream.range(0, number).mapToObj(i -> new Duck()).collect(toList());
    List<Integer> yellowDucksIndexes = new ArrayList<>();
    /* Contient une liste ordonnée d'entiers uniques aléatoires entre 0 et 1_000_000.
       Ils représentent les index des canards qui doivent être jaunes.*/
    File file = new File("src/main/resources/yellowDucksIndexes.csv");
    try (Scanner scanner = new Scanner(file)) {
        String nextLine;
        while (scanner.hasNextLine()) {
            nextLine = scanner.nextLine();
            yellowDucksIndexes.add(Integer.parseInt(nextLine));
        }
    } catch (Exception e) {

    }
    for (int i = 0; i < number; i++) {
        try {
            collect.get(yellowDucksIndexes.get(i)).color = Color.Yellow;
        } catch (Exception e) {
            break;
        }
    }
    return collect;
}
```

Le résultat pour 100 canards :
```
100:
Benchmark                                          Mode  Cnt        Score   Error  Units
MyBenchmark.filterYellowDucksWithStreamBenchmark   avgt    2    47462,131          us/op
```

Et pour d'autres tailles d'élevage :

| Taille élevage | Quacking time | Quacking time by duck |
|:--------------:|:-------------:|:---------------------:|
|        5       |      5667     |        1133,40        |
|       10       |      7116     |         711,60        |
|       100      |     47462     |         474,62        |
|      1000      |     623488    |         623,49        |
|      10000     |    5714675    |         571,47        |


Un quack mettant environ 1ms, on note que la compilation JIT a économisé pas mal d'instructions sur les longues listes.

### Stream vs forLoop vs parallelStream

Voyons les performances d'autres implémentations de quacking :

```java
public void makeAllYellowDucksQuackWithForLoop() {
    for (Duck duck : ducks) {
        if (duck.isYellow()){
            duck.quack();
        }
    }
}
public void makeAllYellowDucksQuackWithParallelStream() {
    ducks.parallelStream().filter(yellowDucks).forEach(makeItQuack);
}
```
```java
    @State(Scope.Benchmark)
    public static class MyState {
        public DuckService duckService = new DuckService();
        public DuckFactory duckFactory = new DuckFactory();
        {
            duckService.ducks = duckFactory.createDucksWithRandomColors(100);
        }
    }

    @Fork(value = 1)
    @BenchmarkMode(Mode.AverageTime)
    @Warmup(iterations = 2)
    @Measurement(iterations = 2)
    @OutputTimeUnit(TimeUnit.MICROSECONDS)
    @Benchmark
    public void filterYellowDucksWithForLoopBenchmark(MyState myState) {
        myState.duckService.makeAllYellowDucksQuackWithForLoop();
    }
    
    @Fork(value = 1)
    @BenchmarkMode(Mode.AverageTime)
    @Warmup(iterations = 2)
    @Measurement(iterations = 2)
    @OutputTimeUnit(TimeUnit.MICROSECONDS)
    @Benchmark
    public void filterYellowDucksWithParallelStreamBenchmark(MyState myState) {
        myState.duckService.makeAllYellowDucksQuackWithParallelStream();
    }
```

```
Benchmark                                          Mode  Cnt        Score   Error  Units
MyBenchmark.filterYellowDucksWithForLoopBenchmark  avgt    2    47650,604          us/op
MyBenchmark.filterYellowDucksWithParallelStream    avgt    2     7303,440          us/op
MyBenchmark.filterYellowDucksWithStreamBenchmark   avgt    2    47462,131          us/op
```

L'implementation `filterYellowDucksWithParallelStream` semble être plus performante.
Voyons pour des tailles d'élevages différentes :

| Taille élevage | Quacking time | Quacking time by duck |
|:--------------:|:-------------:|:---------------------:|
|        5       |      1902     |         380,40        |
|       10       |      1731     |         173,10        |
|       100      |      7303     |         73,03         |
|      1000      |     84254     |         84,25         |
|      10000     |     740131    |         74,01         |

Même pour seulement 5 canards, le temps d'inititalisation du stream et les temps de fork/merge du thread-pool sont négligeables.  
> :warning: **Ça n'aurait pas été le cas si le temps d'un seul quack avait été de l'ordre de la nanoseconde/microseconde !**

## Conclusion

Grâce aux microbenchmarks et JMH, ils savent qu'ils ont résolu leur problème de contention, avant même de renvoyer les correctifs au bencheur.

## Disclaimer on results

Les microbenchmarks révèlent effectivement que des implémentations sont plus efficaces que d'autres.
Cependant il faut toujours avoir en tête la volumétrie de production, afin de pouvoir répondre à la question :
**"Est-ce que ca vaut vraiment le coup de refactorer ?"**
Car il y a d'autres objectifs pour le code, entre autres :
* La lisibilité
* L'évolutivité
* La modularité

Si le gain de temps est de quelques nanosecondes pour très peu d'itérations, on préferera conserver une implémentation plus simple, et/ou plus conpréhensible.  
En utilisant régulièrement JMH, on découvre que les for-loop sont très souvent plus rapides que leur équivalent fonctionnel, mais elles sont aussi très souvent plus complexes<sup>[^4]</sup> et/ou plus compliquées<sup>[^5]</sup>.  
Avant de re-factorer, on se re-pose alors les questions :
* **"Quelle est ma volumétrie ?"**
* **"Quelle est la latence max admissible ?"**

## Pour aller plus loin

### Benchmarks as test
En changeant le scope de la dépendance Maven JMH en `test`, on peut envisager d'asserter les résultats dans des TU.

Et donc, à suivre : [Benchmark As Unit-Test, asserting methods performances](en-construction.html) ;)

--------------------

[^4]: Complexe : Difficile à prédire.  
[^5]: Compliqué : Difficile à comprendre
