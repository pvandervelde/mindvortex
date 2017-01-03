Title: 'Nuclei'
Lead: "Nuclei is a collection of libraries containing classes and functions for inter-application interaction via a command mechanism, diagnostics, configuration handling, exception handling and assembly location and loading."
Tags:
  - Project
ShowInNavBar: false
---

[Nuclei](http://pvandervelde.github.io/Nuclei) is a collection of libraries containing classes and functions for inter-application interaction via a command mechanism, diagnostics, configuration handling,
exception handling and assembly location and loading.

The capabilities in Nuclei are currently divided as follows:

* __Nuclei__ - Base classes and interfaces, mostly used by the other libraries.
* __Nuclei.Build__ - Assembly attributes which can be used at build time to embed information about the specific build into an assembly, e.g. time and date of build or information describing the version control revision of the source code that was used to create the assembly.
* __Nuclei.Communication__ - Provides classes, interfaces and delegates used to provide a means of interacting between two or more applications through one or more command interfaces (similar to a Remote Procedure Call (RPC)). Capabilities include:
    * Based on WCF. Currently implemented methods for using TCP and named-pipes as base network layers.
    * Discovery of communication sources on the local machine and the local network (using WS discovery).
    * Automatic exchange of connection parameters between endpoints, if endpoints desired to communicate on the same topics (i.e. using an API that is familiar to both).
    * User provides command and notification interfaces which provide asynchronous methods which can be called by remote endpoints. Command parameters and return data are transported over via a message based mechanism.
* __Nuclei.Configuration__ - Provides an abstraction of a configuration. Build-in support for configuration via an application config file.
* __Nuclei.Diagnostics__ - Provides classes for logging (using NLog) and and in-application measuring of performance.
* __Nuclei.Nunit.Extensions__ - Contains a simple implementation of contract verification for NUnit. Ideas based on the
[contract verifiers in MbUnit](http://interfacingreality.blogspot.co.nz/2009/03/contract-verifiers-in-mbunit-v307.html). Currently only has verifiers for hashcode and equality.

* __Nuclei.AppDomains__ - Provides classes for the creation of AppDomains with pre-set assembly resolve and exception handlers.
* __Nuclei.ExceptionHandling__ - Provides exception filters for use in top level exception recording.
* __Nuclei.Fusion__ - Provides methods for assembly resolve requests.
