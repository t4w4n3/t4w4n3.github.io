---
layout: post
title:  "Resilience with Java : The rate limiter"
date:   2022-10-15 12:00:00 +0100
categories: java
---

# Resilience with Java : The rate limiter

    The database admin : Please, reduce the number of incoming queries, because the CPU load of the database is too high.
    
    Me : Ok, how many queries can it handle properly ?
    
    The database admin : about 350 a second, less or more
    
    Me: Ok, then we will throttle the queries flux with a rate limiter.

## Introduction

If you can't enlarge a bottleneck, then reduce the size of the incoming pipe.  
Otherwise the component after the neck risks to overload, then break. In a parallel context, it can be done with a rate-limiter (throttling).

A slower response is better than no response and lost data.

![/assets/images/rate_limiter.png](/assets/images/rate_limiter.png)

## An exemple in the Java world, with Resilience4j

Resilience4j is a lightweight fault tolerance library inspired by Netflix Hystrix, but designed for Java functional
programming. It is lightweight, because the library only uses Vavr, which does not have any other external library
dependencies.

It has 6 Core Modules : CircuitBreaker, RateLimiter, Retry, Bulkhead, Cache and TimeLimiter.

Resilience in distributed systems is the ability of a system to continue to function even when unexpected events occur.

Here we will use the RateLimiter.

[https://resilience4j.readme.io/docs/ratelimiter](https://resilience4j.readme.io/docs/ratelimiter)

Lets start with a simple use-case : an `executorService` is given a threadpool of 1000 and is submitted 1000 times this
task :

```java
public class App {
    private static void someBlockingIOs() {
        try {
            sleep(550); // Some blocking IOs
            System.out.println("Hello world");
        } catch (InterruptedException ignored) {
        }
    }
}
```

We run and measure the rate of "Hello world"s with this code (this is a very hacky way to measure the rate, but it is
enough for our purpose) :

```java
public class App {
    public static void main(String[] args) {
        int numberOfTasks = 1_000;
        var start = Instant.now();
        try (ExecutorService executor = Executors.newFixedThreadPool(1000)) {
            range(0, numberOfTasks)
                    .mapToObj(i -> (Runnable) RateLimiterPocApplication::someBlockingIOs)
                    .forEach(executor::submit);
            executor.shutdown();
            System.out.println("All tasks have completed successfully : " + executor.awaitTermination(1, MINUTES));
        }
        var end = Instant.now();
        long durationInMillis = end.toEpochMilli() - start.toEpochMilli();
        System.out.println("durationInMillis : " + durationInMillis);
        System.out.println("rate : " + (double) numberOfTasks / durationInMillis * 1000 + " tasks/second");
    }
}
```

And we get this result :

```log
[...]
Hello world
Hello world
All tasks have completed successfully : true
durationInMillis : 615
rate : 1626.0162601626016 tasks/second
```

The rate is 1626 tasks/second, which is more than the 350 tasks/second that the database can handle.

Ok, now let's create a rate-limiter from Resilience4j, with a limit of 350 per period of 1000 ms :

```java
public class App {
    static RateLimiterConfig config = RateLimiterConfig.custom()
            .limitRefreshPeriod(Duration.ofMillis(1000))
            .limitForPeriod(350)
            .build();
    static RateLimiterRegistry rateLimiterRegistry = RateLimiterRegistry.of(config);
    static RateLimiter customRateLimiter = rateLimiterRegistry.rateLimiter("ratelimiter");
}
```

Then, we can decorate each runnable with the rate-limiter :

```java
range(0, numberOfTasks)
    .mapToObj(i -> (Runnable) RateLimiterPocApplication::someBlockingIOs)
    .map(runnable -> RateLimiter.decorateRunnable(customRateLimiter, runnable))
    .forEach(executor::submit);
```

And when we run it again we observe the right rate of tasks per second (~350) : 
```log
[...]
Hello world
Hello world
All tasks have completed successfully : true
durationInMillis : 2570
rate : 389.10505836575874 tasks/second
```

## Conclusion

The library Resilience4j is really easy to set up into existing code thanks of its use of the decorator pattern around each types of the Java Function API.  
It effectively reduced the rate of parallel execution of tasks with blocking calls inside.  
We didn't show it, but Resilience4J also have compatibility with many libraries and frameworks : rxJava3, Micronaut, Spring-Cloud, ...

Don't forget it in a distributed architecture where deployment entities all have different scaling capacities. Then, you will finally be allowed to use the word "microservices".

Sources can be found here : [https://github.com/t4w4n3/ratelimiter-demo](https://github.com/t4w4n3/ratelimiter-demo)
