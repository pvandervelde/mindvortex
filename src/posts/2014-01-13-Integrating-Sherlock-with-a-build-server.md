Title: Sherlock configuration - Build server integration
Tags:
  - Sherlock
  - Jenkins
  - TeamCity
  - MsBuild
---

Once the configuration of [Sherlock](/projects/sherlock.html) is complete the last step needed to
make use of automatic regression testing is to integrate with a build server. In this post I will
explain which steps need to be taken to integrate Sherlock with a build server. Examples will be
given for [Jenkins](http://jenkins-ci.org/), which is used at my work, and
[TeamCity](http://www.jetbrains.com/teamcity/), which I use personally.

In order to integrate with a build server you will need to:

- Create at least one test configuration
- Write the build scripts necessary to register a test, wait for the completion of the test and
  process the results.
- Set up a job on the build server to execute the test.


### Test configurations

In order to execute a test the first thing you need to decide on is the test configuration which
will be executed. In Sherlock the test configuration is described by a XML file similar to the
following gist:

<script src="https://gist.github.com/pvandervelde/8346703.js"></script>)

In this configuration file replace all instances of `${SOME_TEXT}$` with the appropriate information.
Note that some configuration settings should be templated so that those values can be supplied by the
build system, e.g. the application version number:

- Provide an application name and version for use in the test report.
- Provide a compact description. This will be used as the title of the test report
- Provide each environment with a name. It doesn't matter what that name is as long as it is
  consistently used throughout the configuration file. All test steps which should be executed on
  the same environment should be linked to the same environment name. Note that while it is possible
  to request multiple environments to be started in a test, it is not possible to synchronize those
  environments. In other words each environment will exit as soon as it completes the test steps
  assigned to it, no environment will wait for other environments to complete their work.
- For each test step that needs to be executed provide the order (integer number starting at 0,
  incrementing for each step), the name of the environment in which the step should be executed, the
  failure mode, either Stop or Continue and the correct file paths. Note that the test steps use the
  following definitions for their file paths:
    * **msi:** `file` is the absolute path to the MSI file as on the machine that is used to register
      the test (i.e. the origin).
    * **x-copy:** `destination` is the absolute path to the directory that will hold all the x-copy
      results on the test environment.
    * **x-copy:** `base` is the absolute path to the directory that holds the files / directories to
      be x-copied on the origin.
    * **x-copy:** `paths` contains the absolute paths to the files / directories that should be
      x-copied. It is expected that these all reside in the `base` directory at some level.
    * **script:** `file` is the absolute path to the script file on the origin.
    * **console:** `exe` is the absolute path to the executable that should be executed on the test
      environment. Note that the path is also pointed to the test environment. Hence the `CONSOLE`
      test step is the only test step that doesn't copy files.
    * **All test steps:** All files and directories that should be included in the report are
      absolute paths on the test environment.
    * **notification:** The absolute path where the final report should be placed. This path should
      be accessible to both Sherlock (the master controller) and the application that will process the test results.
- It makes sense to always copy back any logs that are written during the test. If you don't need
  them for test failure diagnosis then it is easy to delete them later, however you can't copy them
  from the test environment after the test has completed because the test environment will be reset
  to its original state upon shut down.

If you need tests to run in different environments or with different test steps then you will need to
create a configuration file for each environment / set of test steps.


### Build scripts

The easiest way to execute the test from a build server is to create a set of build scripts that can
do the work for you. In this example I will be using MsBuild as the scripting language.

In order to create the configuration file from the template it is necessary to replace all the
templated configuration settings with their current values. The following gist shows an inline
MsBuild task that does exactly that:

<script src="https://gist.github.com/pvandervelde/8277812.js?file=TemplateFile.xml"></script>

In order to use this task create an `ItemGroup` with the identifiers of the settings and their
replacement values. For example:

<script src="https://gist.github.com/pvandervelde/8277812.js?file=HowToUseTemplateFile.xml"></script>

If this example is used on the following template file:

<script src="https://gist.github.com/pvandervelde/8277812.js?file=BeforeReplacement.xml"></script>

Then the outcome is the following output file:

<script src="https://gist.github.com/pvandervelde/8277812.js?file=AfterReplacement.xml"></script>

The next step will be to create a build script that can register the test with the Sherlock system.
This can either be done with a call to the
[exec](http://msdn.microsoft.com/en-us/library/x8zx72cd.aspx) task or with the following inline
MsBuild task:

<script src="https://gist.github.com/pvandervelde/8346876.js"></script>

The next step is a little tricky in that it is now necessary to wait for Sherlock to execute the
test and create the test report. The tricky bit due to the fact that Sherlock will only execute the
tests when a suitable test environment is available. That means that tests could be executed almost
immediately if an environment is directly available, or not for a long time if all environments are
busy. On top of that MsBuild does not have the ability to watch specific files. The following inline
task allows you to wait for certain files to be created. Note that you need to provide a time-out
which determines how long this task will wait for the report files. How long this time-out should be
depends on:

- How long it takes for the tests to execute.
- How many tests will be executed on the same test environments. Tests executing on different test
  environments can be run in parallel provided the hardware will stand up to it.
- How many other tests may potentially be executing at the same time.

<script src="https://gist.github.com/pvandervelde/8346893.js"></script>

Finally the report files need to be checked for success or failure. For each test Sherlock produces
a HTML and an XML report. The easiest way to find the outcome of a test is to parse the XML report
and search for the `result` element. The value of this element will either be `Passed` or `Failed`.
The following inline task will accomplish this goal:

<script src="https://gist.github.com/pvandervelde/8346900.js"></script>


### Build jobs

The final task is to setup one or more build jobs for the build server to execute. While you can
combine the testing steps with the build steps it is in general advisable to have a separate job for
the testing steps. The main reason for that is that the the testing steps can take quite a while to
execute, ranging from several minutes to hours, which slows down the continuous integration feedback
cycle considerably. Based on the idea that the tests should be contained in their own build job the
following set-up is proposed.

- Define three different build jobs for the build, test and deploy stages of the process. This means
  that each job will be responsible for a specific task. Individual jobs will be use the artefacts
  produced by the other jobs.
- Set up dependencies between the different builds where required. For instance the test job will
  depend on the artefacts produced by the build job.
- The build job can be run both as continuous integration build, i.e. execute the build job each
  time a commit to the source control system is detected, and as pre-requisite to the test job.
- Similarly the test job could be run nightly to provide relatively quick feedback on regression
  problems while also acting as pre-requisite to the deploy job.
- If the version number includes either the build counter of the build job or the revision number of
  the source control commit then special care needs to be taken for the test and deploy jobs in
  order to ensure that they get the same numbers as the build job did.
- In a similar fashion it will be necessary to control the version control settings so that all builds
  pull in the same revision. One solution would be to store the revision index in the first job in
  the chain and then transfer that to the other jobs.

For the two build systems I have specifically worked with the following additional notes can be made:

- [Jenkins](http://jenkins-ci.org/)
    * In addition to the three standard jobs you will probably need a [Build flow](https://wiki.jenkins-ci.org/display/JENKINS/Build+Flow+Plugin)
      job to trigger the different standard jobs in the right order. This has to be done because at
      the moment it does not seem possible in Jenkins to trigger pre-requisite builds without having
      the downstream project taking up one of the build executors. The build flow jobs live outside
      the actual build executors which makes it possible to optimize the use of the executors.
    * In order to deal with the build number problems as specified above the simplest way is to write
    the number to a file in the upstream job, archive that and then pull it out in the downstream jobs.
    The same goes for the version control information.
- [TeamCity](http://www.jetbrains.com/teamcity/)
    * Downstream jobs have both a snapshot dependency and an artefact dependency on the upstream job.
      The [snapshot dependency](http://confluence.jetbrains.com/display/TCD8/Configuring+Dependencies)
      takes care of the synchronization of the version control revision. Note that you should create
      different VCS roots for each project, otherwise the projects all share a single check-out directory.
      By sharing a single directory it is possible that upon starting the second job the directory is
      cleaned which will likely remove the artefacts from the first job.
    * The build number can be copied easily by [synchronizing](http://confluence.jetbrains.com/display/TCD8/Configuring+General+Settings#ConfiguringGeneralSettings-BuildNumberFormat)
      the build numbers.
