# Tester un controller Spring avec Spock

Tous les projets Spring ne sont pas des projets Springboot. Et dans un contexte de production, ajouter les dépendances springboot pour juste disposer des apports  dev-tools risque de faire bien plus que cela, comme par exemple : Forcer des montées de versions de dépendances communes.

J'ai eu à apporter des changements sur un controller Spring MVC non couvert unitairement, tandis que le framework de test de l'équipe était [Spock](http://spockframework.org/).

Il me fallait donc ajouter la conf adéquate pour l'autowiring du MVC dans la class de Spec.

Pour cela, la [doc Spring.io](https://spring.io/guides/gs/testing-web/) est bien gentille, mais elle suppose d'avoir (ou de pouvoir avoir) des dépendances spring-boot avec Gradle.  
Or les contraintes d'un projet de donnent pas toujours la possibilité d'ajouter les dépendances spring-boot-starter, ou alors notre projet est un bon vieux Spring/Maven.

Je détail donc dans cet article comment intégrer le framework de test Spock dans un projet Spring MVC sans Springboot, à l'aide de :

* spock-core
* MockMVC
* spock-spring

## MockMvc requirements

* Spring : 3.2.x **+**

## Spock-spring requirements

* Junit  : 4.9
* spock-core : 1.3-groovy-2.4
* Groovy : 2.4

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

MockMvc appartient à spring-test, qui est tirée par spock-spring.

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

```java
package fr.younup.helloworldapp.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.ModelMap;

@Controller
public class HelloWorldController {

    @RequestMapping(value = {"/helloworld/html/"})
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
        MvcResult mvcResult = mockMvc.perform(get("/helloworld/html/")
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

