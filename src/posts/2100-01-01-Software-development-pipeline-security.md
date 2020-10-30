Title: Software development pipeline - Security
Tags:
  - Building software
  - Build server
  - Configuration-as-code
  - DevOps
  - Security
---

* Security is a big issue (one I don't know enough about, other than to be weary / scared)
  * Using a flexible build engine like MsBuild, rake, cake etc. is great if
    * Every developer is confident with the engine
    * You implicitly trust every developer (possible in a commercial setting, unlikely in OSS)
  * More likely want a build system that has a trust relation between the engine and the tasks
  * The artefact creation process should be tracable so that you know where the artefacts came from
    * Ideally you need to know exactly what went into the artefact without there being the possiblity
      for unknown additions. Note that this ability is hard to achieve due to the nature of
      build systems.
  * Note that often people say build system security isn't an issue because you trust all the developers
    given that you hired them. This is not entirely true given that:
    * most companies have permission restrictions for developers on what they can commit to
    * It's not just your own developers that you are protecting from, but also outside parties that
      attack the company. Defense in depth is important. For those that say this isn't a problem
      * Supply chain attacks are a thing
  * Not much is being said / done with regards to CI/CD security
