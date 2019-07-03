Title: Software development pipeline - On-prem or in the cloud?
Tags:
  - Delivering software
  - Software development pipeline
  - On-prem
  - Cloud
  - DevOps
---

[Continuous integration (CI) systems](https://en.wikipedia.org/wiki/Continuous_integration) originally and 
build pipelines recently have traditionally been available on-prem only with systems like [Jenkins](https://jenkins.io),
[TeamCity](https://www.jetbrains.com/teamcity/), [Bamboo](https://www.atlassian.com/software/bamboo) and
[TFS](https://en.wikipedia.org/wiki/Team_Foundation_Server). This is possibly due to the fact that these
systems needs relatively powerful hardware, mostly consisting of powerful CPU and fast IO, something
which was not easily available in the cloud until the last few years.

However in the last few years a number of cloud based CI systems have appeared e.g. 
[Azure DevOps](https://azure.microsoft.com/en-in/services/devops/), [AppVeyor](https://www.appveyor.com/),
[CircleCi](https://circleci.com/)), [CloudShip](https://codeship.com/),
[Google cloud build](https://cloud.google.com/cloud-build/) and [Travis CI](https://travis-ci.org/). This
has lead to the question of where to locate a CI system? Should it be on-prem or in the cloud or potentially
even a combination of the two. This post should provide some suggestions on how to make the selection
between the different options.

### Cloud-based CI systems

As with other cloud systems when using a cloud based CI system the user gets the benefits of not
having to worry about the underlying infrastructure and resources and having the ability to scale
the CI system to the size required, provided one pays for the additional resources.

The other side of the coin is that because the user has no influence on the infrastructure of the
CI system there is also no direct control over the hardware or the controller software. Thus the user
cannot increase the hardware specs for the controller or the agents and the user cannot determine
which plugins or capabilities are available in the CI system.
As a side effect this also means that the user does not have access to the logs, metrics and
file system for the underlying system, which provide information that may be useful when issues
arise. In general the controller specific logs and metrics are only useful if you have access to
the controller, however the build specific information is useful either for diagnostics
or future planning.

Besides the CI part of the system in some cases the entire pipeline will require other resources, e.g
artefact storage or test systems. Some cloud systems provide these additional systems as well, for a price
of course. Other systems require that these additional resources are provided in some other way.

### On-prem CI systems

When running the CI system on-prem one has to both provide and maintain the infrastructure, hardware and networking etc.,
and the controller and executor software. This increases the overhead for running a CI system. Additionally
scaling the system either requires manual intervention or building the scaling capabilities.

On the other hand having control over the infrastructure means that the CI system can be configured
so that it fits the use case for the development teams, the desired plugins installed, executors with
all the right tools, full control over executor workspaces and with that the ability to lock down
sensitive information. Additionally logs and metrics can be collected from everywhere which
helps diagnostics, alerting and predictive capabilities on both the infrastructure side and the build
capacity side.

Finally having full control over the CI system means that it is possible to extend the system if
that is required with custom capabilities, either directly added to the CI system or as additional 
services. It should of course be noted that this requires resources and is thus not free.

### Selecting a location for your CI system

So how does one select a location for a CI system. Both cloud and on-prem have pros and cons and in the
end the location of the system depends very much on the situation fo the development team. If the team works
for a company where there is no on-prem server infrastructure then a cloud based system will be the
only sensible approach. However there will also be cases where an on-prem system is the only sensible
option.

In order to decide for one system or the other the first thing that should be done is a cost
comparison, comparing the total cost of ownership, i.e. initial purchasing costs, running costs,
staff costs, training costs etc.. As part of the cost comparison the costs for additional parts
of the system should also be included, e.g. artefact storage or test systems. One should also note
that while cloud systems reduce maintenance, they are not maintenance free. The maintenance of the
infrastructure disappears but the maintenance of the builds and the workflow does not, after all no
matter where the build pipeline is located it is still important that it delivers the
[accuracy](/posts/Software-development-pipeline-Design-accuracy),
[performance](/posts/Software-development-pipeline-Design-performance.html),
[resilience](/posts/Software-development-pipeline-Design-resilience.html) and
[flexibility](/posts/Software-development-pipeline-Design-flexibility.html).

Once the cost comparison is done there are other things to bring into the decision process. Because
while costs are important they are not the only reason to select one system or another. For instance
other comparison elements could be related to regulations that specify how source needs to be treated
or specific processes that should be followed, or the capabilities of the different CI systems for
example is the ability to execute builds on a specific OS. Not all cloud CI systems provide
executors for all the different OSes.

In the end the decision to select a cloud build system or a on-prem build system depends
very strongly on the situation the company is in. It is even possible that as time progresses
the best type of system may change from on-prem to cloud or visa versa. Both systems have their
own advantages and disadvantages. In the end all that matters is that a system that fits the
development process is selected, independent of what the different vendors say is the best thing.
