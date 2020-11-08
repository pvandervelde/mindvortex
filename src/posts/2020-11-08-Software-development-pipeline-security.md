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

Before we move on to discussing pipeline security I want to make clear that I don't know enough
about security in general and security of the development pipeline specifically to make definitive
statements. So the following is a description of my thoughts and ideas not guidance on how to secure
your pipeline.

The first question to answer is why should I care about the security of the pipeline? After all
development pipelines are, mostly, used internally by developers. Generally the developers are trusted
with the source code and access permissions are set at the source control level.
In addition normally high trust levels exist between the pipeline processes, the infrastructure and
the source repository. Based on this most companies deem the security of the pipeline lower
on the priority list.

So if many companies deem the security of the pipeline less critical are there any issues
that could convince them to increase the priority of the issue? One argument comes from
[Pen tests](https://www.researchgate.net/publication/332834111_Vulnerabilities_in_Continuous_Delivery_Pipelines_A_Case_Study)
which show that CI/CD systems are a great way into
[corporate networks](https://www.blackhat.com/docs/eu-15/materials/eu-15-Mittal-Continuous-Intrusion-Why-CI-Tools-Are-An-Attackers-Best-Friend.pdf).
Another argument is that There have been a number of attacks aimed at
[distributing](https://medium.com/@hkparker/analysis-of-a-supply-chain-attack-2bd8fa8286ac) malicious
code through trusted software packages. These so called
[supply chain attacks](https://en.wikipedia.org/wiki/Supply_chain_attack) try to compromise the user
by inserting malicious code in third-party dependencies, i.e. the source code supply chain.

In essence the problem is that the build pipeline and its associated infrastructure have access to
many different systems and resources which are normally not easily accessible for their users. This
makes the pipeline a good target for malicious actors.

With the development pipeline being a high value target what are the actions that could compromise
our systems.

- The development pipeline runs all tasks with the same user account on the executors and thereby
  the same permissions. Obviously the worst case scenario would be running as an administrator
- Multiple pipeline invocations are executed on a single machine, either in parallel or sequential,
  which allows a task in a pipeline to access the workspace of another pipeline. This ability can
  for instance be used to by-pass access controls on source code
- Downloading packages directly from external package repositories, e.g. NPM or Docker. Without a
  security review it is possible that one of these packages contains a malicious code
- Direct access to the internet, which allows downloading of malicious code and uploading of artefacts
  to undesired locations
- The development pipeline has the ability to update or overwrite existing artefacts
- The executors have direct access to different resources that normal pipeline users don't have
  access to. This is specifically the case if the same infrastructure is used to build artefacts and
  to deploy them to the production environment

One of the problems with securing the development pipeline is that all the actions mentioned above
are in one way or another required for the pipeline to function, after all the pipeline needs to be
able to build and distribute artefacts. The follow up question then becomes can you distinguish between
normal use and malicious use?

The answer to that is that it will be difficult because both forms of actions are essentially the
same, they both use the development pipeline for its intended purpose. So then in order to prevent
malicious use the best option is to put up as many barriers to malicious use as possible, aka
[defence in depth](https://en.wikipedia.org/wiki/Defense_in_depth_(computing)). What follows is a
suggestion of possible ways to reduce the attack surface of the pipeline

- Grant the minimal possible permissions for the executors, both on the executor and from the executor
  to the external resources. It is better to run the pipeline actions as a local user on the executor,
  rather than using a domain user. If permissions to a specific resource is required then those
  should be granted to the action that requires them.
- Execute a single pipeline per executor and ideally never reuse the executor.
- Limit network connections to and from executors. In general executors do not need internet access,
  save for a few pre-approved sites, .e.g. an artefact storage. There is also very little reason
  for executors to connect to each other, especially if executors are short lived.
- Pull packages, e.g. NPM or Docker, only from an internal feed. Additions to internal feed are made
  after the specific package has been reviewed. Note that this requires that.
- The artefacts created with the pipeline should be tracked so that you know the origin, creation time,
  storage locations and other data that can help identity an exact instance of an artefact. Under
  ideal circumstances you would know exactly which sources and packages were used to create
  the artefact as well.
- Artefacts should be immutable and never be allowed to overwritten.
- Do not use the executors that perform builds for deployments, use a set of executors that only
  have deployment permissions but no permissions to source control etc..

Beyond these changes there are many other ways to reduce the attack surface. In the end the goal of
this post is more to point out that the security of the development pipeline is important, rather
than providing ways to make a pipeline more secure. The exact solutions for pipeline security depend
very heavily on the way the pipeline is constructed and what other forms of security validation have
been placed around the pipeline.
