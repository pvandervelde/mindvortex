---
title: 'Regression testing with Sherlock'
tags: ['Sherlock', 'Regression test']
commentIssueId: 25
---

Over a series of posts I hope to explain how to set up and use the [Sherlock](/projects/sherlock.html) test environment system. The idea is to follow the set up procedure I used both at home for the [Apollo](/projects/apollo.html) project and the proof of concept I am working on at my work place. But first lets start with a short explanation of what Sherlock is and what it does. 

### What is Sherlock

Sherlock consists of a set of applications and services that provide test environment organisation and automatic execution of a set of tests on one or more test environments. The organisation part consists of:

* Keeping track of which environments exist, which are available for testing and which are not, e.g. for maintenance reasons.
* What operating system is loaded onto each environment.
* Which applications are pre-loaded onto each environment.
* Relationships between virtual machines and their (physical) host machine. 

The test execution part consists of:

* Selection of the most suitable environment for a test based on the desired combination of operating system and available applications.
* Preparing of the environment for test. This includes loading test environments, i.e. waking up physical test environments through the [Wake-on-LAN](http://en.wikipedia.org/wiki/Wake-on-LAN) approach and starting virtual machines, and sending over the test data, e.g. installer files.
* Triggering test execution on the active test environment.
* Processing test status and test report information.
* Post test environment clean-up. This currently only includes resetting virtual machine disks back to the pre-test state.
* Accumulation of test events and generation of the final test report.

In general the Sherlock system will consist of at least one [Hyper-V](http://en.wikipedia.org/wiki/Hyper-V) host machine and a set of one or more Hyper-V virtual machines. In this arrangement the host machine handles the test organisation and part of the test execution, while the virtual machines serve as test environments. 

While it is possible for Sherlock to execute tests on physical machines it is advised to only execute on virtual machines because of the inability to reset a physical machine back to the pre-test state. Virtual machines on the other hand can easily be restored to the pre-test state through the use of snapshots.

### The life of a test

When executing a test with Sherlock the following steps are present: 

1. The user creates a test configuration file which describes all requirements for the test environment, which steps should be executed and where the report should be placed.
* The user registers the test with Sherlock via the console application.
* Some time after the registration of the test completed the Sherlock host service loads test information and selects one or more suitable environments to execute the test steps on. The time between the completion of the test registration and the starting of the test execution depends on whether suitable test environments are available and how busy they are.
* The selected test environments are prepared for the test execution. This preparation includes activating the environment and transferring the test data for each environment (e.g. installer files etc.).
* Each environment executes the desired test steps and reports back on the success or failure of each test step.
* Once an environment has completed its test steps it will report the completion the test, upon which the host service will terminate the environment and restore it to the original state.
* Once all environments have completed their test steps the test is marked as completed and the test report is compiled and placed in the predetermined location.  

### Pre-requisites

The first pre-requisite in the configuration is the [latest release](https://github.com/pvandervelde/Sherlock/releases) of sherlock. A release consists of a number of ZIP packages including:

* **console.zip** - Contains the binaries and configuration files for the console application which is used to register a test.
* **sherlock.web.api.zip** - The web service that will store information about a new test in the database.
* **sherlock.web.intranet.zip** - The management web site that can be used to add or remove test environments.
* **service.zip** - The windows service that is used to run the *master controller* or the *executor controller*.
* **service.master.zip** - The master controller application which handles the scheduling of tests, loading and unloading of test environments and processing of the test reports. 
* **service.executor.zip** - The executor controller application which controls the execution of a test on a test environment.
* **sql.zip** - The SQL change scripts for the database.

The second pre-requisite is the availability of a physical machine on which a Windows version with [Hyper-V](http://en.wikipedia.org/wiki/Hyper-V#System_requirements_and_specifications) can be installed.

### Planned posts: 

The next following posts will describe:

1. [How to set up the Hyper-V host machine.](/posts/2013-12-10_Setting-up-Sherlock-serverside.html)
* [How to prepare a virtual machine for use as a testing environment.](/posts/2013-12-11_Setting-up-Sherlock-virtualmachines.html)
* [How to verify that all the environments have been configured correctly.](/posts/2014-12-31_Setting-up-Sherlock-verification.html)
* How to integrate with a build server. This will discuss build jobs, build scripts and test configuration.
* A description on how I used Sherlock to perform integration tests on the console application of Apollo.
* And a description on how I used Sherlock to perform integration tests on a WPF application of [Apollo](/projects/apollo.html).