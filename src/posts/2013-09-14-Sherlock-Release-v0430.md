Title: Sherlock release - V0.4.3.0
Tags:
  - Sherlock
---
Version [V0.4.3.0](https://github.com/pvandervelde/Sherlock/releases/tag/v0.4.3.0) of the
[Sherlock](/projects/sherlock.html) regression testing application has been released. This release
provides several bug fixes for:

- The console application: Changed the way the REST URLs are constructed so that it works if the web
  service on a sub-part of a domain, e.g. `http://myserver/sherlock` works now
- The web service: Added Trace.Write statements for ease of debugging
- The windows service: Fixed a dead-lock bug in the shut-down process and linked all processes via
  a Windows Job Object to ensure that all child processes are terminated if the service is terminated.
