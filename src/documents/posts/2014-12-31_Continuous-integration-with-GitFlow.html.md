---
title: 'Continuous integration of GitFlow branches'
tags: ['Jenkins', 'Continous integration', 'GitVersion']
commentIssueId: 5000
ignored: true
---

The [Apollo](/projects/apollo.html) project uses [GitFlow](http://nvie.com/posts/a-successful-git-branching-model/) as its branching approach. Because of the structured nature of this model it is possible to automate 

 
Have:

* Continuous integration on the feature, release and hot fix branches. Continuous integration executes the following steps
 * Get source from GIT
 * Locally rebase on the respective 'target' branch. For feature branches this is develop and for hot fix and release branches this is master. If rebase fails, then fail build. Make developer do a rebase + fix the merge errors and then recommit
 * Build binaries
 * Execute unit tests
 * Create NuGet packages and MSI installers
 * Process resulting output files (e.g. unit test results, coverage etc.)
 * Archive artifacts (NuGet packages, MSI installers etc. etc.)
 * Notify developer of success via email or Jabber
* Promotion build jobs for feature, release and hot fix branches. Promotion build jobs grab the current head of a branch, locally merge it in to the target branch and then execute build + tests. If all is well then merge is pushed. Steps are:
 * Get sources from GIT
 * Locally merge to the respective target branch. If merge fails then fail the build and make the developer update the branch so that the merge would work and recommit
 * Build binaries
 * Execute unit tests
 * Create artifacts (NuGet packages, MSI installers, machine images etc. etc.)
 * Process output files
 * Execute smoke tests
 * Execute integration tests
 * Execute regression tests
 * Execute performance tests
 * Execute validation tests
 * Publish artifacts
 * Push changes to target branch
 * Push tags 