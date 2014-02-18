---
title: 'Regression testing for a GUI application with White'
tags: ['Regression testing', 'UI test', 'TestStack.White', 'Apollo']
commentIssueId: 5000
ignore: true
---

In the [previous](/posts/2014-12-31_Regression-testing-console-applications.html) post I explained how I created the regression tests for the script running application of [Apollo](). In this post I will explain how I created the UI tests for the UI of Apollo.

Example of GUI application

* Write custom console app that handles the test control. Do this because:
 * Tried using NUnit and some other test frameworks but in the end they have drawbacks (no real control over the order of the tests, hard to run tests multiple times, .... ) 
 * UI testing is quite complicated, better done in a full IDE than in a script.
 * Tried using [ScriptCS]() but in the end the code got rather complicated with many, many files. ScriptCS didn't care but for me it was too hard to work with. So switched to Visual Studio and created a command line application that would execute all my tests.
 * Will give some examples of the pieces of code in my application. Note that this is not actually a test framework because I've only written one so it's still quite specific. Maybe if I write a few more I might make it into a framework
* Robustness
 * Try..catch everywhere. Catch exception, even though you shouldn't 
 * Retry actions that get controls, several times because you may not always be able to get to a control when you want. Note that humans are generally much slower so they might not see that a control isn't available for 0.1 second, your UI tests should easily be able to spot that. This also makes for some very tricky debugging. you will need a decent amount of logging to catch these.
 * I wrote a retry method that retries an action several times, potentially with wait time-outs between the retries. Note that the White framework handles retries for certain actions but I found that sometimes you just need to retry again (and maybe even wait a bit). **[EXAMPLE CODE]**
 * My code retries a test 3 times before it calls it a fail. If the test passes before that no further retries are done and the test is considered passed. Again sometimes you just need a second shot at it. It is probably worth it logging this behaviour so that you can try to understand why it is not working. **[EXAMPLE CODE]**
 * Add heaps of debugging methods / logging etc.. At some point you will need it. **[EXAMPLE CODE]**
 * Time-outs, ugly but sometimes necessary.
 * Check this page for [some hints on how to do UI testing](http://www.mathpirate.net/log/2009/12/23/ui-automation-tricks-and-traps/)
 * You can make the tests surprisingly robust so don't give up if at first you can't get the test to do what you want. **[EXAMPLE]**
* For each test restart the application if at all possible so that you end up with a known application state. This will improve the repeatability of the tests. 
 * If the application is slow to start up then you now have a good reason to speed it up. If that's not possible carefully combine tests but be aware that tests may fail due to polluted application state. 
 * Note that some application state survives restarts (e.g. settings). It would be good if you have a way of resetting that state in a relatively sure-fire way. My tests currently don't do that but they really should.
* Make sure you reset your application state either at the end of each test or at the start of each test. Or even better both, because you can never know if you are going to actually make it to the end (application may crash)
* I chose to use [TestStack.White]() for GUI part
 * Chose it over [CodedUI]() and others because it is an open source library, which has been around for a bit so it should be pretty stable and if push comes to shove I can get hold of the source and fix any problems with it. Also it allows me to program in C# instead of some silly script language.
 * Is quite powerful but there are definitely some tricky bits to it.
 * Some tricky bits aren't actually a problem with White but more with the underlying UI action framework that is build into windows.
* Think about test ordering. Most sensible seems to be to test independent functionality before testing dependent functionality. However the ordering is some what arbitrary
* This has been much more tricky than I thought it would be and the approach I used required some decent coding skills so this may or may not be suitable in other situations depending on the skill sets of the testers / developers etc.