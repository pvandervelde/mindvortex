---
title: 'UI Automation testing of WPF applications via ScriptCs'
tags: ['UI Automation', 'scriptcs', 'WPF']
commentIssueId: 5000
ignore: true
---

* Why would you do this? Lots has been said about UI testing (see .....). In my case I'm doing this because I am currently the only developer on this application and so to make sure I spend my time carefully I'm trying to automate as much of the work as possible.
* Structure, structure, structure!
* Create separate file with constants for Automation IDs. Include this both in your main app and in the scriptcs scripts. Note you can include *.cs files
* Create script helper files for types of controls, e.g.  HelperMethod.Dialog for all dialog interaction, HelperMethod.Menu for all menu interaction.
* Create additional helper files for standard actions, e.g. HelperMethods.Logging for all logging methods
* Create a set of verification methods. These should test a certain state (e.g. is a control enabled, does a control exist etc.) and log an error if it fails. They should not throw an exception / terminate the test. They should count the number of errors and be able to indicate later on if there were errors.