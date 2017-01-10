Title: GUI testing with TestStack.White
Tags:
  - Regression testing
  - UI test
  - TestStack.White
  - Apollo
---

In the [previous](/posts/Regression-testing-console-applications.html) post I explained how I
created the regression tests for a script running application that belongs to the [Apollo](/projects/apollo.html)
project. In this post I will explain how I created the regression tests for an Apollo application
with a graphical user interface (UI).

My initial attempt to write a regression test suite for the GUI application was done using the
[NUnit](http://www.nunit.org/) and [ScriptCS](http://scriptcs.net/) with the idea that NUnit would
provide the test execution and validation methods and ScriptCs would provide an easy way to write the
test scripts without requiring a complete IDE to be used. After some trial-and-error it became clear
that this approach was not the most suitable solution for the following reasons:

- Using NUnit, or any unit test framework for that matter, complicated things because there is no
  way to take control of the order in which the regression tests are executed. While the ordering of
  unit tests is irrelevant, the ordering of regression tests may not be in that it is accepted that
  regression tests involve the execution multiple, ordered tests for one single activation of the
  application under test (AUT).
- A secondary drawback of using a unit test framework is that there is normally no way to re-run a
  test case if it fails, something which is more acceptable for a regression test than for a unit test.
- The test code got rather complicated due to the many helper methods, script files etc.. While
  ScriptCs coped beautifully with this it turned out to hard for me to work with without the
  organizing features of a complete IDE.

In the end I wrote a custom (console) application that handles the ordering and execution of the
different test cases in the way that makes sense for my current requirements.


#### Testing application

The testing application executes the tests, collects the results and logs all the outputs. When
executing the tests each test is executed a maximum of three times before it is marked as a fail.
The following code is used by the application to execute the test steps and to keep track of the
number of times a test step is executed.

<script src="https://gist.github.com/pvandervelde/8995455.js?file=Apollo_Regression_ExecuteTestStep.cs"></script>

<script src="https://gist.github.com/pvandervelde/8995455.js?file=Apollo_Regression_TestStep.cs"></script>

The reason for having multiple attempts to complete a test is that the nature of the GUI automation
testing is that it is not completely [consistent](http://www.mathpirate.net/log/2009/12/23/ui-automation-tricks-and-traps/).
By allowing a test to fail twice it is possible to work around the problem of inconsistent handling
of controls.

The second part of the application keeps track of the test results while the tests are running. The
application will always try to execute all the tests, irrespective of their final success or failure.
That way the user will always have a complete report of the state of all the tests.

<script src="https://gist.github.com/pvandervelde/8995455.js?file=Apollo_Regression_EntryPoint.cs"></script>

Finally the application provides utility methods for logging which should be used liberally by both
the application and the test steps.


#### Tests

In order for the tests to interact with the GUI I chose to use the [TestStack.White](https://github.com/TestStack/White)
library mainly because it is a mature open source library that has a number of active contributors.
One thing to keep in mind when selecting a GUI automation library is that the [underlying technology](http://en.wikipedia.org/wiki/Microsoft_UI_Automation)
has some tricky hooks to it that cannot be completely hidden by the automation library. One example
is that all controls can be found based on their [automation ID](http://msdn.microsoft.com/en-us/library/aa349646%28v=vs.110%29.aspx)
but windows cannot, even if the window in question has an automation ID.

The main piece of advice for writing UI automation tests is always to write some helper methods to
hide the underlying complexity of the UI access technology. In my case I took the following steps:

- Control very carefully how your helper methods return information to the caller, either through a
  return value or through exceptions. In my case if a helper method returns a value it should either
  return the requested object or null if it fails to get the requested object. The calling code should
  then always check for null and handle the case of a null return value, e.g. by retrying the method
  call. The only time the method will throw an exception is if the assumed conditions for the method
  are wrong, e.g. the application under test (AUT) has crashed. If the helper method has no return
  value then it may throw if it fails to execute.

<script src="https://gist.github.com/pvandervelde/8995455.js?file=Apollo_Regression_HelpersForMenu.cs"></script>

- All actions that get a control will try to get the control several times if they fail. Due to the
  nature of UI automation it is possible that the control is not available the first time the code
  tries to get hold of the control. This may be due tot he fact that the automation tests are fast
  enough that they try to get the control in the 0.1 second that the control is not available yet.
  Note that this also makes for some very tricky debugging which requires a decent amount of logging.

<script src="https://gist.github.com/pvandervelde/8995455.js?file=Apollo_Regression_Retry.cs"></script>

  Note that automation tests are usually linked strongly to a specific version of the software
  because the tests assume the availability of certain automation IDs and controls. Some parts are
  implicitly linked and others can be, but don't have to be, explicitly linked. Examples are:
- The application, product and company names can be shared through a configuration or shared code file:

<script src="https://gist.github.com/pvandervelde/8995455.js?file=Apollo_Regression_CompanyInformation.cs"></script>

- Automation IDs can be shared via a shared code file. Note that application ID names should be
  pointing to a given area / functionality, not specific controls (Also note that in my case that's
  not always done the right way):

<script src="https://gist.github.com/pvandervelde/8995455.js?file=Apollo_Regression_AutomationID.cs"></script>

<script src="https://gist.github.com/pvandervelde/8995455.js?file=Apollo_Explorer_MenuView.xaml"></script>

When executing the tests it is a good idea to reset your application state either at the end of each
test or at the start of each test. Or even better both to make sure that you always start a test
from the same state irrespective of the way the previous test ended, e.g. with an application crash.

Finally do not give up if you find it hard to make the tests reliable. By continually improving the
robustness of the test code eventually the tests will start to behave in the way you expect them
too. Some [tricks and hacks](http://www.mathpirate.net/log/2009/12/23/ui-automation-tricks-and-traps/)
that I found necessary are:

- Time-outs while getting controls, setting values on controls or getting values from controls. While
  these are ugly they are sometimes necessary.
- For each test restart the application if at all possible so that you end up with a known application
  state. This will improve the repeatability of the tests. Note that if the application is slow to start
  up then you can either improve the start up performance of the application or if that is not possible
  then carefully combine tests but be aware that tests may fail due to polluted application state.
- Note that some application state survives restarts, e.g. user and application settings. It would
  be good if you have a way of resetting that state in a relatively sure-fire way. This is something
  I have not implemented yet though.

And then the last comment must be that the development of these tests has been much more complicated
than I thought it would be. The approach I used required some coding skills so this may or may not be
suitable in other situations depending on the skill sets of the testers or developers.
