Title: Software development pipeline - Security
Tags:
  - Delivering software
  - Software development pipeline
  - Build configuration as code
  - DevOps
  - Security
---

One of the final chapters in the description of the development pipeline deals with security. In
this case I specifically mean the security of the pipeline and the underlying infrastructure,
not the security of the applications which are created using the pipeline.

The first question is why should you care about the security of the pipeline? After all
developers use the development pipelines via secured networks and their access permissions will be
set at the source control level. Additionally high trust levels exist between the pipeline
processes, the infrastructure and the source repository. In general this leads to the
security of the pipeline being placed lower on the priority list.

Which issues could you run into if you deem the security of the pipeline less critical? One
argument comes from
[pen tests](https://www.researchgate.net/publication/332834111_Vulnerabilities_in_Continuous_Delivery_Pipelines_A_Case_Study)
which show that CI/CD systems are a great way into
[corporate networks](https://www.blackhat.com/docs/eu-15/materials/eu-15-Mittal-Continuous-Intrusion-Why-CI-Tools-Are-An-Attackers-Best-Friend.pdf).
Additionally there have been a number of attacks aimed at
[distributing](https://medium.com/@hkparker/analysis-of-a-supply-chain-attack-2bd8fa8286ac) malicious
code through trusted software packages. These so called
[supply chain attacks](https://en.wikipedia.org/wiki/Supply_chain_attack) try to compromise the user
by inserting malicious code in third-party dependencies, i.e. the source code supply chain.

In essence the problem comes down to the fact that the build pipeline and its associated infrastructure
have access to many different systems and resources which are normally not easily accessible for
its users. This makes your pipeline a target for malicious actors who could abuse some of the
following states for their own purposes.

- The development pipeline runs all tasks with the same user account on the executors and thereby
  the same permissions. Obviously the worst case scenario would be running as an administrator.
- Multiple pipeline invocations executed on a single machine, either in parallel or sequential,
  which allows a task in a pipeline to access the workspace of another pipeline. This ability can
  for instance be used to by-pass access controls on source code.
- Downloading packages directly from external package repositories, e.g. NPM or Docker.
- Direct access to the internet, which allows downloading of malicious code and uploading of artefacts
  to undesired locations.
- The development pipeline has the ability to update or overwrite existing artefacts.
- The executors have direct access to different resources that normal pipeline users don't have
  access to. Specifically if the same infrastructure is used to build artefacts and
  to deploy them to the production environment.

One of the problems with securing the development pipeline is that all the actions mentioned above
are in one way or another required for the pipeline to function, after all the pipeline needs to be
able to build and distribute artefacts. The follow up question then becomes can you distinguish between
normal use and malicious use?

It turns out that distinguishing that this will be difficult because both forms of actions are
essentially the same, they both use the development pipeline for its intended purpose. So then in
order to prevent malicious use put up as many barriers to malicious use as possible, aka
[defence in depth](https://en.wikipedia.org/wiki/Defense_in_depth_(computing)). The following are a
number of possible ways to add barriers:

- Grant the minimal possible permissions for the executors, both on the executor and from the executor
  to the external resources. It is better to run the pipeline actions as a local user on the executor,
  rather than using a domain user. Grant permissions to a specific resource to the action that
  interacts with the resource.
- Execute a single pipeline per executor and never reuse the executor.
- Limit network connections to and from executors. In general executors do not need internet access,
  save for a few pre-approved sites, .e.g. an artefact storage. There is also very little reason
  for executors to connect to each other, especially if executors are short lived.
- Pull packages, e.g. NPM or Docker, only from an internal feed. Additions to the internal feed are made
  after the specific package has been reviewed.
- The artefacts created with the pipeline should be tracked so that you know the origin, creation time,
  storage locations and other data that can help identity an exact instance of an artefact. Under
  ideal circumstances you would know exactly which sources and packages were used to create
  the artefact as well.
- Artefacts should be immutable and never be allowed to overwritten.
- Do not use the executors that perform builds for deployments, use a set of executors that only
  have deployment permissions but no permissions to source control etc..

Beyond these changes there are many other ways to reduce the attack surface as documented in the
security literature. In the end the goal of this post is more to point out that the security of the
development pipeline is important, rather than providing ways to make a pipeline more secure. The
exact solutions for pipeline security depend very heavily on the way the pipeline is constructed and
what other forms of security validation have been placed around the pipeline.
