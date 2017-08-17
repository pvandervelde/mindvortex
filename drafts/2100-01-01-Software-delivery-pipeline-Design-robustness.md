Title: Software delivery pipeline - Design robustness
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
  - Infrastructure: highly available services
  - Scripts: Error handling, retries, proper error messages