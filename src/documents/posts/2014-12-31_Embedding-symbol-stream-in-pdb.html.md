---
title: 'Embedding a symbol stream in a PDB file'
tags: ['Source server', 'PDB', 'Symbol stream', 'SRCSRV', 'nAnicitus', 'UNC']
commentIssueId: 5000
ignore: true
---

The [nAnicitus](/projects/nanicitus.html) application processes [NuGet](nuget.org) symbol packages to push the symbols and sources up to their respective location for the symbol and source servers to work. In order to have a symbol server nothing special needs to be done, just push the symbols through [SymStore][symstore_msdn] and a nice directory with indexed symbols is created. However in order to allow debuggers to obtain the source files related to a given PDB some manipulation of the PDB files is necessary. Specifically the SRCSRV stream in the PDB file needs to be [modified][modifying_srcsrv_stream].

The documentation gives a decent overview of how the source indexing works but it does not actually provide the information necessary to determine what should be written to the SRCSRV stream for a given PDB file. In fact if you want to know what information should be written to the SRCSRV stream if you want to store the indexed source files in a directory instead of getting them from your source control system then even the almighty [google](https://www.google.co.nz/webhp?tab=ww&ei=FwljU6S7J8byoATTxoLIAQ&ved=0CBMQ1S4#q=PDB+SRCSRV+UNC+VERSION%3D2) is rather quiet.   

In order to write to the SRCSRV stream one can use the [PDBStr utility][pdbstr_tool]. However that still leaves the question of what to write to the stream. The [source server documentation][sourceserver_msdn] provides examples for [VERSION 1][srcsrv_v1] streams, i.e. the kind that point the debugger to a source control (VCS) command. If however you want to store symbols and sources in a UNC path then you need [VERSION 2][srcsrv_v2] streams. With some help from this [blog post](http://www.jayway.com/2011/06/19/hosting-your-own-source-symbol-server/), some digging at MSDN and lots of trial-and-error it seems that the SRCSRV stream should look like:  

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

In this stream the [variables mean][srcsrv_v1]:

* **Version = 2** - Indicates the version of the SRCSRV stream
* **VerCtrl = http** - 'Version control' is done through HTTP. This variable is potentially optional.
* **SRCSRVVERCTRL = http** - Specifies the VCS in use. In this case that's UNC, potentially over http.
* **UNCROOT** - 'Local variable' indicating what the UNC root path is.
* **HTTP_EXTRACT_TARGET** - 'Local variable' indicating how to determine the path of a source file on the server given it's embedded path and srcsrv information.
* **SRCSRVTG** - The template used by the debugger to determine the path of the source files based on their embedded path and srcsrv information.
* **SRCSRVCMD** - The command for the VCS to extract the source files. For UNC this is not required.

When nAnicitus processes a PDB file it generates a SRCSRV file that looks similar to this:

    SRCSRV: ini ------------------------------------------------
    VERSION=2
    INDEXVERSION=2
    VERCTRL=http
    SRCSRV: variables ------------------------------------------
    SRCSRVVERCTRL=http
    UNCROOT=\\MyServer\sources
    HTTP_EXTRACT_TARGET=%UNCROOT%\%var2%\%var3%\%var4%
    SRCSRVTRG=%http_extract_target%
    SRCSRVCMD=
    SRCSRV: source files ---------------------------------------
    c:\source\MyProject\MyClass.cs*MyProject*1.2.3.4*MyProject\MyClass.cs
    SRCSRV: end------------------------------------------------

The redirection of the source paths is handled as `<FILE>*<PROJECT>*<VERSION>*<RELATIVE_FILE>` which means that the `c:\source\MyProject\MyClass.cs` file will be found on the source server at `\\MyServer\sources\MyProject\1.2.3.4\MyProject\MyClass.cs`

Done via:

* Extract source paths from PDB with `scrtool.exe`.
* For each path determine the base path. This is done by finding the matching source file (which are embedded in the NuGet symbol package) (currently done by looking at all source files and seeing source file path matches the 'best' (i.e. longest common substring, starting from the end of the path))
* Create the relative file path with the source file as base
* Once the relative paths for all files are known, create the srcsrv stream file
* Embed the srcsrv stream file in the PDB with `pdbstr.exe`
* Push the PDB's through the `symstore.exe` tool
* Copy the sources to the correct directory in the source server path. 


* Note that the path to the source server directory is embedded in the PDB. While there is a way to redirect that with the help of [??]() nAnicitus also stores the processed NuGet symbol packages, thus making it possible to reprocess those packages should the need ever arise (e.g. moving server)

Debugging

* Don't forget about the srctool.exe application. This lets you read the actual embedded source streams in a PDB. Very useful for debugging.
* PDBStr allows you to write out the srcsrv stream to a file. Note that this tool is not well documented and pretty finicky.


[symstore_msdn]: http://msdn.microsoft.com/en-us/library/windows/hardware/ff558848(v=vs.85).aspx
[sourceserver_msdn]:http://msdn.microsoft.com/en-us/library/windows/desktop/ms680641%28v=vs.85%29.aspx
[modifying_srcsrv_stream]:http://msdn.microsoft.com/en-us/library/windows/hardware/ff552219%28v=vs.85%29.aspx
[pdbstr_tool]: http://msdn.microsoft.com/en-us/library/windows/hardware/ff558874%28v=vs.85%29.aspx
[srcsrv_v1]:http://msdn.microsoft.com/en-us/library/windows/hardware/ff551958%28v=vs.85%29.aspx
[srcsrv_v2]:http://msdn.microsoft.com/en-us/library/windows/hardware/ff551966%28v=vs.85%29.aspx
