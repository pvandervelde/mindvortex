---
title: 'Setting up Sherlock for regression testing - Virtual machines'
tags: ['Sherlock']
commentIssueId: 5000
ignore: true
---

### Virtual machine

see other documentation here: https://github.com/pvandervelde/Sherlock/wiki/Installation#creating-virtual-machines

* An executor service on each VM which orchestrates the test execution
* An executor application on each VM which executes the test steps. This is separate from the executor service so that a) it is possible to run multiple applications under different accounts (currently not possible but planned in future releases), b) to run the application on the desktop while the service is running as a service.
 

* Create a new Hyper-V virtual machine
* Set up the network so that it minimally can see the Host machine and any other VM's from the same host machine. (Note: Windows networks can throw out the VM's after a while due to some secret key that they use to determine if the machine has been online recently etc. etc.).
* Install OS
* Patch OS (if necessary)
* Install .NET 4.5
* Patch .NET 4.5

* If you need an active user then you need to make sure the specific users automatically logs on when the PC starts. Use [Autologon](http://technet.microsoft.com/en-us/sysinternals/bb963905.aspx) for this because it encrypts the password etc.
* If you are on Windows 8 make sure you [automatically switch to the desktop](http://www.7tutorials.com/how-boot-desktop-windows-8-skip-start-screen) 
* Make sure that both Sherlock.Service and Sherlock.Service.Executor are allowed through the firewall. 
* Disable [windows error reporting]()
* Disable automatic updates (don't even download them, it's pointless as the machine gets reset every time after use anyway)
* Disable the [screensaver]() and the [automatic locking of the desktop](). [Why do I need to do that?](http://www.brianbondy.com/blog/id/100/).
* Disable UAC (otherwise you can't execute MSI installs, even if your user is an admin).
 * Note that in some cases corporate network controls / group policies can play havoc with carefully laid plans, e.g. disabling the UAC on Windows 8 through a group policy may not give the results you expect. In this case create a local admin user to run the regression test.

* Install Sherlock.Service.exe
* Update the config file
* Setup auto start on the service. Can do as an actual service or by automatically starting the application when the user logs on to windows. In the second case you can also do UI testing. In the first case you don't need an active user. 


* Save snapshot on VM
* Add to database