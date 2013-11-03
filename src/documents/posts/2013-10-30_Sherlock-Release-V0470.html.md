---
title: 'Sherlock release - V0.4.7.0'
tags: ['Sherlock']
commentIssueId: 18
---

Version [V0.4.7.0](https://github.com/pvandervelde/Sherlock/releases/tag/v0.4.7.0) of the [Sherlock](/projects/sherlock.html) regression testing application has been released. This release provides one bug fix:

* The Windows job object created by the Sherlock service to ensure termination of the Sherlock.Service.Master and Sherlock.Service.Executor applications is now set to only include direct children (i.e. Sherlock.Service.Master / Sherlock.Service.Executor) in the job and not the indirect children. This allows the application under test to create its own job objects even on Windows 7 (which does not allow nesting of job objects) ([issue #11](https://github.com/pvandervelde/Sherlock/issues/11)).