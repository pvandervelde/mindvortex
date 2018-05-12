Title: Calvinverse - An example build infrastructure
Tags:
  - Delivering software
  - Software delivery pipeline
  - DevOps
  - Immutable infrastructure
---

- Introducing: [Calvinverse](https://github.com/Calvinverse). The project where I store the source code for my build infrastructure.
- The goals for Calvinverse are two-fold. First to provide me with a way to experiment with build infrastructure, infrastructure-as-code etc. etc. Second to provide an example of how to setup build infrastructure so that it works well and is reliable.

- Different ways to use Calvinverse:
    - For small setups with only a few developers and a few products
        - Only need a jenkins master + one or two slaves, probably ideally a VM (easier to manage) and maybe
          a file share for NuGet packages
    - For medium setups with a larger number of developers or lots of products
        - Need a jenkins master + a number of slaves, possibly use docker containers
    - For large setups with a large number of developers and a lot of products
        - Need both a production and a test environment
        - Teams need to be able to create their own build slaves

- Calvinverse is designed as a self-maintained system. It's not a hosted system
