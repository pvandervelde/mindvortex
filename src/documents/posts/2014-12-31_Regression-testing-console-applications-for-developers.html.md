---
title: 'Regression testing for a console application with NUnit'
tags: ['Regression test', 'Console']
commentIssueId: 5000
ignore: true
---

* Disclaimer: Second time I'm doing this. First time was with TestComplete. Now doing a full developer version. Learning as I go. Didn't even write the actual tests last time, am writing them now

* How do I set up regression tests? For console / scripty apps

Example of scripty app

* Can just invoke the console application and see what happens. In this case we have several scripts for the application to consume. Do this in a sensible order
* Need some way of turning the app output into a test report.
 * Use the standard output as the notifications and the error output as test failures
* Check the outputs of the app (e.g. output files)
* Check the states of the app
* Can write specific test scripts that perform checks on the state of the app 