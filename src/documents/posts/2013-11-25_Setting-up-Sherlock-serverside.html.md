---
title: 'Setting up Sherlock for regression testing - Server side'
tags: ['Sherlock']
commentIssueId: 5000
ignore: true
---

* Download from [GitHub](https://github.com/pvandervelde/Sherlock/releases). 

### Preparing the host machine

* Install the host operating system. Needs to be one that can have Hyper-V installed. Note that for the very least (at the moment) Sherlock.Service.Master needs to be installed on the host machine. Hence it's not possible to install the barebones Hyper-V version of Windows.
* Install IIS. Need:
 * ASP .NET 4.5
 * Basic authentication / Windows Authentication
 * Management tools
 * Http logging and tracing
* Install SQL Express 2012
 * Server management tools
* Probably easiest to use the same user as you use for your build server (you are using a separate user for that aren't you???)
* Create integration folder to hold all the files related to sherlock / testing. Create:
 * appupdate
 * console
 * service
 * web.api
 * web.intranet
 * reports
 * temp
* Share the `reports` and `console` directories so that they can be accessed over the network. The `console` directory only needs read access, the `reports` directory needs read and write access
* Install tools:
 * nAdoni
* Generate keys, put these in:
 * `<desired_location>\keys\public` for the public key and `<desired_location>\keys\private` for the private key. Can secure the private key in a different way if you so desire. Given that the keys are only used for your testing environment they are not super critical. Share the public key directory so that the VM's can get to them. 

### Database

see other documentation here: https://github.com/pvandervelde/Sherlock/wiki/Installation#database

* Create database called 'Sherlock'
* Apply all the SQL scripts, starting at the V1 script
* Permissions
 * Create SQL user that will be used to insert data into the database, grant db_datareader / db_datawriter & grant access to stored procedures using `GRANT EXEC TO <STORED_PROCEDURE_NAME> TO <SQL_USER>`. Use the following script to generate an access script for the user

        ``` 
        SELECT  'GRANT EXEC ON '+ SCHEMA_NAME(schema_id) + '.' + name + ' TO <SQL_USER>'
        from sys.procedures
        ORDER BY 1 
        ```
### IIS

see other documentation here: https://github.com/pvandervelde/Sherlock/wiki/Installation#web-parts

* Create directory for the appupdates. Give directory browse permissions. 
* Create subdirectory for both web projects
* Install both web projects (via 'Add application)
 * Needs to be .NET 4.5 application pool, with integrated pipeline
 * Normally pass through security should work, as long as the user has access to the directory
 * Set authentication to 'Windows authentication'
 * Watch the permissions. IIS is a pain



### AppUpdates

see other documentation here: https://github.com/pvandervelde/Sherlock/wiki/Installation#web-parts

* Unzip Sherlock.Service.Master and change the application configuration file. Rezip.
* Do the same for Sherlock.Service.Executor. Update both application config files.
* Create the manifests for the app update. Done through nAdoni. See useful msbuild script

<gist>6521946</gist>

### Services

see other documentation here: https://github.com/pvandervelde/Sherlock/wiki/Installation#hyper-v-host

* Unzip the `Sherlock.Console` package
* Unzip the `Sherlock.Service` packages
* App configs
* Install as service

* Console needs to be accessed from the outside (i.e from the build server and other services that need to register tests).


### Firewall

* On the server let Sherlock.Service.Master.exe through the firewall. Usually only private networks is enough


### Testing

* Use testing package (has one failing test, which is easy to 'unfail')
 * At this stage you can only test that the data will end up in the database, because you haven't set up any virtual machines yet. If you look in the Test table then you can see if everything is properly registered.

  