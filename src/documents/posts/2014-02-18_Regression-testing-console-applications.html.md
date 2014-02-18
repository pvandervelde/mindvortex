---
title: 'Regression testing of a console application'
tags: ['Regression testing', 'Console', 'Apollo', 'Scripting']
commentIssueId: 37
---

After [setting up](/posts/2013-12-04_Regression-testing-with-Sherlock.html) [Sherlock](https://github.com/pvandervelde/Sherlock) you will need to create some tests that you can execute with Sherlock. In this post I will describe how I created the regression tests for the command line application of [Apollo](/projects/apollo.html).

For this case the application-under-test (AUT) is the Apollo console application which provides the user with a way to control the capabilities of Apollo, e.g. running a fluid dynamics simulation, by executing a Python script. The goal of the regression test for the console application is to execute a large part of the API which is used by scripts to interact with the different parts of Apollo.

In order to test the scripting API I wrote several scripts that will be executed during the test. Each script exercises several parts of the API and checks after each action that the state of the application is as expected. An example of a test script is given in the following code segment:

<gist>8995251</gist>

This test script:

1. Verifies that no project exists at start-up. If one exists the test is considered failed and the script forces the application to exit with a non-zero exit code.
* Creates a new project and obtains a reference to the new project. If either step fails then once again the application is forced to exit with a non-zero exit code.
* The name of the project is changed and the script verifies that the new name has been stored.

Obviously the script given here is a rather trivial and somewhat naive test script however it does provide an idea of what a test script should do.

In order to inform Sherlock that the script execution has failed the script can either write to the error stream or it can force the application to exit with a non-zero error code. To provide data for fault analysis a test script can write to both the standard output stream and the error data stream. Information gathered from either stream will be placed in the Sherlock log, which can be copied back to the report location by setting the correct switches. Additionally any data on the error stream will be written to the test report.

It is important to note that the test script should be robust enough to handle any kind of problem encountered because there is no guarantee that the application will behave in the appropriate manner, after all the application is being tested to see if it is fit for purpose.

Once the test scripts are written you can create a test configuration for the different test steps. An example is given below:

<gist>8995455</gist>

The important things to note in this configuration are:

* Each test step copies back the system log files which include:
 * The Sherlock log file written on the test environment.
 * Any MSI install log files.
* The test script executing test step also copies the log files written by the console application.