---
title: 'Setting up Sherlock for regression testing - Build server integration'
tags: ['Sherlock', 'Jenkins', 'TeamCity', 'MsBuild']
commentIssueId: 5000
ignore: true
---

Integrating with the build server:

* Write build scripts (e.g. in MsBuild) that will
 * Create the configuration file
 * Register the test
 * Wait for the test results
 * Parse the XML result file for success or failure
* Set up one or more jobs on the build server to handle the test. Probably best to have a separate job for that, regression can take a while and you don't want to slow down the CI build (the one that is triggered on each commit)
* Current way I've done it at work is (with [Jenkins]()):
 *  3 projects: Build (compile, unit test, package and whatever else you need from your CI build), Test (run regression tests) and Deploy (deploy files when you 'release to QA')
 *  2 Build flow projects: 'Nightly', runs Build & Test at midnight if there are changes. 'Release' triggered manually whenever somebody wants a release to QA, runs 'Build', 'Test' and 'Deploy'
 *  Allows your 'Build' job to be re-used for CI, nightly and release. Also is the only project that actually creates binaries and packages, hence no configuration differences between your CI build and your release builds.
 *  Drawback is that you have more projects, which can be a problem if you either have lots of different applications that need build server configurations or if you need to pay for project configurations
* Current way I've done it at home is (with [TeamCity]()):


Some other random things

* How to handle test configurations