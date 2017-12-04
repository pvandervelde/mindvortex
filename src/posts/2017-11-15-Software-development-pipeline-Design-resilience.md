Title: Software development pipeline - Design resilience
Tags:
  - Delivering software
  - Software development pipeline
  - Pipeline design
  - DevOps
---

The [third property](Software-development-pipeline-Design-introduction.html) to consider is
*resilience*, which in this case means that the pipeline should be able to cope with
expected and unexpected changes to the environment it executes in and uses.

David Woods defines [four different types of 'resilience'](https://www.researchgate.net/publication/276139783_Four_concepts_for_resilience_and_the_implications_for_the_future_of_resilience_engineering) in a paper in the journal of reliability engineering and system safety. One of the different types
is the generally well known form of robustness, i.e. the ability to absorb pertubations or disturbances.
In order to be robust for given disturbances one has to know in advance where the disturbances will
come from, e.g. in the case of a development pipeline it might be expected that pipeline stages will
fail and will polute or damage parts or all of the executor it was running on. Robustness in this
case would be defined as the ability of the pipeline to handle this damage, for instance by repairing
or replacing the executor.

The other definitions for resilience are:

- Rebound, the ability to recover from trauma: In order to achieve this capacity ahead of time is
  required, i.e. in order to recover from a disturbance one needs to be able to deploy capabilities
  and capacity that was available in excess before the issues occurred.
- Graceful extensibility, the ability to extend adaptive capacity in the face of surprise. This is
  the ability to stretch resources and capabilities in the face of surprises.
- Sustained adaptibility, which is the ability to adapt and grow new capabilities in the face of
  unexpected issues. In general this definition applies more to systems / layered networks where
  the loss of sub-systems can be compensated.

Which ever definition of resilience is used in general the goal is to be able to recover from
unexpected changes and return back to the normal state, ideally with minimal intervention. It should
be noted that returning back to normal after major trauma can be deceiving because the 'normal' as
experienced before the trauma will be different from the 'normal' experienced after the trauma due
to the lessons learned from the trauma and permanent changed caused by the trauma.



Additionally it is not just the unexpected changes that are interesting but also the expected ones,
e.g. upgrades, maintenance etc. because in general we would like the pipeline to continue functioning
while those changes are happening.




In general the pipeline has to be able to:

- Deal with changes in the environment in a sensible way. Changes may range from small changes
  (e.g. additional tools being deployed) to big changes (migration of many of the services), and from
  expected (maintenance or planned upgrades) to unexpected (outages)
- Deal with changes in the source code and report the correct errors
- The environment may experience changes, e.g. minor outages, failing services etc. In this
  case the pipeline should be able to deal with these issues and provide a sensible report
  back to the team. If the pipeline just crashes it will be harder to figure out what went wrong
  thus slowing the team down.
- Users will make mistakes in configuration. The pipeline should be able to report something sensible
  in this case
- Expected outages should not lead to failures. In this case expected outages mean outages of services
  for which we are expecting that they may go offline
- Failure in a step should only fail the stage if there is no way to complete the stage correctly,
  e.g. in case of failure to get data, maybe the answer is to retry
- A robust pipeline is more likely to only error if there is an actual issue with the inputs







How do we achieve robustness

- Simple things:
    - Execute the pipeline in your own workspace and only in your own workspace. The workspace is
      'private' to the current pipeline step, no other processes should be working in the local
      workspace. This removes some issues with unexpected changes to the file system. There are
      still cases where 'unexpected' changes to the file system can occur, for instance when
      running parallel executions within the same pipeline stage in the same workspace. This type of
      behaviour should therefore be avoided as much as possible
    - Ensure that the workspace is clean before starting, for a known definition of clean. This way
      the pipeline step starts from a known state
    - Do not depend on global (machine, container, network) state. Global state might change unexpectedly
    - Mirror external sources and carefully control what is in the mirrors
      ([leftpad](https://www.theregister.co.uk/2016/03/23/npm_left_pad_chaos/) anyone?)
    - Ideally don't rely on caching. Pull data fresh from the local data store (packages etc.)
      each time. This prevents cache polution from being a problem
- More complicated things
    - Extensive error handling, both for known cases (e.g. service offline) and general error handling
      for unexpected cases
    - Infrastructure: highly available services and graceful degradation
    - Scripts: Error handling, retries, proper error messages
    - Constant testing. Even testing in production, taking services down etc. (chaos monkey)
    - Logs, metrics and monitoring. Get all the data and alert on it. Ensure that we do predictive alerting
      (but don't over-alert) so that we get alerted before everything is on fire.
    - Automatic remediation if possible
    - Fall-backs for everything


Notes

- Robustness and performance are generally not friends. A robust process can well be slower than a
  non-robust one because it's easy to be fast if stuff doesn't have to work.
