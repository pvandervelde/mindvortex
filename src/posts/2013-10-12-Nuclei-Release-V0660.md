Title: Nuclei release - V0.6.6.0
Tags:
  - Nuclei
commentIssueId: 11
---

Version [V0.6.6.0](https://github.com/pvandervelde/Nuclei/releases/tag/V0.6.6.0) of the [Nuclei](/projects/nuclei.html) library has been released. This release adds the ability to specify the name and version of the application in the log file. If no application name or version is specified then the information from `Assembly.GetEntryAssembly()` is used.

The application name and version can be specified when creating a new logger via the `LoggerBuilder` like so:

``` cs
IConfiguration configuration = new MyConfiguration();
var logger = LoggerBuilder.ForFile(
    @"c:\mylogfile.txt",
    new DebugLogTemplate(configuration, () => DateTimeOffset.Now),
    applicationName,
    applicationVersion);
```
