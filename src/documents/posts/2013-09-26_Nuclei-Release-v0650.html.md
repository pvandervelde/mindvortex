---
title: 'Nuclei release - V0.6.5.0'
tags: ['Nuclei']
commentIssueId: 10
---

Version [V0.6.5.0](https://github.com/pvandervelde/Nuclei/releases/tag/V0.6.5.0) of the [Nuclei](/projects/nuclei.html) library has been released. This release adds an option to allow the user to select which
types of channels the communication layer is allowed to use. The communication layer can be allowed to use TCP/IP channels, named pipe channels or both.

In the previous versions in the constructor of the `CommunicationModule` needed to be provided with a 
list of [communication subjects](https://github.com/pvandervelde/Nuclei/wiki/Nuclei.Communication#communicationsubject) and a flag indicating if [channel discovery](https://github.com/pvandervelde/Nuclei/wiki/Nuclei.Communication#endpoints-and-their-discovery) was allowed.

``` cs
var builder = new ContainerBuilder(); 
builder.RegisterModule(
    new CommunicationModule(
        new List<CommunicationSubject>
            {
                CommunicationSubjects.Dataset,
            },
        false));
```

In V0.6.5.0 an extra parameter needs to be provided which indicates which types of channel the communication layer is allowed to use to communicate with other instances. The allowable options are `ChannelType.NamedPipe` and `ChannelType.TcpIP`.

``` cs
var builder = new ContainerBuilder();
builder.RegisterModule(
    new CommunicationModule(
        new List<CommunicationSubject>
            {
                CommunicationSubjects.Dataset,
            },
        new[]
            {
                ChannelType.NamedPipe,
                ChannelType.TcpIP,
            }, 
        false));
```