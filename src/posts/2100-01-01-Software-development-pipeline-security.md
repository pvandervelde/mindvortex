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

In essence the build pipeline and its associated infrastructure have access to many different
systems and resources, making it a high value target for malicious actors.

With the development pipeline being a high value target what are the actions that could compromise
our systems.

- The development pipeline runs all tasks with the same user account on the executors and thereby
  the same permissions. Obviously the worst case scenario would be running as an administrator.
- Multiple pipeline invocations are executed on a single machine, either in parallel or sequential,
  which allows a task in a pipeline to access the workspace of another pipeline. This ability can
  for instance be used to by-pass access controls on source code.
- Downloading packages directly from external package repositories, e.g. NPM or Docker. Without a
  security review it is possible that one of these packages contains a malicious code.
- Direct access to the internet, which allows downloading of malicious code and uploading of artefacts
  to undesired locations.
- The executors have direct access to different resources that normal pipeline users don't have
  access to. This is specifically the case if the same infrastructure is used to build artefacts and
  to deploy them to the production environment.




- Ability to update / overwrite existing artefacts
  - Threat - Ability to insert malicious code into tested artefacts


- CI/CD systems are tasked to do deployments
  - Threat - CI/CD system has access to the production infrastructure





- Problem is that all those actions are things we normally want to do in a development pipeline
  otherwise we can't deliver our products
- So how are we going to distinguish between normal use and malicious use
  - Depends on the behaviour we're trying to prevent



- Single build per executor and ideally never reuse the executor. Docker containers are better
  than VMs in this case

- Minimal permissions for the executors itself, both on the executor and from the executor to
  the external resources
  - Run as a local user on each executor. This local user shouldn't have access to any external
    resources. The individual tasks should obtain permissions themselves
    - How to trust specific tasks is a hard problem

- More likely want a build system that has a trust relation between the engine and the tasks
  - Ideally tasks are executed in different security contexts, e.g. a high risk task like source
    code compilation are executed in a tightly controlled context by a low permission user, i.e.
    one that doesn't have access to anything other than the resources it needs to perform the task

- The artefact creation process should be traceable so that you know where the artefacts came from
  - Ideally you need to know exactly what went into the artefact without there being the possibility
    for unknown additions. Note that this ability is hard to achieve due to the nature of
    build systems.
  - Artefacts should be immutable and unable to be overwritten

- Ideally don't use a CI/CD system for deployments, use something that has proper permissions
  and which isn't directly linked to source control etc.

- Pull packages only from an internal feed. Add to internal feed after security review


In the end the goal of this post is more to point out that the security of the development
pipeline is important, rather than providing ways to make a pipeline more secure. The exact
solutions for pipeline security depend very heavily on the way the pipeline is constructed
and what other forms of security validation have been placed around the pipeline


Note:
Does testing in prod make this problem worse? If we test in prod that means that we for the minimum
shadow production, thus allowing untested / un-reviewed code to access production resources.