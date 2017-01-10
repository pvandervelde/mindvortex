Title: Nuclei release - V0.8.0
Tags:
  - Nuclei
---

Version [V0.8.0](https://github.com/pvandervelde/Nuclei/releases/tag/0.8.0) of the
[Nuclei](/projects/nuclei.html) library has been released.

This release introduces a few large features to Nuclei.Communication library and adds some minor
updates to the base Nuclei library.

The main focus of this release was adding version tolerance ([#3](https://github.com/pvandervelde/Nuclei/issues/3))
to the different layers of the communication stack:

- _The discovery layer_ - Provides ways to discover remote endpoints either automatically (via [WCF discovery][wcf_discovery])
  or manually.
- _The protocol layer_ - Provides the means to send messages to one or more remote endpoints and
  handling the responses to those messages if they are expected.
- _The interaction layer_ -  Provides an abstraction over the _protocol layer_ in the form of an
  proxy objects that provide user-defined methods which can be invoked on a remote endpoint.

In version 0.8.0 of the Nuclei.Communication library each of these layers now supports the ability
to negotiate with a remote endpoint to determine which communication version will be used to exchange
data between the endpoints. The  communication version which will be used is the highest (i.e. most
recent) version that both endpoints support. If the endpoint do not support the same versions then
communication will not be enabled between the endpoints.

The second focus was to improve the robustness of all the network activity. The main changes here were:

- [#7](https://github.com/pvandervelde/Nuclei/issues/7) - Detection of messages that have not received
  their response within a given time-out.
- [#11](https://github.com/pvandervelde/Nuclei/issues/11), [#17](https://github.com/pvandervelde/Nuclei/pull/17),
  [#18](https://github.com/pvandervelde/Nuclei/pull/18) - Method(s) to detect if a remote endpoint is
  still available and discard endpoint information if it is not.
- [#19](https://github.com/pvandervelde/Nuclei/issues/19),
  [#23](https://github.com/pvandervelde/Nuclei/issues/23) - Automatically rebuilding the communication
  channel if it faults during message sending and then resend the message that caused the faulting.

The final focus was on decoupling the interaction interfaces from their implementations. With these
changes an endpoint does not need to provide concrete implementations of either the command
([#6](https://github.com/pvandervelde/Nuclei/pull/6)) and notification ([#31](https://github.com/pvandervelde/Nuclei/pull/31))
interfaces but can map the members on those interfaces to equivalent members on any given object.

Additionally it is now possible for some parameters on a command interface method (ie. the method
on a command interface) and a command object method (i.e .the concrete instance method that is
mapped to the given command) to contain parameters that have a special meaning. The available
options are:

- For command interface methods ([#23](https://github.com/pvandervelde/Nuclei/issues/23))
    * Provision of a time-out indicating the maximum amount of time the endpoint should wait for a
      response to the command invocation request.
    * Provision of a retry count indicating the maximum number of times the endpoint should send the
      command invocation request should any errors occur during invocation.
- For command instance methods ([#28](https://github.com/pvandervelde/Nuclei/pull/28))
    * Provision of the ID of the endpoint requesting the invocation of the command method.
    * Provision of the ID of the message that was send to request the invocation of the command method.

Finally the Nuclei library versioning was switched to use [semantic versioning](http://semver.org/).

[wcf_discovery]: http://msdn.microsoft.com/en-us/library/dd456782%28v=vs.110%29.aspx
