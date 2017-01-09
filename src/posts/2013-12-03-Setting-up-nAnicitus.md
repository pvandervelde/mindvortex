Title: Setting up nAnicitus
Tags:
  - nAnicitus
  - Symbol server
  - SymStore
  - PDB
---

In this post I will explain how to install and configure the [nAnicitus](/projects/nanicitus.html)
windows service. nAnicitus is a windows service that acts as a gatekeeper for the
[SymStore][symstore_msdn] application. SymStore provides a relatively simple way to create a
local / private [symbol server][symbolserver_msdn].

This statement should bring up a few questions, cunning questions like:

1. Why would a development team even need a symbol server?
  The PDB files which are produced as the result of a build are just as unique as assemblies or executables.
  Each assembly has [one specific PDB](http://www.wintellect.com/blogs/jrobbins/pdb-files-what-every-developer-must-know)
  file to which it is linked via a GUID. Each time an assembly is build a new GUID is embedded,
  even if the source code has not changed. This means that in order to debug a given assembly for
  which you don't have the source code, which can happen if you debug other peoples libraries or if you
  are debugging a crash dump, then you will need the linked PDB file. Hence in order to enable
  debugging of releases one has to either place the PDB in the same location as the binaries or one
  has to store the PDB files in a symbol server.
1. Why would a development team not use SymStore directly?
  The disadvantage of SymStore is that it is not capable of processing
  [multiple PDB files at the same time][symstore_msdn_singletransaction], i.e. it should really only
  be called by one user at the time. By providing a windows service that synchronizes the access to
  the SymStore application it is possible for multiple users to add symbols to the symbol server
  without having to worry about the integrity of the symbol server files.

Before we continue with the installation of nAnicitus lets have a quick look at how nAnicitus works.

1. The user creates a
   [NuGet symbol package](http://docs.nuget.org/docs/creating-packages/creating-and-publishing-a-symbol-package)
   and places that in a pre-configured upload directory.
1. nAnicitus unpacks the symbol package and extracts the PDB files and the source files.
1. For each PDB file it is determined which source files were used to create it. Based on that
   information a [symbol stream][sourceserver_msdn] is created and inserted into the PDB file which
   points to the source server path for the source files belonging to the PDB file.
1. The PDB files are uploaded via [SymStore][symstore_msdn].
1. The source files are uploaded to the source server path.

Before installing nAnicitus it is necessary to install the
[debugging tools for windows](http://msdn.microsoft.com/en-us/library/windows/hardware/gg463009.aspx).
Make sure to install the complete set of tools so that you get all the symbol server tools as well.
Once the the debugging tools are installed you can [download](https://github.com/pvandervelde/nAnicitus/releases)
and unzip the latest version of nAnicitus.

The next step is to update the configuration file with the directory and UNC paths:

- **DebuggingToolsDirectory:** The debugging tools directory
  (e.g. `c:\Program Files (x86)\Windows Kits\8.0\Debuggers\x64`). This path may be left out if it is
  in the default location (as given here).
- **SourceIndexUncPath:** The UNC path to the directory where the indexed sources will be placed
  (e.g. `\\MyServer\sources`).
- **SymbolsIndexUncPath:** The UNC path to the directory where the indexed symbols (i.e. PDBs) will
  be placed (e.g. `\\MyServer\symbols`).
- **ProcessedPackagesPath:** The directory where the NuGet symbol packages will be dropped after they
  are processed. The NuGet symbol packages are saved in this directory so that it is possible to
  reprocess the packages if for instance the location of the source path changes, e.g. after
  switching to a new server.
- **UploadPath:** The directory where the NuGet symbol packages are placed for nAnicitus to process.

Finally to install the application as a windows service, open a command line window with administrative
permissions, navigate to the nAnicitus install directory and execute the following command:

    Nanicitus.Service install

Once the service is installed use the normal windows services control to change the properties of
the service.

And now you should have a working symbol server!

[symbolserver_msdn]:http://msdn.microsoft.com/en-us/library/windows/desktop/ms680693%28v=vs.85%29.aspx
[symstore_msdn]: http://msdn.microsoft.com/en-us/library/windows/hardware/ff558848(v=vs.85).aspx
[sourceserver_msdn]:http://msdn.microsoft.com/en-us/library/windows/desktop/ms680641%28v=vs.85%29.aspx
[symstore_msdn_singletransaction]: http://msdn.microsoft.com/en-us/library/windows/hardware/ff558851(v=vs.85).aspx
[sourceindexing_msdn]: http://msdn.microsoft.com/en-us/library/windows/hardware/ff556898(v=vs.85).aspx
[srcsrv_stream]: http://msdn.microsoft.com/en-us/library/windows/hardware/ff552219(v=vs.85).aspx
[snkfile_msdn]: http://msdn.microsoft.com/en-us/library/6f05ezxy(v=vs.110).aspx
