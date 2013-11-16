---
title: 'Setting up Sherlock for regression testing - Virtual machines'
tags: ['Sherlock']
commentIssueId: 5000
ignore: true
---

### Virtual machine

see other documentation here: https://github.com/pvandervelde/Sherlock/wiki/Installation#creating-virtual-machines

* Create a new Hyper-V virtual machine
* Install OS
* Patch OS (if necessary)
* Install .NET 4.5
* Patch .NET 4.5
* Install Sherlock.Service.exe
* Update the config file
* Setup auto start on the service. Can do as an actual service or by automatically starting the application when the user logs on to windows. In the second case you can also do UI testing. In the first case you don't need an active user
* If you need an active user see here: http://superuser.com/questions/243681/does-windows-7-allow-auto-login-with-a-stored-password-like-tweakui-did for auto log on
* Make sure that both Sherlock.Service and Sherlock.Service.Executor are allowed through the firewall. 
* Disable windows error reporting
* Save snapshot on VM
* Test VM by using the verification tool / scripts