Title: Calvinverse - Environments
Tags:
  - Delivering software
  - Software development pipeline
  - DevOps
  - Immutable infrastructure
---


- What is an environment
- How many environments do you need?
  - Minimum is production of course. Maybe you'll have multiple production environments (if you
    have multiple locations, e.g. different offices etc.)
  - Second environment should be a test environment so that you can test changes to the infrastructure
  - Third environment we use is the one that the 'build' team uses to develop on new resources
- What should be in an environment (minimum)
  - Consul server
  - Vault
- Additional
  - Fabio (proxy)
  - Consul UI
  - Vault UI