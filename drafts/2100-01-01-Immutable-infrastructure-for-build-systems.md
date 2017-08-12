Title: Software delivery pipeline: Immutable infrastructure
Tags:
  - Delivering software
  - Immutable infrastructure
  - DevOps
---


- Lots of movement in the ops area, especially when it comes to infrastructure in the cloud.
- DevOps is the magic word, cooperation between devs and ops. Automation of all kinds of resources and processes (Note that devops isn't just automation or tools or people, it's a
combination of all of these things (link)).
- Decent amount of progress on generating the test and productions environments for products
- However the build environment is also important. If you can't build in a clean environment, how can you be sure that you can deliver a consistent product
- Going to document our journey on the way to using [immutable infrastructure](https://thenewstack.io/a-brief-look-at-immutable-infrastructure-and-why-it-is-such-a-quest/) for our build environment

Discussing on-prem systems only. These ideas apply to cloud-based build systems as well
but given that the user doesn't have to worry about the infrastructure.
There are benefits to both cloud-based build systems and to on-prem systems.

Goals for a build system:

-

