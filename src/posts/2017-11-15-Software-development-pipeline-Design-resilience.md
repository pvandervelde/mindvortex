Title: Software development pipeline - Design resilience
Tags:
  - Delivering software
  - Software development pipeline
  - Pipeline design
  - DevOps
---

This [paper](https://www.researchgate.net/publication/276139783_Four_concepts_for_resilience_and_the_implications_for_the_future_of_resilience_engineering)
defines four different types of 'resilience', one of which is robustness, i.e. the ability to absorb
pertubations. Note that this requires that we know where the pertubations are coming from, and
robustness in one direction may affect the ability to be robust in another direction

Others are:

- rebound, the ability to recover from trauma: In order to achieve this one needs
  capacity ahead of time, i.e. in order to recover from a surprise you need to be able to deploy
  capabilities that you had in excess before failure occurred
- Graceful extensibility, i.e. the opposite of brittleness, or how to extend adaptive capacity in
  the face of surprise. This is the ability to stretch in the face of surprises
- Sustained adaptibility. Generally applied to systems / layered networks. The ability to adapt
  and grow new capabilities in the face of changes / chaos / unexpected issues

The general goal for resilience / robustness is to recover from unexpected changes and return back
to normal. However it seems that recovery back to normal from major trauma is a bit of a misnomer because
the 'normal' before the trauma will be different from the 'normal' after the trauma due to the
lessons learned from the trauma. Additionally it is not just the unexpected changes that are interesting
but also the expected ones (upgrades, maintenance etc.) because in general we would like the pipeline
to continue functioning while those changes are happening.

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
      workspace. This removes issues with unexpected changes to the file system
    - Ensure that the workspace is clean before starting, for a known definition of clean. This way
      the pipeline step starts from a known state
    - Do not depend on global (machine, container, network) state. Global state might change unexpectedly
    - Mirror external sources and carefully control what is in the mirrors
      ([leftpad](https://www.theregister.co.uk/2016/03/23/npm_left_pad_chaos/) anyone?)
    - Ideally don't rely on caching. Pull data fresh from the local data store (packages etc.)
      each time. This prevents cache polution from being a problem
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
