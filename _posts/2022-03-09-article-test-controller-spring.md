---
layout: post
title:  "Tester un controller Spring avec Spock"
date:   2022-03-09 12:00:00 +0100
categories: java spring mvc spock
---

# Tester un controller MVC Spring avec Spock

Je suis intervenu sur u/n projet Spring-core avec Spring-MVC sans test unitaire ni d'intégration.  
Pour y apporter des modifications, il m'a alors fallu lui ajouter une stack de test.  
Le framework de test choisi par l'équipe était [Spock](http://spockframework.org/) et non Junit.

Or, l'utilisation de spock pour les tests d'intégration Spring-MVC m'avait posé quelques difficultés, dont j'explique dans cet article comment les surmonter.

## Spring-Mvc / Spock : les difficultés

Dans un projet Springboot / JUnit, ajouter la dépendance springboot-starter-test suffit à disposer de la conf nécessaire pour écrire des tests d'intégration MockMvc.

Là, on n'a ni SpringBoot ni Junit.

Il va donc falloir démarrer un context Spring Mvc dans un test d'intégration Spock.

On va alors avoir besoin de :

* Spock-core (le cœur du framework Spock)
* Groovy 2.4 (nécessaire à Spock)
* Le plugin Gmavenplus afin de compiler les classes de test Spock écrites en Groovy 
* Spock-spring, qui va tirer spring-test, qui lui-même va tirer MockMvc (pour initialiser un context Spring mvc depuis un test Spock)

J'avais dû upgrader la version de Spring en 3.2 afin de pouvoir utiliser MockMvc.
Ainsi que Junit en 4.9 pour spock-spring.

## Configuration du projet Maven

Le langage utilisé dans Spock est Groovy, et il faut alors ajouter la dépendance `groovy-all`  au scope de test :
```xml
<dependency>
    <groupId>org.codehaus.groovy</groupId>
    <artifactId>groovy-all</artifactId>
    <version>2.4.1</version>
    <scope>test</scope>
</dependency>
```
Puis on ajoute les autres dépendances (toujours dans le scope de test) :

```xml
<dependency>
    <groupId>org.spockframework</groupId>
    <artifactId>spock-core</artifactId>
    <version>1.3-groovy-2.4</version>
    <scope>test</scope>
</dependency>
<dependency>
    <groupId>org.spockframework</groupId>
    <artifactId>spock-spring</artifactId>
    <version>1.3-groovy-2.4</version>
    <scope>test</scope>
</dependency>
<dependency>
    <groupId>org.hamcrest</groupId>
    <artifactId>hamcrest-all</artifactId>
    <version>1.3</version>
    <scope>test</scope>
</dependency>
```

Pour que les tests Spock soient exécutés par la phase `test` de Maven, il faut y inclure leur filename pattern :

```xml
<plugin>
    <artifactId>maven-surefire-plugin</artifactId>
    <version>2.19.1</version>
    <configuration>
        <includes>
            <include>**/*Test*.*</include>
            <include>**/*Spec*.*</include>
        </includes>
    </configuration>
</plugin>
```

Surefire recherche ces patterns dans le répertoire `target` et non dans le répertoire `src`.
Il faut donc que la phase `compile` n'oublie pas nos fichiers Spock du genre `HelloWorldControllerSpec.groovy`.  
Pour cela, on a le plugin gmavenplus :

```xml
<plugin>
<groupId>org.codehaus.gmavenplus</groupId>
<artifactId>gmavenplus-plugin</artifactId>
<version>1.6</version>
<executions>
    <execution>
        <goals>
            <goal>compileTests</goal>
        </goals>
    </execution>
</executions>
<configuration>
    <testSources>
        <testSource>
            <directory>${project.basedir}/src/test/groovy</directory>
            <includes>
                <include>**/*.groovy</include>
            </includes>
        </testSource>
    </testSources>
</configuration>
</plugin>
```

## Un simple controller helloWorld

Je n'ai plus le code en question sous la main, alors voici un exemple de controller Spring-mvc parfait pour la démo :

```java
package fr.younup.helloworldapp.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.ModelMap;

@Controller
public class HelloWorldController {

    @RequestMapping(value = {"/helloworld/"})
    public final String showHelloWorld(
        @ModelAttribute(value = "helloWorldModel") final HelloWorldModel helloWorldModel,
        final ModelMap model,
        final HttpServletRequest request
    ) {
        model.addAllAttributes("helloWorldModel", helloWorldModel);
        return "/pages/helloWorld";
    }
}
```

## Implémentation de la classe de test d'un controller MVC

```groovy
package fr.younup.helloworldapp.controller

import fr.younup.helloworldapp.model.helloWorldModel
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.MediaType
import org.springframework.mock.web.MockHttpServletRequest
import org.springframework.test.context.ContextConfiguration
import org.springframework.test.context.web.WebAppConfiguration
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.setup.MockMvcBuilders
import org.springframework.ui.ModelMap
import org.springframework.web.servlet.view.InternalResourceViewResolver
import spock.lang.Specification

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status

@WebAppConfiguration
@ContextConfiguration("/META-INF/spring/applicationContext.xml")
class HelloWorldControllerSpec extends Specification {

    MockMvc mockMvc

    @Autowired
    HelloWorldController controller

    void setup() {
        InternalResourceViewResolver viewResolver = new InternalResourceViewResolver()
        viewResolver.setPrefix("/WEB-INF/")
        viewResolver.setSuffix(".jsp")
        this.mockMvc = MockMvcBuilders.standaloneSetup(controller).setViewResolvers(viewResolver).build()
    }

    void "La page helloWorld est rendered avec un model conforme aux paramètres de la requete"() {
        when:
        MvcResult mvcResult = mockMvc.perform(get("/helloworld/")
                .header('Accept-Language', 'FR')
                .contentType(MediaType.ALL)
                .param('prenom', 'Bob')
        ).andReturn()
        
        and:
        def response = mvcResult.response()

        then:
        response == '/pages/helloWorld'
        mvcResult.modelAndView.model.helloWorldModel.class == HelloWorldModel
        mvcResult.modelAndView.model.prenom == 'Bob'
    }
}
```

## Conclusion

Malgré l'absence du très pratique springboot-starter-test, spock-spring permet de monter un contexte Spring-mvc dans un test Spock afin de tester un controller intégration.

Il faut toutefois bien configurer la cross-compilation Java/Groovy au niveau du scope de test, afin que les tests écrits soient effectivement compilés et exécutés par le lifecycle Maven.

Les versions legacy de ce projet associées au côté modern de Spock me font penser que cet article ne servira pas souvent, mais qui sait ...

Si avez besoin de tester un controller Spring avec Spock dans un cadre Springboot, ça devrait aider aussi.
