---
Title: Software development pipeline - In the build system or not
Tags:
  - Delivering software
  - Software development pipeline
  - Pipeline design
  - DevOps
---

Over the last few years the use of build pipelines has been gaining traction backed by the ever growing
use of Continuous Integration (CI) and Continuous Delivery and Deployment (CD) processes. By using a
build pipeline the development team get benefits like being able to execute parts of the build, test,
release and deployment processes in parallel, being able to restart the process part way through
in case of environmental issues, and vastly improved feedback cycles which improve the velocity
at which features can be delivered to the customer.

Most modern build systems have the ability to create a build pipelines in one form or another, e.g.
[VSTS / Azure Devops builds](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines?toc=/azure/devops/pipelines/toc.json&bc=/azure/devops/boards/pipelines/breadcrumb/toc.json&view=vsts),
[Jenkins pipeline](https://jenkins.io/solutions/pipeline/),
[GitLab](https://docs.gitlab.com/ee/ci/pipelines.html), [BitBucket](https://bitbucket.org/product/features/pipelines)
and [TeamCity](https://confluence.jetbrains.com/display/TCD18/Build+Chain). With these capabilities
built into the build system it is easy for developers to quickly create a new pipeline from scratch.
While this is quick and easy often the pipeline for a product is created by the development team
without considering if this is the best way to achieve their goal, which is to deliver their product
faster with higher quality. Before using the built-in pipeline capability in the build system the second
question a development team should ask is when should one use this ability and when should one not
use this ability? Obviously the first question is, do we need a pipeline at all, which is a question
for another post.

The advantages of creating a pipeline in your build system are:

- It is easy to quickly create pipelines. Either the is a click and point UI of some form or the
  pipeline is defined by a, relatively, simple configuration file. This means that a development
  team can configure a new build pipeline quickly when one is desired.
- Pipelines created in a build system can often use multiple build executors or have a job move
  from one executor to another if different capabilities are required for a new step, for instance
  if different steps in the pipeline need different operating systems to be executed.
- In many cases, but not all, the build system provides a way for humans to interact with a running
  pipeline, for instance to approve the continuation of the pipeline in case of deployments or
  to mark a manual test phase as passed or failed.
- If the configuration of the pipeline is stored in a file it can generally be stored in a source
  control system, thus providing all the benefits of using a source control system. In these cases
  the build system can generally update the build configurations in response to a commit / push
  notification from the version control system. Thus ensuring that the active build configuration
  is always up to date.
- The development team has nearly complete control over the build configuration which ensures that
  it is easy for the development teams to have a pipeline that suits their needs.

Based on the advantages of having a pipeline in the build system it seems pretty straight forward to
say that having the pipeline in the build system is a good thing. However as with all things there
are also drawbacks to having the pipeline in the build system.

- Having the pipeline in the build system makes some assumptions that may not be correct in certain
  cases.
    - The first assumption is that the build system is the center of all the work being done
      because the pipeline is controlled by the build system, thus requiring that all actions feed back
      into said build system. This however shouldn't be a given, after all why would the build system
      be the core system and not the source control system or the issue tracker. In reality all systems
      are required to deliver high quality software. This means in most cases that none of these systems
      have enough knowledge by themselves to make decisions about the complete state of the pipeline.
      By making the assumption that the build system is at the core of the pipeline the result will
      be that the knowledge of the pipeline work flow will end up being encoded in the build configurations
      and the build scripts. For simple pipelines this is a sensible thing to do but as the pipeline
      gets more complex this approach will be sub-optimal at best and more likely detrimental due to
      the complexity of providing all users with the overview of how the pipeline functions.
    - The second, but potentially more important, assumption is that the item the development teams
      care most about is 'build' or 'build job'. This however is not the case most of the time because
      a 'build' is just a way to create or alter an artefact, i.e. the package, container, installer
      etc.. It is artefacts that people care about most because artefacts are the carrying vehicle
      for the features and bug fixes that the customer cares about. From this perspective it makes
      sense to track the artefacts instead of builds because the artefact flows through the entire pipeline
      while builds are only part of the pipeline.
    - A third assumption is that every task can somehow be run through the build system, but this is
      not always the case and even when it is possible it is not necessarily sensible. For instance
      builds and deploys are fundamentally different things, one should be repeatable (builds) and
      can just be stopped on failure and restarted if necesary and the other is often not exactly
      repeatable (because artefacts can only be moved from a location once etc.) and should often
      not just be stopped (but rolled-back or not 'committed'). Another example is long running tests
      for which the results may be fed back into the build system if required but that doesn't
      necessarily make sense.

- If the build system is the the center of the pipeline then that means that the build system has to
  start storing persistent data about the state of the pipeline with all the issues that come with this
  kind of data, for instance:
    - The data stored in the pipeline is valuable to the development team both at the current time and
      in the future when the development team needs to determine where an artefact comes from. This means
      that the data potentially needs to be kept safe for much longer than build information is
      normally kept. In order to achieve this the standard data protection rules apply for instance
      access controls and backups.
    - The information about the pipeline needs to be easily accessible and changable both by the build
      system and by systems external to the build system. It should be possible to add additional
      information, e.g. the versions / names of artefacts created by a build. The status of the artefact
      as it progresses through the pipeline etc.. All this information is important either during the
      pipeline process or after the artefacts have been delivered to the customer. Often build
      systems don't have this capability, they store just enough information that they can do what
      they need to do, and in general they are not database systems (and if they are it is recommended
      that you don't tinker with them and in general it is made difficult to append or add information).
    - Build systems work much better if they are immutable, i.e. created from standard components (e.g.
      controller and agents) with automatically generated build jobs (more about the reasons both of
      these will follow in future posts). This allows a build system to be expanded or replaced really
      easily ([cattle not pets](https://medium.com/@Joachim8675309/devops-concepts-pets-vs-cattle-2380b5aab313)
      even for build systems). That is much harder if the build system is the core of your pipeline
      and stores all the data for it.

- Having the pipeline in the build system in general provides more control for the development teams,
  which is a great benefit, but less control for the administrators. Because the pipeline provides the
  development teams with all the abilities there is, in general, less ability for the admins to guide
  things in the right direction or to block developers from doing things that they shouldn't be doing
  or have access to. While this may seem to be a benefit for the developers, no more annoying admins
  getting in the way, it is in fact a drawback because this behaviour means that the developers take
  on the responsibility to administer some or all of the underlying build system. Examples of the
  change of control are for instance in the Jenkins pipeline it is possible for developers to use
  all the credentials that jenkins has access to. However this might not be desirable for high power
  credentials or credentials for highly restricted resources. An other example is that the selection
  of the build executor is done in the pipeline configuration, however in some cases it may make sense
  to limit access to executors, after all having a build that can migrate from node to node makes
  sense in some cases but it's not free. Further the ease with which parallel steps can be created will
  lead to many parallel jobs. This might be great for one pipeline but isn't necessarily the best for
  the overall system. In some cases serializing the steps for a single pipeline can lead to greater
  overall throughput if there are many different jobs for many different teams.

Based on all the advantages and disadvantages that are listed here it may be difficult to decide whether
or not a development team should use the pipeline in their build system or not. In general it will be
sensible to use the pipeline capabilities that are build into your build system in cases where you either
have a fairly simple pipeline that is easy to reason about or where no external systems need to interact
with the data in the pipeline.

Once the pipeline gets more complicated, external systems need access to the metadata describing the
pipeline or the pipeline gets stages that are incompatible with being executed by a build system it
will be time to migrate to a different approach to the build and deployment pipeline. In this case
it is worth it to develop some custom software that tracks artefacts through the pipeline. This makes
it possible to treat the pipeline system as the critical infrastructure that it is, with the appropriate
separation of data and business rule processing, data security and controlled access to the data for
external systems.
