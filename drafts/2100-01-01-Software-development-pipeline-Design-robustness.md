Title: Software development pipeline - Design robustness
Tags:
  - Delivering software
  - Software development pipeline
  - Pipeline design
  - DevOps
---

- Has to be able to deal with changes in the environment in a sensible way
- Has to be able to deal with changes in the source code and report the correct
  errors
- Why is robustness important
    - The environment may experience changes, e.g. minor outages, failing services etc. In this
      case the pipeline should be able to deal with these issues and provide a sensible report
      back to the team. If the pipeline just crashes it will be harder to figure out what went wrong
      thus slowing the team down
- How do we achieve robustness
  - Extensive error handling, both for known cases (e.g. service offline) and general error handling
    for unexpected cases
  - Infrastructure: highly available services and graceful degradation
  - Scripts: Error handling, retries, proper error messages
  - Constant testing. Even testing in production, taking services down etc. (chaos monkey)
  - Logs, metrics and monitoring. Get all the data and alert on it. Ensure that we do predictive alerting
    (but don't over-alert) so that we get alerted before everything is on fire.
  - Automatic remediation if possible
  - Fall-backs for everything
