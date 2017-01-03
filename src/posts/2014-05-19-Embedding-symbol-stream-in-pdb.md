Title: Embedding a symbol stream in a PDB file
Tags:
  - Source server
  - PDB
  - Symbol stream
  - SRCSRV
  - nAnicitus
  - UNC
commentIssueId: 39
---

The [nAnicitus](/projects/nanicitus.html) application processes [NuGet symbol](http://docs.nuget.org/docs/creating-packages/creating-and-publishing-a-symbol-package) packages to push the symbols and sources up to their respective location for the symbol and source servers to work. In order to have a symbol server nothing special needs to be done, just push the symbols through the [SymStore][symstore_msdn] application and a nice directory with indexed symbols is created. However in order to allow debuggers to obtain the source files related to a given PDB some manipulation of the PDB files is necessary. Specifically the SRCSRV stream in the PDB file needs to be [modified][modifying_srcsrv_stream].

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

* **`Version = 2`** - Indicates the version of the SRCSRV stream
* **`VerCtrl = http`** - 'Version control' is done through HTTP. This variable is potentially optional.
* **`SRCSRVVERCTRL = http`** - Specifies the VCS in use. In this case that's UNC, potentially over http.
* **`UNCROOT`** - 'Local variable' indicating what the UNC root path is.
* **`HTTP_EXTRACT_TARGET`** - 'Local variable' indicating how to determine the path of a source file on the server given it's embedded path and SRCSRV information.
* **`SRCSRVTG`** - The template used by the debugger to determine the path of the source files based on their embedded path and SRCSRV information.
* **`SRCSRVCMD`** - The command for the VCS to extract the source files. For UNC this is not required.

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

The process of pushing the symbols and sources up to their respective locations with nAnicitus is done via the following steps:

1. The user drops the NuGet symbol package containing the binaries, PDB files and source files into the designated upload folder for nAnicitus.
* nAnicitus detects the new NuGet package and pushes the file path onto the queue for processing by the indexing thread.
* The indexing thread pulls the file path from the queue and unzips the NuGet symbol package in a temporary location.
* For each PDB the source paths are extracted from the PDB with `scrtool.exe`.
* For each source path the matching source file is located by looking at all source files and seeing source file path matches the 'best', i.e. using the longest common substring approach, starting from the end of the path in order to ensure a match on the file name.
* Once the source file is located the relative file path for the source file on the source server is calculated.
* Once all the source files from the PDB are processed the SRCSRV stream file is created and embedded into the PDB with `pdbstr.exe`.
* Once all PDBs have been indexed they are pushed through the `symstore.exe` tool to the symbol server.
* The source files are copied to the desired directory on the source server.
* Finally the original NuGet symbol package is moved to the directory containing all the processed symbol packages.

Note that the path to the source server directory is embedded in the PDB. If the location of the source server changes then the information in the PDB files will no longer be correct. While there is a way to redirect the embedded paths nAnicitus also stores the processed NuGet symbol packages in a designated directory. This makes it possible to re-process the packages should the need ever arise.

[symstore_msdn]: http://msdn.microsoft.com/en-us/library/windows/hardware/ff558848(v=vs.85).aspx
[sourceserver_msdn]:http://msdn.microsoft.com/en-us/library/windows/desktop/ms680641%28v=vs.85%29.aspx
[modifying_srcsrv_stream]:http://msdn.microsoft.com/en-us/library/windows/hardware/ff552219%28v=vs.85%29.aspx
[pdbstr_tool]: http://msdn.microsoft.com/en-us/library/windows/hardware/ff558874%28v=vs.85%29.aspx
[srcsrv_v1]:http://msdn.microsoft.com/en-us/library/windows/hardware/ff551958%28v=vs.85%29.aspx
[srcsrv_v2]:http://msdn.microsoft.com/en-us/library/windows/hardware/ff551966%28v=vs.85%29.aspx
