---
title: 'Jenkins in Azure'
tags: ['Jenkins', 'Azure']
commentIssueId: 5000
ignored: true
---

* Plan is to find out if it is possible (and cost effective) to run Jenkins on a cloud platform. In our case Azure was selected because Microsoft is so kind to provide me with some Azure credits through my MSDN account (thanks Microsoft and thanks Vista)
* The final plan is:
    * Create a small VM for the jenkins master. No executors will exist on that machine.
    * Create an image for a Jenkins slave. Then use the [Azure Slave plugin](https://wiki.jenkins-ci.org/display/JENKINS/Azure+Slave+Plugin) to create new slaves as they are required.
* Want to make the machines so that it is easy to upgrade the machine with a new one without losing any of the data. Sort of 'immutable server' / ['phoenics server'](http://martinfowler.com/bliki/PhoenixServer.html) idea.
    * Will redirect the build data to a share that lives in Azure blob storage (Jenkins -> Configuration -> Build Record Root Directory).
    * Will store the configuration in a git repository via the [SCM Sync Configuration plugin](). This shoulds allow us to restore it easily
* Going to try to not directly access the machine or the jenkins instance for triggering builds or changing configurations
* Not quite sure how we're going to deal with new configurations
* All code will be available via [github](https://github.com/pvandervelde/azure-jenkins)