Title: Software development pipeline - Security
Tags:
  - Delivering software
  - Software development pipeline
  - Build configuration as code
  - DevOps
  - Security
---

One of the final chapters in the description of the development pipeline is the one that deals with
security.

Why important

- Pen testing shows that [CI/CD systems](https://www.blackhat.com/docs/eu-15/materials/eu-15-Mittal-Continuous-Intrusion-Why-CI-Tools-Are-An-Attackers-Best-Friend.pdf) are a great way into corporate networks. See also https://www.researchgate.net/publication/332834111_Vulnerabilities_in_Continuous_Delivery_Pipelines_A_Case_Study
- Supply chain attacks are on the rise


Disclaimer: I don't know enough about security in general and development pipeline security specifically
to make definitive statements. The following is a description of my thoughts and ideas not guidance
on how to secure your pipeline.



As per normal security is a complex issue and security for development pipelines isn't discussed
very much.

- Pipelines are mostly used internally by a small(ish) group of people. In general security of the
  pipeline just isn't very high on the list compared to delivering new versions of the product etc.
- It is a difficult topic because the trust between the development pipeline processes, the infrastructure
  and the source code needs to be very high
  - Developers are often assumed to be trusted so no need for security


- Note that often people say build system security isn't an issue because you trust all the developers
  given that you hired them. This is not entirely true given that:
  - most companies have permission restrictions for developers on what they can commit to
  - It's not just your own developers that you are protecting from, but also outside parties that
    attack the company. Defense in depth is important. For those that say this isn't a problem
    - Supply chain attacks are a thing
- Not much is being said / done with regards to CI/CD security


- Using a flexible build engine like MsBuild, rake, cake etc. is great if
  - Every developer is confident with the engine
  - You implicitly trust every developer (possible in a commercial setting, unlikely in OSS)

- More likely want a build system that has a trust relation between the engine and the tasks
  - Ideally tasks are executed in different security contexts, e.g. a high risk task like source
    code compilation are executed in a tightly controlled context by a low permission user, i.e.
    one that doesn't have access to anything other than the resources it needs to perform the task

- The artefact creation process should be tracable so that you know where the artefacts came from
  - Ideally you need to know exactly what went into the artefact without there being the possiblity
    for unknown additions. Note that this ability is hard to achieve due to the nature of
    build systems.
