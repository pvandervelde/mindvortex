---
title: 'Embedding a symbol stream in a PDB file'
tags: ['Source server', 'PDB', 'Symbol stream', 'SRCSRV', 'nAnicitus']
commentIssueId: 5000
ignore: true
---

* In order to have a symbol server you don't need anything special (just push your symbols through [SymStore][symstore_msdn]. However in order to also have a source server (which can get the sources that match your symbols) you need to edit the SRCSRV stream in the PDB files.
* You can write to this stream via the PDBStr utility. With this utility you can write the contents of a file to the SRCSRV stream in a given PDB file. The one big question is what do you write?
* Good place to start is the [source server documentation][sourceserver_msdn].
* Most examples are for VERSION=1 type streams, i.e. the kind that get your sources from a version control system (you can then embed the command to the VCS in the PDB to get your sources). If however you just want a UNC path then you need VERSION=2

* Source paths are embedded as: `<FILE>*<PROJECT>*<VERSION>*<RELATIVE_FILE>`
* Path for extract target made from
 * UNCROOT 
 * %var2%
 * %var3%
 * %var4%

* Original example from: http://www.jayway.com/2011/06/19/hosting-your-own-source-symbol-server/. See the attachment to the blog post
* Combined with an (unhealthy) dose of MSDN and google and trial-and-error


```
SRCSRV: ini ------------------------------------------------
VERSION=2
INDEXVERSION=2
VERCTRL=http
SRCSRV: variables ------------------------------------------
SRCSRVVERCTRL=http
UNCROOT= <UNC_SOURCE_PATH>
HTTP_EXTRACT_TARGET=%UNCROOT%\\ + <UNC_SOURCE_PATH>
SRCSRVTRG=%http_extract_target%
SRCSRVCMD=
SRCSRV: source files ---------------------------------------
```

Meaning

* Version = 2
* IndexVersion = 2
* VerCtrl = http
* SRCSRVVERCTRL = http
* UNCROOT
* HTTP_EXTRACT_TARGET
* SRCSRVTG
* SRCSRVCMD



Debugging

* Don't forget about the srctool.exe application. This lets you read the actual embedded source streams in a PDB. Very useful for debugging.


[symstore_msdn]: http://msdn.microsoft.com/en-us/library/windows/hardware/ff558848(v=vs.85).aspx
[sourceserver_msdn]:http://msdn.microsoft.com/en-us/library/windows/desktop/ms680641%28v=vs.85%29.aspx