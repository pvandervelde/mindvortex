---
title: 'Setting up Sherlock for regression testing - Verification'
tags: ['Sherlock']
commentIssueId: 5000
ignore: true
---

After the configuration of the [host machine](/posts/2013-12-10_Setting-up-Sherlock-serverside.html) and the [virtual machines](/posts/2013-12-11_Setting-up-Sherlock-virtualmachines.html) the final step in the configuration of Sherlock is to verify that everything is configured correctly. This can be done by using the verification package that comes with each [release](https://github.com/pvandervelde/Sherlock/releases) of Sherlock. In order to use 


Test steps are:

*  Unpack **verification.zip** to a temp directory somewhere (e.g. `c:\temp\sherlock`).
*  Update the `Sherlock.VerificationConfiguration.msbuild` file with the following settings:
 * **ConfigurationReportDirectory:** Point to the directory where you want the final report to be placed. Note that both the executing user and the testing user need to be able to get to this directory. Safest bet is the `report` directory that was created on the [host]() machine
 * **ConfigurationServerUrl:** The URL of the web service, e.g. `http:\\myhostmachine\sherlock.api`
 * **ConfigurationOperatingSystem:** The operating system name that you want to test with. This needs to match one of the operating systems that has been registered with the management website and which is installed on at least one of your virtual machines
 * **ConfigurationOperatingSystemServicePack:** Can be left empty, but if not then it needs to match the Service Pack name of the operating system as registered with the management web site.
 * **ConfigurationOperatingSystemCulture:** Again match the registered operating system.
 * **ConfigurationOperatingSystemPointerSize:** Again match the registered operating system.
 * **ConfigurationRemotePcWorkingPath:** A path where the test files will be placed on the test environment. Usually `c:\temp` is a safe bet.
 * **ConfigurationSherlockConsoleDirectory:** The directory where the console application is installed, this may be a UNC path or a normal directory, e.g. `\\MyHostMachine\console`.
* Execute the `Sherlock.ExecuteVerificationTests.msbuild` file (using MsBuild of course). This script will prepare the files to be send across (a test application and some test scripts), start the console application, register the test and then wait for the reports to be produced. The reports should come back with some errors (on purpose, so that the error handling can be tested). There should be 3 reports, one for each allowed test configuration version (v1.0, v1.1 and v1.2). The following steps should error out:
 * V1.0: Last script execution. Executes `c:\temp\Sherlock.Verification.Console.exe` with the '-f' command line argument. Process should exit with an exit code of 1 (anything other than 0 is failure)
 * V1.1: script execution for `c:\temp\Sherlock.Verfication.Console.exe` with parameter '-f' (exit code 1), with parameter '-c' (exit code probably -532462766). Application execution for the same app with the same parameters
 * V1.2: Same as V1.1


* Use testing package (has one failing test, which is easy to 'unfail')
 * At this stage you can only test that the data will end up in the database, because you haven't set up any virtual machines yet. If you look in the Test table then you can see if everything is properly registered.




## Troubleshooting

Always look at the logs. They should tell you where things start failing. Each part of Sherlock produces it's own logs. Those can in general be found in `c:\ProgramData\Sherlock\<APP_NAME>\<VERSION>\logs`. Note that the logs on the virtual machines are written but also terminated when the VM is reset.

### Console
* Fail to connect to the web service - Can't find it, check the URL is ok
* Falls over - Configuration problem. Most likely the URL isn't a full URL, always start URL with http.

### Web service

* Fail to connect - problem with permissions on the user(?) Try using a REST tool in a web browser to see if you can connect to the API.
* Fail on database call - Happens as the API is called the very first time. Can't reach the database for some reason. Possibly permission issue with the database.
* Fail to store test data - problem with permissions on the App_Data directory

### Update service

* Can't find updates - Problems seeing update URL
* Can't verify updates - Public key file in the wrong place / config points to the wrong file, make sure it points to the public key file AND that this file is reachable by the service (network permissions etc.)

### Master controller

* Fail on start up - Config wrong? Missing DLLs
* Fail on database call - Can't reach database, possibly permission issue, wrong connection string

### Virtual machines

* If the service can't start a virtual machine then the *SherlockUser* may not have [permissions](http://blogs.msdn.com/b/virtual_pc_guy/archive/2008/01/17/allowing-non-administrators-to-control-hyper-v.aspx) to start the virtual machines. The log will show this as an error in the environment loading. Probably a security exception.
* If the service is blocked by the firewall (or the firewall on the VM is blocking) then there will be no communication between the VM and the host. The log shows this through the fact that the host will wait an excessive (normal start up takes around 2 minutes for a VM + OS load + sherlock load) amount of time for the remote 'endpoint' to connect (cut off time is about 10 minutes)