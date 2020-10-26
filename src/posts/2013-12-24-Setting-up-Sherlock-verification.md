Title: Sherlock configuration - Verification
Tags:
  - Sherlock
---

After the configuration of the [host machine](/posts/Setting-up-Sherlock-serverside.html) and the
[virtual machines](/posts/Setting-up-Sherlock-virtualmachines.html) the final step in the configuration
of Sherlock is to verify that everything is configured correctly. This can be done by using the
verification package that comes with each [release](https://github.com/pvandervelde/Sherlock/releases)
of Sherlock. In order to use the verification package take the following steps:

- Unpack the **verification.zip** package to a directory somewhere (e.g. `c:\temp\sherlock`).
- Update the configuration file `Sherlock.VerificationConfiguration.msbuild` with the following settings:
    * **ConfigurationReportDirectory:** The directory where you want the final report to be placed.
      Note that both the user who requests the test and the user which is used to run the Sherlock
      services need to have access to this directory. The `report` directory that was created on the
      [host](/posts/Setting-up-Sherlock-serverside.html) machine
    * **ConfigurationServerUrl:** The URL of the web service, e.g. `http:\\myhostmachine\sherlock.api`
    * **ConfigurationOperatingSystem:** The operating system name that you want to test with. This
      needs to match one of the operating systems that has been registered with the management website
      and which is installed on at least one of your test environments.
    * **ConfigurationOperatingSystemServicePack:** Can be left empty if the operating system has no
      service pack. If the operating system has a service pack then it needs to match the service
      pack name of the operating system as registered with the management web site.
    * **ConfigurationOperatingSystemCulture:** The [culture](https://en.wikipedia.org/wiki/IETF_language_tag)
      as defined for the registered operating system.
    * **ConfigurationOperatingSystemPointerSize:** The 'bitness' or pointer size for the operating
      system, either 32 or 64 bits. Should again match the value that was provided when the operating
      system was registered.
    * **ConfigurationRemotePcWorkingPath:** A path where the test files will be placed on the test
      environment, e.g. `c:\temp`.
    * **ConfigurationSherlockConsoleDirectory:** The directory where the console application is
      installed, this may be a UNC path or a normal directory, e.g. `\\MyHostMachine\console`.
- Execute the `Sherlock.ExecuteVerificationTests.msbuild` script. This script will prepare the files
  to be send across (a test application and some test scripts), start the console application, register
  the test and then wait for the reports to be produced.

Note that the reports will come back with some errors. The verification was designed this way on
purpose to make it possible to test the error handling. In the end there should be three reports, one
for each known test configuration version, i.e. v1.0, v1.1 and v1.2. The reports should show the
following errors:

- The script execution that executes `c:\temp\Sherlock.Verification.Console.exe` with the `-f` command
  line argument. The `-f` parameter indicates that the process should 'fail' and exit with an exit
  code of 1.
- The script execution for `c:\temp\Sherlock.Verfication.Console.exe` with parameter `-c`. The `-c`
  parameter indicates that the process should exit with an unhandled exception. The exit code for
  the process should be -532462766.
- The application execution `c:\temp\Sherlock.Verification.Console.exe` with the `-f` command line argument.
- The application execution for `c:\temp\Sherlock.Verfication.Console.exe` with parameter `-c`.


### Troubleshooting

If there are any problems during the verification then the first thing to look at are the debug logs
which are written by the different applications. The logs are generally found in
`c:\ProgramData\Sherlock\<APP_NAME>\<VERSION>\logs`. Notes:

1. If there is not enough information in the logs then you can change the log level in the application
  configuration file under the `DefaultLogLevel` configuration option. The available levels are (from
  most verbose to least verbose):
    * Trace
    * Debug
    * Info
    * Warn
    * Error
    * Fatal
    * None
1. The applications running in the test environment also log but those logs may be removed if the
  test environment is a virtual machine. However version 1.2 of the test configuration file has the
  possibly to copy the logs back to the host machine for inclusion into the test report. For this to
  work set the `includesystemlog` attribute of the `includeinreport` element to `true`.

Some standard problems that may occur are mentioned below.


#### Console and web service

- If the console application fails to connect to the web service because it cannot find the web
  service then verify that the web service can be reached. The two main problems that could be the
  root cause of this are either the web service is not running or the user which started the console
  application has no access rights to the web service.
- If the console application crashes due to a URL problem (see the log file) then it is most likely
  that you put a partial URL, e.g. `mycoolserver\sherlock.api` instead of `http://mycoolserver/sherlock.api`.
- If the console successfully manages to go through nearly all the test registration steps but fails
  on the transfer of the test files then there is quite likely a problem with the web service permissions
  to write to the `App_Data` directory.
- If the web service fails on the first call then there is quite likely a problem with the database
  connection. This is most likely either a problem with the connection string or a problem with the
  permissions. In case of a permission issue check if the user which is running the web service can
  access the stored procedures in the database.


#### Update service

- If the update service is unable to verify the update packages then it is not able to access the
  public key file. Make sure the configuration file points to the public key file and that this file
  is reachable by the service.


#### Master controller

- If the master controller fails to connect to the database this could point to either a problem with
  the connection string or a problem with the permissions. In case of a permissions problem again check
  that the user running the master controller can access the stored procedures in the database.
- If the master controller is unable to start a virtual machine then the *SherlockUser* may not have
  [permissions](https://blogs.msdn.com/b/virtual_pc_guy/archive/2008/01/17/allowing-non-administrators-to-control-hyper-v.aspx)
  to start the virtual machines. The log will show this as an error in the environment loading. Probably
  a security exception.
- If the controller is blocked by the firewall, or the firewall on the test environment is blocking,
  then there will be no communication between the test environment and the host. The log shows this
  through the fact that the host will wait an excessive amount of time for the remote 'endpoint' to
  connect. A normal start up takes around 2 minutes for a test environment start, operating system
  load and Sherlock load.
