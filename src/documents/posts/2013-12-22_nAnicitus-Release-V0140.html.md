---
title: 'nAnicitus release - V0.1.4.0'
tags: ['nAnicitus']
commentIssueId: 31
---

Version [V0.1.4.0](https://github.com/pvandervelde/nAnicitus/releases/tag/V0.1.4.0) of the [nAnicitus](/projects/nanicitus.html) symbol store application has been released. This release fixes issue [#1](https://github.com/pvandervelde/nAnicitus/issues/1). If a package is locked by the operating system, e.g. because the file write has not completed yet, then nAnicitus will try to load the package 3 times, waiting 5 seconds between each try. On top of that if the loading of a package fails then the nAnicitus will retry loading the package 3 times before giving up.