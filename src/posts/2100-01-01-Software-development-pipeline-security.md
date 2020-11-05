Title: Software development pipeline - Security
Tags:
  - Delivering software
  - Software development pipeline
  - Build configuration as code
  - DevOps
  - Security
---

One of the final chapters in the description of the development pipeline is the one that deals with
security. In this case I specifically mean the security of the pipeline and the underlying infrastructure,
not the security of the applications that are created using the pipeline.

Now before we move on to discussing pipeline security I want to make clear that I don't know enough
about security in general and security of the development pipeline specifically to make definitive
statements. The following is a description of my thoughts and ideas not guidance on how to secure
your pipeline. With that out of the way, lets move on.

Why should we care about the security of the pipeline? After all development pipelines are, mostly,
used internally by developers. Generally the developers are trusted
with the source code and access permissions are set at the source control level.
In addition normally high trust levels exist between the pipeline processes, the infrastructure and
the source repository. With all these facts most companies deem the security of the pipeline lower
on the priority list.

So if many companies deem the security of the pipeline less critical are there any issues
that could convince them to increase the importance of the issue?

- [Pen testing](https://www.researchgate.net/publication/332834111_Vulnerabilities_in_Continuous_Delivery_Pipelines_A_Case_Study)
  shows that CI/CD systems are a great way into
[corporate networks](https://www.blackhat.com/docs/eu-15/materials/eu-15-Mittal-Continuous-Intrusion-Why-CI-Tools-Are-An-Attackers-Best-Friend.pdf)
- There have been a number of attacks aimed at
  [distributing](https://medium.com/@hkparker/analysis-of-a-supply-chain-attack-2bd8fa8286ac)
  malicious code through trusted software packages. These so called
  [supply chain attacks](https://en.wikipedia.org/wiki/Supply_chain_attack) try to
  compromise the user by inserting malicious code in third-party dependencies, i.e. the source
  code supply chain




- Using a flexible build engine like MsBuild, rake, cake etc. is great if
  - Every developer is confident with the engine
  - You implicitly trust every developer (possible in a commercial setting, unlikely in OSS)

- More likely want a build system that has a trust relation between the engine and the tasks
  - Ideally tasks are executed in different security contexts, e.g. a high risk task like source
    code compilation are executed in a tightly controlled context by a low permission user, i.e.
    one that doesn't have access to anything other than the resources it needs to perform the task

- The artefact creation process should be traceable so that you know where the artefacts came from
  - Ideally you need to know exactly what went into the artefact without there being the possibility
    for unknown additions. Note that this ability is hard to achieve due to the nature of
    build systems.

In the end the goal of this post is more to point out that the security of the development
pipeline is important, rather than providing ways to make a pipeline more secure. The exact
solutions for pipeline security depend very heavily on the way the pipeline is constructed
and what other forms of security validation have been placed around the pipeline
