---
title: 'Regression testing for a GUI application with White'
tags: ['Regression testing', 'UI test', 'TestStack.White', 'Apollo']
commentIssueId: 5000
ignore: true
---

In the [previous](/posts/2014-02-18_Regression-testing-console-applications.html) post I explained how I created the regression tests for a script running application that belongs to the [Apollo](/projects/apollo.html) project. In this post I will explain how I created the regression tests for an Apollo application with a graphical user interface (UI).

My initial attempt to write a regression test suite for the GUI application was done using the [NUnit](http://www.nunit.org/) and [ScriptCS](http://scriptcs.net/) with the idea that NUnit would provide the test execution and validation methods and ScriptCs would provide an easy way to write the test scripts without requiring a complete IDE to be used. After some trial-and-error it became clear that this approach was not the most suitable solution for the following reasons:

* Using NUnit, or any unit test framework for that matter, complicated things because there is no way to take control of the order in which the regression tests are executed. While the ordering of unit tests is irrelevant, the ordering of regression tests may not be in that it is accepted that regression tests involve the execution multiple, ordered tests for one single activation of the application under test (AUT).
* A secondary drawback of using a unit test framework is that there is normally no way to re-run a test case if it fails, something which is more acceptable for a regression test than for a unit test.
* The test code got rather complicated due to the many helper methods, script files etc.. While ScriptCs coped beautifully with this it turned out to hard for me to work with without the organizing features of a complete IDE.

In the end I wrote a custom (console) application that handles the ordering and execution of the different test cases.

* Will give some examples of the pieces of code in my application. Note that this is not actually a test framework because I've only written one so it's still quite specific. Maybe if I write a few more I might make it into a framework


### Testing framework


* Robustness
 * Try..catch everywhere. Catch exception, even though you shouldn't 
 * My code retries a test 3 times before it calls it a fail. If the test passes before that no further retries are done and the test is considered passed. Again sometimes you just need a second shot at it. It is probably worth it logging this behaviour so that you can try to understand why it is not working. **[EXAMPLE CODE]**
 * Store results of test and only exit at the end of all the tests so that you always have a complete test run **[EXAMPLE CODE]**
 * Add heaps of debugging methods / logging etc.. At some point you will need it. **[EXAMPLE CODE]**
 * Retry actions that get controls, several times because you may not always be able to get to a control when you want. Note that humans are generally much slower so they might not see that a control isn't available for 0.1 second, your UI tests should easily be able to spot that. This also makes for some very tricky debugging. you will need a decent amount of logging to catch these.
 * I wrote a retry method that retries an action several times, potentially with wait time-outs between the retries. Note that the White framework handles retries for certain actions but I found that sometimes you just need to retry again (and maybe even wait a bit). **[EXAMPLE CODE]**
 * Time-outs, ugly but sometimes necessary.
 * Check this page for [some hints on how to do UI testing](http://www.mathpirate.net/log/2009/12/23/ui-automation-tricks-and-traps/)
 * You can make the tests surprisingly robust so don't give up if at first you can't get the test to do what you want. **[EXAMPLE]**
* For each test restart the application if at all possible so that you end up with a known application state. This will improve the repeatability of the tests. 
 * If the application is slow to start up then you now have a good reason to speed it up. If that's not possible carefully combine tests but be aware that tests may fail due to polluted application state. 
 * Note that some application state survives restarts (e.g. settings). It would be good if you have a way of resetting that state in a relatively sure-fire way. My tests currently don't do that but they really should.
* Make sure you reset your application state either at the end of each test or at the start of each test. Or even better both, because you can never know if you are going to actually make it to the end (application may crash)


### Tests

* I chose to use [TestStack.White](https://github.com/TestStack/White) for GUI part
 * Chose it over [CodedUI](http://msdn.microsoft.com/en-us/library/dd286726.aspx) and others because it is an open source library, which has been around for a bit so it should be pretty stable and if push comes to shove I can get hold of the source and fix any problems with it. Also it allows me to program in C# instead of some silly script language.
 * Is quite powerful but there are definitely some tricky bits to it. e.g. sometimes the internal retry / wait parts of White don't manage to come up with a result, however retrying / waiting in the test code usually solves that problem
 * Some tricky bits aren't actually a problem with White but more with the underlying UI action framework that is build into windows, e.g. most controls can be found by automation ID but windows cannot, even if they have one.
* Write lots of helper methods to make the tests more clear.
 * If a helper method returns a value it should either return the requested object or null. Then always check for null when calling the method. Only throw test fail exception when the conditions for the method are wrong (e.g. the application under test (AUT) has crashed or something like that).
 * If the helper method just executes some action it will throw a specific test fail exception.
* Think about test ordering. Most sensible seems to be to test independent functionality before testing dependent functionality. However the ordering is some what arbitrary
* This has been much more tricky than I thought it would be and the approach I used required some decent coding skills so this may or may not be suitable in other situations depending on the skill sets of the testers / developers etc.
* Share data between tests and application so that the tests are always in sync with the application state. Note that this means that the tests are linked to a specific version of the application, but that is ok because the tests always are anyway
 * Application / Product / Company names can be shared via a shared config or shared code file **[EXAMPLE CODE]**
 * Automation IDs should be shared via a shared code file. Note that application ID names should be pointing to a given area / functionality, not specific controls. Note that in my case that's not always done the right way. Still learning here. **[EXAMPLE CODE - IN APP - IN TEST]**
* Don't give up if you can't get the tests to be reliable, just keep improving the robustness of the test code and eventually it should even out. During the writing of the tests I found several bugs in my application so in all it has paid off.
