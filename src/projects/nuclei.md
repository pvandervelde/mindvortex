Title: 'Nuclei'
Lead: "Nuclei is a collection of libraries containing classes and functions for inter-application communication, dealing with run time discovered plugins, diagnostics, configuration information from different sources,
exception handling and assembly location and loading."
Tags:
  - Project
ShowInNavbar: false
---

[Nuclei](https://github.com/thenucleus) is a collection of libraries containing classes and functions for inter-application communication, dealing with run time discovered plugins, diagnostics, configuration information from different sources,
exception handling and assembly location and loading.

The capabilities in Nuclei are currently divided as follows:

* [Nuclei](https://github.com/thenucleus/Nuclei) - Base classes and interfaces, mostly used by the other libraries.
* [Nuclei.Build](https://github.com/thenucleus/nuclei.build) - Assembly attributes which can be used at build time to embed information about the specific build into an assembly, e.g. time and date of build or information describing the version control revision of the source code that was used to create the assembly.
* [Nuclei.Communication](https://github.com/thenucleus/nuclei.communication) - Provides classes, interfaces and delegates used to provide a means of interacting between two or more applications through one or more command interfaces (similar to a Remote Procedure Call (RPC)). Capabilities include:
    * Based on WCF. Currently implemented methods for using TCP and named-pipes as base network layers.
    * Discovery of communication sources on the local machine and the local network (using WS discovery).
    * Automatic exchange of connection parameters between endpoints, if endpoints desired to communicate on the same topics (i.e. using an API that is familiar to both).
    * User provides command and notification interfaces which provide asynchronous methods which can be called by remote endpoints. Command parameters and return data are transported over via a message based mechanism.
* [Nuclei.Configuration](https://github.com/thenucleus/nuclei.configuration) - Provides an abstraction of a configuration. Build-in support for configuration via an application config file, a collection of constant values or via the [Consul](https://consul.io) distributed key-value store.
* [Nuclei.Diagnostics](https://github.com/thenucleus/nuclei.diagnostics) - Provides interfaces and base classes for logging and and in-application measuring of performance.
    * [Nuclei.Diagnostics.Logging.NLog](https://github.com/thenucleus/nuclei.diagnostics.logging.nlog) - Implementation of the logging interfaces and base classes for [NLog]().
* [Nuclei.Nunit.Extensions](https://github.com/thenucleus/nuclei.nunit.extensions) - Contains a simple implementation of contract verification for NUnit. Ideas based on the
[contract verifiers in MbUnit](http://interfacingreality.blogspot.co.nz/2009/03/contract-verifiers-in-mbunit-v307.html). Currently only has verifiers for hash code and equality.
* [Nuclei.Plugins](https://github.com/thenucleus/nuclei.plugins) - A set of libraries that provide methods for discovering MEF based plugins at run time from both bare assemblies and NuGet packages, gathering and storing plugin metadata
  without keeping the plugin assemblies loaded and then loading the selected assemblies from their original source when the plugins are activated.

* [Nuclei.AppDomains](https://github.com/thenucleus/nuclei.appdomains) - Provides classes for the creation of AppDomains with pre-set assembly resolve and exception handlers.
* [Nuclei.ExceptionHandling](https://github.com/thenucleus/nuclei.exceptionhandling) - Provides exception filters for use in top level exception recording.
* [Nuclei.Fusion](https://github.com/thenucleus/nuclei.fusion) - Provides methods for assembly resolve requests.
