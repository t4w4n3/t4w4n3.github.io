Some thoughts about Gradle builds, mono-repos, and reducing the buid time :

In a Java/Kotlin Gradle build, when essential complication and/or complexity rise, we separate concerns into modules.

There is multiples ways to do this.

I tried several (maybe all ?) across my short career (8-10 years).

1. By artifact repository
  1.1 With source code in the same Git Repository (mono-repo)
  1.2 With source code in multiples  Git Repositories as submodules (multi-repo)
* By source code
  * With source code in the same Git Repository (mono-repo)
  * With source code in multiples Git Repositories as submodules (multi-repo)

With the artifact repository way, you can either :

* Build the dependency at the beginning of the main build then get it from the local repository with its snapshot version (Ordering can be automated natively with either Gradle and Maven)
* Treat dependencies as any other external and publish it to a shared artifact repository, then get it the normal way, with a specific release version.

With the source code way, you can either :

1. (Best imo) Modularize the dependencies in a multi-module project, then include the module as a project dependency with OR without its transitives dependencies (Gradle implementation/api)
2. Modularize each dependency in a composite build project, then include this build into the main build. Problem : Multiple uses of one dependency in the dependency tree will result to building it multiple times. The result is an extensive build time which will get you crazy or OOM your build.
3. BUT you should not put libraries in a separate multi-module-project, then import the full project build (jungle) in order to include a single library (banana).

I'm actually working on a big mono-repo with the third solution. And it is driving crazy 50 developers, and costing big $$$ on the CI.
So I transformed it into a clean unique multi-module project with a clean way to include libraries with `implementation(project(:shared:tech:monitoring))`

I hope they will see the benefits and accept to bigbadaboom my branch ^^

These thought will be in the tech talk about modularity I'm writing.
Please challenge it :D !
