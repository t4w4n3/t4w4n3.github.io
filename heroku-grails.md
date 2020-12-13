Heroku + Grails : from idea to prod in 1 article
===

I recently (re-)discovered Heroku by watching [this video](https://www.youtube.com/watch?v=gq5yubc1u18) from the channel [Coding Garden](https://coding.garden/).

In this live coding, he try (and success) to build an urlshortener website from scratch, and deploy it to production thanks to Heroku PAAS and hits CLI, in 1 hour.

I asked myself "Could I do the same with my own stack ?"

Let's try !

The project
---

We will build a similar url shortener, where we can choose the url fragment.

The MVP is :

```
Given a form with 
    * an optional field for the fragment
    * a mandatory field for the url to shorten

When we fill an url to shorten,

And we click on "create",

Then the shortened url appears,

When we click on it or we open it,

Then we are redirected to the target url.
```

My stack
---

I'm a Java backend guy, who can alos do some stuff on frontend.

And I hate wasting time on basic configuration when I just want something that works.

(Note that I don't say I hate configuration).

So when I heard about "Convention over Configuration", I quitted JavaEE7/Weblogic/XML-everywhere, to embrace the Spring World.

But raw Springboot was not enough for me. I work on projects with micro time-to-market, and Java is too verbose to achieve complexe data structure with simple code.

Also, I don't seek for best perfomance code, but for best understability code.

And then, I adopted Groovy (It could have been Kotlin as well maybe).

Springboot handle Groovy very well, but why stopping to Springboot ?

Is there a mature convention-over-configuration JVM framework that works smoothly with Groovy ?

Of course : Grails  !

Requirements
---

* A JDK 15
* An Heroku account
* The [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli)
* Grails 4.1.0.M2 (any other version should do it)
* (optional) Intellij 

If you have sdkman :

```sh
sdk install grails 4.1.0.M2
sdk install java 15.0.1-open
```

Step 1 : bare Grails project

First, we have to start the grails project :

```sh
grails create-app shorturl
cd shorturl
```

Let's see what we have; by launching the dev mode :

```sh
./grailsw run-app
```

![](/home/t4w4n3/Images/run-app.png)

![](/home/t4w4n3/Images/welcomeToGrails.png)

Step 2 : Creating the main entity

We want to store url per fragment.

Let's create a domain class for that :

```sh
./grailsw create-domain-class shortUrl
```

We open it, and we create the attributs :

```groovy
class ShortUrl {

	String fragment
	String url

	static constraints = {
	}
}
```

See the  `constraints` field ?

We can add validation conditions for each field :

* The fragment :
  * Must be unique
  * Can be nullable on the front
* The url :
  *  Must be a valid url
  *  Must not be blank

```groovy
static constraints = {
	fragment unique: true, nullable: true
	url url: true, blank: false
}
```

Step 3 : Scaffold the ShortUrl entity

Now our domain is modelised, we can assume that every action a user can do in the frontend, is an aggregation of CRUD operation on the domain entities.

Luckily, we have only one entity, and the only CRUD operation available will be CREATE.

Building a frontend form for the CREATE operation is a wheel, and Grails know we don't want to re-invent it.

And so we will scaffold it !

Grails implements [Micronaut for Spring](https://micronaut-projects.github.io/micronaut-spring), so we are working on a MVC.

The scaffold starts from a Controller. Let's create it :
```Groovy
class ShortUrlController {
	static scaffold = ShortUrl
}
```

Stooooop ! Don't reload the app ! Grails has already done it ;)

Just open the browser :

![](/home/t4w4n3/Images/available_controller.png)

![](/home/t4w4n3/Images/shorturl_list.png)

![](/home/t4w4n3/Images/create_shorturl.png)

Step 4 : UrlMapping
---

The CREATE view should be our index page, no ?

We can achieve this with UrlMappings.groovy (which already exists) :

```groovy
class UrlMappings {
    static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

        "/"(controller: 'shortUrl', action: "create")
        "500"(view: '/error')
        "404"(view: '/notFound')
    }
}
```

When a user reach '/', he will be redirected to the 'create' action of the controller named 'ShortUrlController'.

> Which action you said ? There is no method in the ShortUrlController.

Yes, but no. The action 'create', 'save', 'get', 'update' are injected at compile-time in the controller, thanks to the scaffolding ;)

Step 5 : Make the fragment optional
---

Grails built the form based on the entity attributs types and constraints.

Let's make the fragment nullable :
```groovy
static constraints = {
    fragment unique: true, nullable: true
    url url: true, blank: false
}
```

![](/home/t4w4n3/Images/fragment_optional.png)

Much better ^^

But, we now have to randomly generate one if not set.

Let's create an initMethod in ShortUrl :
```groovy
void initFragment() {
	fragment = UUID.randomUUID().toString().take(5)
}
```
The UUID is for too long, so we only take the 5 first chars.

When we click on the 'create' button, the 'save' action is run.

Let's override the scaffolded implementation :

```sh
rm grails-app/controllers/shorturl/ShortUrlController.groovy
./grailsw generate-controller ShortUrl
```

Now we can add behavior to the default save :
```groovy
def save(ShortUrl shortUrl) {
    if (shortUrl == null) {
    	notFound()
    	return
    }

    if (!shortUrl.fragment) shortUrl.initFragment()
```

Step 6 :
---

We use a simple SSR design. So, the create button synchronously submit the form and redirect to the 'show' (get) action, where we can see the created object.

But we said earlier than the only CRUD action allowed is 'CREATE'.

So we will re-implement the 'show' (get) action, to actually do the redirection to the target url :

```groovy
def show(Long id) {
	redirect uri: ShortUrl.findByIdOrFragment(id, params.fragment as String)?.url
}
```
It still allows an id as param, but it also accept a fragment.

If a ShortUrl exists in the database with a matching id or fragment, it redirects to hits stored url.

Yes, ids and fragments can have collisions. Fixing that is not part of the mvp.

Now, the 

-----------------

```sh
./grailsw generate-controller ShortUrl
```

And tel Grails to actually do the scaffolding :
