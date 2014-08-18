---
title: 'Continuous integration with AppVeyor'
tags: ['AppVeyor', 'Continous integration']
commentIssueId: 5000
ignored: true
---

Describe

* What is [AppVeyor](http://www.appveyor.com/)
 * CI system in the cloud. Free for open source projects.
 * Gives you a machine with all .NET versions
 * Use powershell to make additional changes (or chocolatey)
* Which projects have we got on it 
 * nBuildKit. Have got a '[compilation](https://ci.appveyor.com/project/pvandervelde/nbuildkit)' build and a '[deploy](https://ci.appveyor.com/project/pvandervelde/nbuildkit-244)' build
* Setup - For the 'compilation' build
 * CI - builds all branches except the gh-pages branch
 * Config in the appveyor.yml file. Should probably move to the web-UI and remove the appveyor.yml file because that is confusing.
 * No deployment set up, but are storing the artifacts. These are needed by the 'deploy' build

  