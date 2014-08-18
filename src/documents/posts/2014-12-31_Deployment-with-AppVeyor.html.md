---
title: 'Deployment with AppVeyor'
tags: ['AppVeyor', 'Deployment']
commentIssueId: 5000
ignored: true
---



* Setup - For the 'deploy' build
 * Only builds the master branch. Never automatically triggers
 * Automatically installs the [github-release]() application prior to starting the build
 * Before build pulls artifacts from latest 'compile' build. Using the [appveyor-deploy-restore-nbuildkit-workspace.ps1]() script
 * Not using the AppVeyor deploy because the scripts take care of all the deploys