Title: 'Sherlock'
Lead: "Sherlock provides a means to schedule and automatically execute tests in an controlled environment."
Tags:
  - Project
ShowInNavbar: false
---

[Sherlock](https://github.com/pvandervelde/Sherlock) provides a means to schedule and automatically execute tests in an controlled environment. In order to schedule a test the configuration and the
test data can be uploaded to the server via a console application. The test configuration describes all the steps necessary to perform a complete test. This includes installation of MSI files, copying
files / directories and execution of powershell scripts.

For environments Sherlock uses Hyper-V virtual machines which allow easy control of the environment state prior to the execution of a test.

Sherlock consists of:

* __Sherlock.Console__ - The command line application that can be used to schedule tests based on a XML configuration file. The application extracts the desired information from the configuration file and uploads the test information and the required binaries, e.g. MSI installer files, to the server.
* __Sherlock.Service.Master__ - The application that schedules and tracks the execution of the tests.
* __Sherlock.Service.Executor__ - The application that runs on the test environment which handles the communication with the _Sherlock.Service.Master_ service for exchange of test information, test files and test reports.
* __Sherlock.Executor__ - The application that executes the actual test steps.
* __Sherlock.Web.Api__ - The web service that is used to register tests.
* __Sherlock.Web.Intranet__ - Provides a way to add, update and remove information about the available test environments. Can also be used to temporarily disable an environment, e.g. when maintenance needs to be done on the environment.
* __Sherlock.Service__ - The service that controls the _Sherlock.Service.Master_ and _Sherlock.Service.Executor_ applications and allows automatic updates when new versions become available.
