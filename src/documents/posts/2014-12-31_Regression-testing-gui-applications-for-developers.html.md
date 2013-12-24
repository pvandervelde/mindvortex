---
title: 'Regression testing for a GUI application with NUnit'
tags: ['Regression test', 'UI test', 'TestStack.White']
commentIssueId: 5000
ignore: true
---


* Disclaimer: Second time I'm doing this. First time was with TestComplete. Now doing a full developer version. Learning as I go

* How do I set up regression tests?
 * For console / scripty apps
 * For UI apps

Example of GUI application

* Write custom console app that handles the test control. Do this because:
 * UI testing is quite complicated, better done in a full IDE than in a script. Requires high robustness (retry's, try..catch in many places etc. etc.)
* Use White for GUI part
* How to handle test ordering
* How to handle test dependencies
* Robustness
 * Try..catch everywhere. Catch exception, even though you shouldn't
 * Retry actions that get controls, several times
 * Time-outs, ugly but sometimes necessary.
 * Check this page for [some hints on how to do UI testing](http://www.mathpirate.net/log/2009/12/23/ui-automation-tricks-and-traps/)