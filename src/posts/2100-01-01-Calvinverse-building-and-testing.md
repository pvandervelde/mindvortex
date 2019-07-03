Title: Calvinverse - Building and testing
Tags:
  - Delivering software
  - Software development pipeline
  - DevOps
  - Immutable infrastructure
---


- How to build
  - Using [nBuildKit]() and [ops-tools-build]() for the build scripts
  - Invoke the build generally with `msbuild entrypoint.msbuild /t:build` with additional properties
  - Should drop outputs in `build/deploy`. Generally a zip file with the Hyper-V files
  - Requirements
    - nuget.exe on the commandline
    - Hyper-V installed and the user is a Hyper-V admin
    - Hyper-V switch with the correct name
- How to test
  - Smoke tests -> `msbuild entrypoint.msbuild /t:test` -> runs standard tests
  - Deploy into an environment, run tests

  ## Repositories

- Configurations are stored in different repositories
  - General configurations, mostly setting information for the different resources. While the environment
    is running will be stored in the Consul key-value store. The original values are stored in the
    [Calvinverse.Infrastructure]() repository
  - Dashboards
  - Log filters
  - Elasticsearch index templates
- Ideally builds will be configured so that a change to the configuration will be tested and pushed
  to a suitable test environment
- Image repositories. Contain code to create the VM images. Work in progress to make them able to go
  to Azure if necessary
  - With some minor changes could also create images for AWS etc. Images are made using [Packer]() so
    anything packer can create can be made