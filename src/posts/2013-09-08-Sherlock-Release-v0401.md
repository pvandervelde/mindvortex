Title: Sherlock release - V0.4.0.1
Tags:
  - Sherlock
commentIssueId: 3
---

Version [V0.4.0.1](https://github.com/pvandervelde/Sherlock/releases/tag/v0.4.0.1) of the [Sherlock](/projects/sherlock.html) regression testing application has been released. This release adds two new features and one improvement.

The new features are:

* The ability to continue with a test sequence after a test step has failed. The test step should indicate that the failure mode is 'continue'. Other option is 'stop'
* Added a test step that allows executing a console application with a set of input parameters

The following gist gives an overview of what the configuration for the new console test step looks like

<gist>6483292</gist>

The improvement is in the HTML output report which is has been overhauled to improve the layout and readability.
