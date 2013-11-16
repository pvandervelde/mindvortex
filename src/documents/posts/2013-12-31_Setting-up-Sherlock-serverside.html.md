---
title: 'Setting up Sherlock for regression testing - Server side'
tags: ['Sherlock']
commentIssueId: 5000
ignore: true
---

* Download from [GitHub](https://github.com/pvandervelde/Sherlock/releases). 

### Database

see other documentation here: https://github.com/pvandervelde/Sherlock/wiki/Installation#database

* Create database called 'Sherlock'
* Apply all the SQL scripts, starting at the V1 script
* Permissions?

### Services

see other documentation here: https://github.com/pvandervelde/Sherlock/wiki/Installation#hyper-v-host

* Unzip the `Sherlock.Console` package
* Unzip the `Sherlock.Service` packages
* App configs
* Install as service

* Console needs to be accessed from the outside (i.e from the build server and other services that need to register tests).


### AppUpdates

see other documentation here: https://github.com/pvandervelde/Sherlock/wiki/Installation#web-parts

* Unzip Sherlock.Service.Master and change the application configuration file. Rezip.
* Do the same for Sherlock.Service.Executor. Update both application config files.
* Create the manifests for the app update. Done through nAdoni. See useful msbuild script

<gist>6521946</gist>


### IIS

see other documentation here: https://github.com/pvandervelde/Sherlock/wiki/Installation#web-parts

* Create directory for the appupdates. 
* Create subdirectory for both web projects
* Install both web projects (via 'Add application)
 * Needs to be .NET 4.5 application pool, with integrated pipeline
 * Normally pass through security should work, as long as the user has access to the directory
 * Set authentication to 'Windows authentication'
 * Watch the permissions. IIS is a pain

### Firewall

* On the server let Sherlock.Service.Master.exe through the firewall. Usually only private networks is enough


### Testing

* Use testing package (has one failing test, which is easy to 'unfail')

  