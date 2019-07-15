Title: Calvinverse - Small setup
Tags:
  - Delivering software
  - Software development pipeline
  - DevOps
  - Immutable infrastructure
---

If you want to use the resources in [Calvinverse](https://www.calvinverse.net/) to build a small
build pipeline you will only need a few
[supporting resources](https://www.calvinverse.net/resources/category-support) and the
[build resources](https://www.calvinverse.net/resources/category-pipeline).


- Only need a jenkins master + one or two slaves, probably ideally a VM (easier to manage) and maybe
    a file share for NuGet packages
    - 1 Consul master -> so that the agents can find the master + configurations
    - 1 Vault instance -> for secret management
    - 1 Jenkins master
    - 1 Jenkins agent
    - 1 file share -> nuget and artefact storage
    - 1 proxy instance -> for easy access to jenkins
- Don't have
    - Log storage for system logs and / or build logs
    - Metrics for system and services
    - Redundancy
    - A way to test changes

- Configuration


- Doesn't have
    - Way to test changes. Everything will be done in live environment

## Hardware

- Can run on a quad core with 32Gb of RAM
- No redundancy, but at this level you probably don't need it
  - Should probably plan for some kind of disaster, i.e. make backups and make sure you can
    restore them

## How to extend

How to extend depends on what your needs are:

Where do you want to start?
- Most likely with more agents because that's biggest bang for buck
- After a number of agents the metrics come in handy because they allow you to figure out how
  much load you have on your system. Additionally you get the ability to track issues with the
  infrastructure (e.g. disk usage, cpu usage, memory usage) and the resources (e.g. Jenkins
  memory use etc.)
- At some point adding the logging and parsing capabilities that come with Elasticsearch become
  useful. Mostly once you start adding your own services or when you want to parse out build logs
- Can also add your own services, for instance:
  - To gather statistics from Jenkins via the
    [statistics plugin](https://github.com/jenkinsci/statistics-gatherer-plugin)
  - Way to process notifications / messages originating from one point of the infrastructure
    to another. By creating a central hub you can simplify the message flow, messages are always
    send to the central hub and delivered that way
  - Other services that process specific message types (e.g. updates to pull requests, notifications
    of new artefacts that are created), or that respond to new artefacts being created (e.g.
    to start tests etc.)
  - Add a service to provide oversight of the development pipeline. Instead of using the
    [build system](posts/Sofware-development-pipeline-In-the-build-system-or-not) this service can
    use information from multiple sources, e.g. build information, information about the available
    artefacts, test result information etc.
- Ideally you would add the ability to create build definitions from source code. For that you can
  use the [Jenkins pipeline](https://jenkins.io/solutions/pipeline/) or some
  [custom]() [code](). Note that if you use the Jenkins pipeline
  you still need to figure out how to add new repositories to Jenkins because the Jenkins pipeline
  does not have a way of discovering new repositories. Additionally there are some issues with
  deleting builds.
- If you want to store your own artefacts then you can add the
  [artefact storage]() resource
