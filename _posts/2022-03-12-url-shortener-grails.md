---
layout: post
title:  "An url-shortener built with Grails"
date:   2022-03-12 11:50:40 +0100
categories: java grails
---

# Grails 5 demo with a simple url-shortener

I recently watched [this video](https://www.youtube.com/watch?v=gq5yubc1u18) from the Youtube channel [Coding Garden](https://coding.garden/).

In this recorded live coding, he try (and success) to build an url-shortener website from scratch, and deploy it to production thanks to Heroku PAAS and its CLI, in 1 hour.

I was like :

> Waou, such mastery of his tools !

And I asked myself :

> Could I code it as quick with my own stack ?"

Let's try !

## What is an url shortener

Very Simple.

You have a big url and for some reasons you need it to be tiny (remembering, displaying).

So you go to an url shortener tool.

You give to it your freaking long url.

It gives you back a tiny url that redirects to yours.

## My own stack

I'm a Java backend guy, who can also do some stuff on frontend.

I will use Grails 5.1.3 which bundles (with some minor personal upgrades) :

- Gradle 7.4.1
- Java 15
- Groovy 3.0.10
- Hibernate 5.5
- Micronaut 3.2.7
- Springboot 2.6.4
- Tomcat 9.0
- Spring 5.3.16

Java 15 is the higher version with full compatibility with Groovy 3. For Java 17/18, we have to wait Groovy 4 and Grails 6.

The framework offers backend and frontend support.

You can find me old-school, but I like HTML templating. Not the Jsp/Jstl kind of template. A much modern one : GSP (Groovy Server Pages). It's the main view component of the Grails Framewok.

## Requirements

* A JDK between 8 and 15
* Grails 5.1.3
* (optional) Intellij => great Grails support

If you have [sdkman](https://sdkman.io/) :

```sh
sdk install grails 5.1.3
sdk install java 11.0.12-open
```

And if you don't have it, go get it :wink: :

```sh
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
```

## Step 1 : Bare Grails project

First, we have to start the grails project :

```sh
grails create-app shorturl
cd shorturl
```

Let's see what we already have; by launching the dev mode with the Grails wrapper :

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

Grails dev mode supports hotreload, so let's keep our app running.

### Front-end caption :

> ![](/assets/images/welcome-to-grails.png)

## Step 2 : Creating the main entity

Basically, what we want is to store `url` per `segment`.

You know what an url is.

A segment is a chunk of an url, between slashes.

> https://t4wan3.github.io/grails/url-shortener-grails

In this url, "blog", "grails" and "url-shortener-grails" are segments.

Grails achieves database persistence through `domain-classes` which are equivalent to `Entity` + `JpaRepository` in Spring.

Let's create a domain class for that :

```sh
./grailsw create-domain-class shortUrl
```

We open it, and we create the attributes :

```groovy
class ShortUrl {

	String segment
	String url

	static constraints = {
	}
}
```

See the  `constraints` field ?

We can add validation conditions for each field :

* The `segment` :
	* Must be unique
	* Should have from 5 up to 10 chars
	* must be ascii
* The url :
	* Must be a valid url
	* Must not be blank

```groovy
static constraints = {
			segment unique: true, size: 5..10, matches: "[0-9a-zA-Z]*"
	url url: true, blank: false
}
```

## Step 3 : Scaffold the ShortUrl entity

Now our domain is modeled, we can assume our app is simple engough to use a CRUD.

We have only one entity, and the only CRUD operation we want is CREATE.

Building a frontend form for the CREATE operation is a wheel, and Grails knows we don't want to re-invent it.

And so he can scaffold it for us.

Grails implements [Micronaut for Spring](https://micronaut-projects.github.io/micronaut-spring), so we are working on a MVC.

The scaffold starts from a Controller. Let's create it :

```sh
./grailsw generate-controller ShortUrl
```

Then replace all its content with the scaffold instruction :

```Groovy
class ShortUrlController {
	static scaffold = ShortUrl
}
```

Let's open the browser to see the hotreloaded content :

### Available controllers :

> ![](/assets/images/available_controller.png)

We can see here our newly created controller. Let's open it.

### Short-urls list page

> ![](/assets/images/shorturl_list.png)

When the browser called the controller endpoint with a GET request, there were this header :

`Accept: application/html`

The controller interprets it to respond with an html page listing all the stored `ShorUrls`.

Let's see what the "new ShortUrl" button does :

### Short-url create page

> ![](/assets/images/create_shorturl.png)

It opens a page with a form that allows to create new `ShortUrls`.

It's pretty close to what we want as a our home page !

When we create a `ShortUrl`, we are redirected to new object's `show` page :

![](/assets/images/shorturl-show-page.png)

### Let's try the link

If I append the fragment to the base-path, I got http://localhost:8080/k2m47.

But it redirects to the 404 page :

![](/assets/images/page-not-found-404.png)

## Step 4 : Configure the redirect

Basically, we want that http://localhost:8080/k2m47 redirects to the associated long url stored.

So I created the internal redirection from this url-pattern to a new action names `redirect` in the ShortUrlController :

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

Let's open the short-url again : http://localhost:8080/k2m47

Magic, the shortened url appears !

## Step 5 : Change the home page

Now the redirection works, we want to change the home page.

We can achieve this with `UrlMappings.groovy` (which already exists) :

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

When a user reach '/', he will be redirected to the 'create' action of the controller named 'ShortUrlController'.

> Which action you said ? There is no method in the ShortUrlController.

Yes, there are. The actions 'create', 'save', 'get', 'update' are injected at compile-time in the controller, thanks to the scaffolding ;)

## Step 6 : Forbid unwanted actions

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

We also use the `constraints` closure to :

* Allow only the `ShortUrlController`

* Allow only the actions show, index, save

If the constraints validation failed, the user is redirected (by convention) to the 404 page.

## Step 7 : Make the segment optional

Grails built the form based on the entity attributes type and constraints.

Let's make the segment nullable :

```groovy
static constraints = {
    		segment unique: true, size: 5..10, matches: "[0-9a-zA-Z]*", nullable: true
    url url: true, blank: false
}
```

![](/assets/images/segment_optional.png)

Much better !

But, we now have to randomly generate one if not set.

Let's init it (if not user-provided) in the beforeValidate of ShortUrl :

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

`beforeValidate` triggers everytime we try to add/update an entity to the database.

We can re-use the min size constraint as default size.

------

### Quick note about randomness

1. Here, the segment doesn't have to be secure. We just want 5 chars words.
2. `RandomStringUtils.randomAlphanumeric` uses `java.util.Random`, which is thread safe, but also **thread-blocking** ! It's a bottleneck for multi-threaded contexts. We just don't care for our hacky
   app. The right way would be :

   ```groovy
   RandomStringUtils.random(segmentMinSize, 0, 0, true, true, null, ThreadLocalRandom.current())
   ```

3. On a 5 alphanumeric word, collisions can occur. So we can add a little validation code :

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

Now, a random word is generated until it is unique (Grails will check in the database during the `validate()`.

## Step 8 : Change redirection on create submit

> ![](/assets/images/show_page.png)

When we create a shorturl, by submitting the form, the 'save' action is run, and we are conventionally redirected to the show page of the created ShortUrl Entity.

The show page has no value in our MVP, so we prefer to be redirected to a new create page, with the new segment into a conditional div.

Let's override the scaffolded `show` implementation :

```groovy
def show(Long id) {
	redirect action: 'create', params: [id: id]
}
```

We give the id of the created entity in parameter in order to be able to retrieve and display it on the create page.

## Step 8 : The conditional div on the create page

When we land on the create page, there are two use cases :

1. We just opened the page
2. We just submitted a new shortUrl on a previous create page

On the second case, we have a non-null `params.id`, so we fetch the associated entity from the database and we add it into the model, in order to make the entity available in the create view.

```groovy
def create(String id) {
    respond new ShortUrl(params), model: [created: ShortUrl.get(id)]
}
```

Now we override the create page by generating the 4 views (index, show, edit, create) :

```sh
./grailsw generate-views ShortUrl
```

At the end of the create.gsp body, we add the conditional div :

```html
[...]
</div>
<g:if test="${created}">

</g:if>
</body>
</html>
```

We can add some code from the show.gsp to it :

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

Then we generate the link and simply display it :

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

And we delete the un-overriden/un-used views :

```sh
rm grails-app/views/shortUrl/show.gsp
rm grails-app/views/shortUrl/index.gsp
rm grails-app/views/shortUrl/edit.gsp
```

Great ! Now we can see the created shorturl in the same page :
> ![](/assets/images/conditional_div.png)

## Step 9 : Add a better index page (paginated list of shorturls)

By default, the list of all shorturls created looks like this :

![](/assets/images/default_shorturl_list_view.png)

We don't care about the segment and its show page.

What we should show on this index page is a table of long url by short url.

A simple solution is to add a template to the scaffolded index page. In this template we tell the GSP system how to render the table.

Let's generate the `shorturl` scaffolded views again :

```shell
./grailsw generate-views ShortUrl
rm grails-app/views/shortUrl/index.gsp
```

Then, we add the template to use on the `<f:table>` element :

```html
[...]
		<f:table collection="${shortUrlList}" template="shortUrlList" />
[...]
```

And we create the template. It should be in `grails-app/views/templates/_fields/_shortUrlList.gsp`

The default content can be found in the `grails-fields-plugin`. So I looked in the github
repo : [https://github.com/grails-fields-plugin/grails-fields/blob/master/grails-app/views/templates/_fields/_table.gsp](https://github.com/grails-fields-plugin/grails-fields/blob/master/grails-app/views/templates/_fields/_table.gsp)

And I copied it into my template.

Then, I overwrite the column names and content :

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

Here is the result :

![](/assets/images/customized_shorturl_list_view.png)

## Step 10 - A final touch

Our tool still looks like a "get started" Grails site.

So let's change the logo (with a free one) and change the footer text.

We can do this on all pages just by editing the `layouts/main.gsp` (remember, we are in a templating framework).

The new Logo :

```html
<a class="navbar-brand" href="/#"><asset:image src="axe.svg" alt="Tawane's url shortener Logo"/></a>
```

With some resizing in `grails-app/assets/stylesheets/grails.css`

```css
a.navbar-brand img {
	height: 55px;
}
```

The new footer :

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

Now, take a moment to look back to all the code we wrote. It's not that much compared to the product we have, right ?

## Conclusion

We just developed a full feature from scratch, with very few lines of code, thanks to Grails,

We stayed focus on our MVP, but we have plenty of nice bonuses from Grails :

* **Pagination of the shorturls list !**
* Full specific form validation with errors display
* Errors redirection to 404/500 pages
* We wrote ZERO css and still have a decent front
* Css files already exist, and css classes are ready to be edited
* The test stack (unit / integration / functional) is ready
* Our app is responsive, thanks to mobile.css
* Our form is **SECURE** ! Grails escape every user prompt
* Assets (images/css/js) files are minified and name-hashed thanks to the asset-pipeline plugin
* Internationalization is ready : just set the labels in messages_ru.properties and russians can use it

If you felt the power of Grails here, just try it with this url-shortener or any simple app, I promise you will love this framework.

Full sources are available on [github.com/t4w4n3/shorturl](https://github.com/t4w4n3/shorturl/)

You can try it at [https://intense-lake-67642.herokuapp.com/](https://intense-lake-67642.herokuapp.com/)  
The server shutdowns if nobody used it for 30 minutes, so it will take about 20 seconds to start again if you open it.
